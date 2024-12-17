class Api::SeleniumController < ApplicationApiController
  skip_before_action :authorize_request, only: %i[login_user software_version]
  skip_before_action :check_current_user, only: %i[login_user software_version]

  def login_user
    email = params.dig(:username)
    password = params.dig(:password)
    if (email.present? and password.present?)
      user = User.where(email: email).first
      valid_password = user.valid_password?(password)
      if valid_password
        token = User.generate_jwt_token(user.email)
        render(json: { message: 'Successfully logged in!', data: token, status: true }, status: :ok)
      else
        render(json: { message: 'Invalid email or password.' }, status: :precondition_failed)
      end
    else
      render(json: { message: 'Invalid email or password11.' }, status: :precondition_failed)
    end
  end

  def software_version
    version = params[:version]
    return render_result(false, 'Please provide a valid version!') unless version.present?
    begin
      @software_version = SoftwareVersion.where(name: version, software_type: SoftwareVersion::SOFTWARE_TYPES[:JAVA]).select(
        :id, :name, :description
      ).take

      return render_result(false, 'Release notes not found!') unless @software_version.present?

      render_result(true, 'Release notes retrieved successfully!', @software_version, nil, 200)
    rescue StandardError => error
      log_exception(error, 'software_version')
      render_result(false, 'Failed to retrieve release notes!', nil, nil, 500)
    end
  end

  def get_projects
    begin
      @projects = Current.user.assign_projects.select(:id, :name).as_json

      # @projects = @projects.sort_by do |p|
      #   if p.id == @current_user.default_project_id
      #     0
      #   else
      #     1
      #   end
      # end
      render_result(true, 'Projects retrieved successfully!', @projects, nil, 200)
    rescue StandardError => error
      log_exception(error, 'get_projects')
      render_result(false, 'Failed to retrieve projects!', nil, nil, 500)
    end
  end

  def get_environments
    return render_result(false, 'Please provide a valid project id!') if params[:project_id].blank?

    begin
      @environments = Environment.where(project_id: params[:project_id]).select('id, name')
      # @environments = @environments.sort_by do |e|
      #   if e.id == @current_user.default_environ
      #     0
      #   else
      #     1
      #   end
      # end
      render_result(true, 'Environments retrieved successfully!', @environments, nil, 200)
    rescue StandardError => error
      log_exception(error, 'get_environments')
      render_result(false, 'Failed to retrieve environments!', nil, nil, 500)
    end
  end

  def get_environment
    return render_result(false, 'Please provide a valid environment id!') if params[:environment_id].blank?
    begin
      @environment = Environment.where(id: params[:environment_id]).take
      return render_result(false, 'Environment not found!') unless @environment.present?
    rescue StandardError => error
      log_exception(error, 'get_environment')
      render_result(false, 'Failed to retrieve environment!', nil, nil, 500)
    end
  end

  def get_custom_commands
    return render_result(false, 'Please provide a valid environment id!') if params[:environment_id].blank?
    begin
      @custom_commands = CustomCommand.where(environment_id: params[:environment_id])
      return render_result(false, 'Custom commands not found!') unless @custom_commands.present?
      #render_result(true, 'Custom commands retrieved successfully!', @custom_commands, nil, 200)
    rescue StandardError => error
      log_exception(error, 'get_custom_command')
      render_result(false, 'Failed to retrieve custom commands!', nil, nil, 500)
    end
  end

  def get_test_suites
    return render_result(false, 'Please provide a valid environment id!') unless params[:environment_id].present?
    begin
      @test_suites = TestSuite.where(environment_id: params[:environment_id], is_automated: 1)
    rescue StandardError => error
      log_exception(error, 'get_test_suites')
      render_result(false, 'Failed to retrieve test suites!', nil, nil, 500)
    end
  end

  def get_test_suite
    return render_result(false, 'Please provide a valid test suite id!') unless params[:test_suite_id].present?
    begin
      @test_suite = TestSuite.where(id: params[:test_suite_id]).take
      return render_result(false, 'Test suite not found!') unless @test_suite.present?
    rescue StandardError => error
      log_exception(error, 'get_test_suite')
      render_result(false, 'Failed to retrieve test suite!', nil, nil, 500)
    end
  end


  def schedule_test_suite
    return render_result(false, 'Please provide a valid test suite id!') if params[:test_suite_id].blank?
    begin
      @test_suite = TestSuite.find_by(id: params[:test_suite_id])
      return render_result(false, 'Test suite not found!') unless @test_suite.present?
      return render_result(true, 'Invalid browser') unless params[:browser_id].present?

      scheduler_params = { number_of_times: 1, record_session: params[:record_session] }
      @scheduler = Scheduler.new(scheduler_params)
      @scheduler.user = Current.user
      @scheduler.test_suite = @test_suite
      @scheduler.browser = Browser.where(id: params[:browser_id].to_i).take || Browser::CHROME_ID

      if @scheduler.save
        render_result(true, 'Test suite scheduled successfully!', @scheduler.id, nil, 200)
      else
        error_msg = ['Failed to schedule test suite!', @scheduler.errors.full_messages].flatten.join(',')
        render_result(false, error_msg, nil, nil, 200)
      end
    rescue StandardError => error
      log_exception(error, 'schedule_test_suite')
      render_result(false, 'Failed to schedule test suite!', nil, nil, 500)
    end
  end

  def get_scheduler
    return render_result(false, 'Please provide a valid scheduler id!') unless params[:scheduler_id].present?
    begin
      @scheduler = Scheduler.includes(:test_suite).where(id: params[:scheduler_id], 'test_suites.is_automated': true).take
      return render_result(false, 'Scheduler not found!') unless @scheduler.present?

    rescue StandardError => error
      log_exception(error, 'get_scheduler')
      render_result(false, 'Failed to retrieve scheduler detail!', nil, nil, 500)
    end
  end

  def unschedule_test_suite
    return render_result(false, 'Please provide a valid scheduler id!') if params[:scheduler_id].blank?
    begin
      @scheduler = Scheduler.where(id: params[:scheduler_id]).take
      return render_result(false, 'Scheduler not found!') unless @scheduler.present?

      @scheduler.destroy

      render_result(true, 'Test suite unscheduled successfully!', nil, nil, 200)
    rescue StandardError => error
      log_exception(error, 'unschedule_test_suite')
      render_result(false, 'Failed to unschedule test suite!', nil, nil, 500)
    end
  end

  def get_test_cases
    return render_result(false, 'Please provide a valid test suite id!') if params[:test_suite_id].blank?
    begin
      #@test_cases = TestCase.find_by_sql("SELECT tc.id as id, tc.element_class as element_class, tc.field_name as field_name, tc.javascript_conditional_enabled, tc.javascript_conditional, tc.field_type as field_type, tc.read_element as read_element, tc.xpath as xpath, tc.full_xpath as full_xpath, tc.input_value as input_value, tc.action as action, ts.base_url as base_url, tc.action_url as action_url, tc.sleeps as sleeps, tc.custom_command_id as custom_command_id, cs.sequence as sequence, cs.accepted_case_ids, cs.rejected_case_ids, tc.new_tab as new_tab, tc.need_screenshot as need_screenshot, tc.description as description, tc.selenium_file, tc.enter_action as enter_action FROM test_cases tc, case_suites cs, test_suites ts WHERE cs.test_case_id = tc.id AND ts.id = cs.test_suite_id AND cs.test_suite_id = #{params[:test_suite_id]} ORDER BY cs.sequence")
      @test_cases = TestCase.where(test_suite_id: params[:test_suite_id]).order('priority ASC')
      return render_result(false, 'Test cases not found!') unless @test_cases.present?
    rescue StandardError => error
      log_exception(error, 'get_test_cases')
      render_result(false, 'Failed to retrieve test cases!', nil, nil, 500)
    end
  end

  def create_result_suite
    #return render_result(false, 'Please provide a valid rd id!') unless params[:rd_id].present? || !ResultsDictionary::STATUS.values.include?(params[:rd_id])

    begin
      test_suite = TestSuite.where(id: params[:test_suite_id]).take
      scheduler = Scheduler.where(id: params[:scheduler_id]).take

      result_suite_params = {rd_id: params[:rd_id], scheduler_index: params[:scheduler_index], start_time: DateTime.now.utc }
      result_suite = ResultSuite.new(result_suite_params)
      result_suite.user = Current.user
      result_suite.test_suite = test_suite
      result_suite.scheduler = scheduler

      if result_suite.save
        render_result(true, 'Result suite created successfully!', result_suite, nil, 200)
      else
        error_msg = ['Failed to create result suite!', result_suite.errors.full_messages].flatten.join(',')
        render_result(false, error_msg, nil, nil, 200)
      end
    rescue StandardError => error
      log_exception(error, 'create_result_suite')
      render_result(false, 'Failed to create result suite!', nil, nil, 500)
    end
  end

  def update_result_suite
    return render_result(false, 'Please provide a valid rd id!') unless params[:rd_id].present? || !ResultsDictionary::STATUS.values.include?(params[:rd_id])

    begin
      @result_suite = ResultSuite.where(id: params[:result_suite_id]).take
      return render_result(false, 'Result suite not found!') unless @result_suite.present?

      @result_suite.rd_id = params[:rd_id] # Complete = 1, Error = 2, Running = 3
      @result_suite.end_time = params[:rd_id] == ResultsDictionary::STATUS.dig(:PENDING) ? nil : DateTime.now.utc

      if @result_suite.save
        render_result(true, 'Result suite updated successfully!', @result_suite, nil, 200)
      else
        error_msg = ['Failed to update result suite!', @result_suite.errors.full_messages].flatten.join(',')
        render_result(false, error_msg, nil, nil, 200)
      end
    rescue StandardError => error
      log_exception(error, 'update_result_suite')
      render_result(false, 'Failed to update result suite!', nil, nil, 500)
    end
  end

  def create_result_case
    return render_result(false, 'Please provide a valid rd id!') unless params[:rd_id].present? || ResultsDictionary::STATUS.values.include?(params[:rd_id].to_i)

    begin
      @result_suite = ResultSuite.where(id: params[:result_suite_id]).take

      result_case_params = {rd_id:params[:rd_id], error_description:params[:error_description] }
      test_case = TestCase.where(id: params[:test_case_id]).take
      scheduler = Scheduler.where(id: params[:scheduler_id]).take

      @result_case = ResultCase.new(result_case_params)
      @result_case.test_case = test_case
      @result_case.scheduler = scheduler
      @result_case.result_suite = @result_suite
      @result_case.created_at = DateTime.now.utc
      @result_case.updated_at = DateTime.now.utc

      if params[:rd_id] == ResultsDictionary::STATUS.dig(:ERROR) # Error
         error_hash = TestCaseOverride.generate_error_hash(params[:error_description])
         @override = TestCaseOverride.where(test_case_id: params[:test_case_id], error_hash: error_hash).take

        if @override.present?
          @result_case.rd_id =  ResultsDictionary::STATUS.dig(:SUCCESS)
          @result_case.override_status = true
          @result_case.override_comment = @override.override_message
        end
      end

      if @result_case.save
        render_result(true, 'Result case created successfully!', @result_case, nil, 200)
      else
        error_msg = ['Failed to create result case!', @result_case.errors.full_messages].flatten.join(',')
        render_result(false, error_msg, nil, nil, 200)
      end
    rescue StandardError => error
      log_exception(error, 'create_result_case')
      render_result(false, 'Failed to create result case!', nil, nil, 500)
    end
  end

  def update_scheduler_status
    return render_result(false, 'Please provide a valid status!')  unless Scheduler::STATUS.include?(params[:status].upcase)
    begin
      schedule = Scheduler.where(id: params[:scheduler_id]).take
      return render_result(false, 'Schedule not found') unless schedule.present?

      schedule.update(status: params[:status].upcase, completed_date: DateTime.now.utc)
      render_result(true, 'Schedule status updated successfully!', schedule, nil, 200)
    rescue StandardError => error
      log_exception(error, 'update_scheduler_status')
      render_result(false, 'Failed to update schedule status!', nil, nil, 500)
    end
  end

  def upload_screenshot
    return render_result(false, 'Please provide a valid file!') unless params[:file].present?
    begin
      @result_case = ResultCase.where(id: params[:result_case_id]).take
      return render_result(false, 'Result case not found!') unless @result_case.present?

      res = @result_case.upload_screenshot(params[:file])

      render_result(true, 'Screenshot uploaded successfully!', res, nil, 200)
    rescue StandardError => error
      log_exception(error, 'upload_screenshot')
      render_result(false, 'Failed to upload screenshot!', nil, nil, 500)
    end
  end

  def upload_video
    return render_result(false, 'Please provide a valid file!') unless params[:file].present?
    begin
      @result_suite = ResultSuite.where(id: params[:result_suite_id]).take
      return render_result(false, 'Result suite not found!') unless @result_suite.present?

      res = @result_suite.upload_video(params[:file])
      render_result(true, 'Video uploaded successfully!', res, nil, 200)
    rescue StandardError => error
      log_exception(error, 'upload_video')
      render_result(false, 'Failed to upload video!', nil, nil, 500)
    end
  end

  private
  def log_exception(error, api)
    Rails.logger.info "==========================="
    Rails.logger.info "Error in #{api} api: #{error.inspect}"
    Rails.logger.info "==========================="
    NotifyMailer.development_team(error.inspect, "API Error in #{api}").deliver_later
  end

  def render_result(status = false, message = '', result = nil, _system_message = nil, status_code = 200)
    render json: { 'message': message, 'data': result, 'status': status }, status: status_code
  end
end