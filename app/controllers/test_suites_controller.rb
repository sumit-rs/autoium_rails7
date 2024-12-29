class TestSuitesController < ApplicationController

  # -------------------------------------------------------------
  before_action :user_projects_and_environments, only: [:index,:automated]
  before_action :get_environment
  before_action :get_test_suite, only: [:show, :edit, :update, :destroy, :assign_users, :remove_assign_suite]
  # -------------------------------------------------------------

  def index
    @section = 'suites'
    @test_suites = @environment.present? ? @environment.test_suites.where(is_automated: false) : []
  end

  def automated
    @section = 'suites'
    @test_suites = @environment.present? ? @environment.test_suites.where(is_automated: true) : []
    render :index
  end

  def suites
    redirect_to environment_test_suites_path(Current.user.prefer_environment) and return if Current.user.prefer_environment.present?
    flash[:notice] = 'Please save your preference first.'
    redirect_to settings_user_path(Current.user, redirect: 'suites')
  end

  def new
    @test_suite = TestSuite.new
  end

  def create
    @test_suite = TestSuite.new(test_suite_params)
    @test_suite.user = Current.user
    @test_suite.environment = @environment

    if @test_suite.save
      flash[:success] = 'Test Suite created successfully.'
      redirect_to environment_test_suites_url(@environment)
    else
      flash.now[:errors] = @test_suite.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @test_suite.update(test_suite_params)
      flash[:success] = 'Test suite updated successfully.'
      if request.xhr?
        render js: "window.location.href =' #{environment_test_suites_url(@environment)}'"
      else
        redirect_to environment_test_suites_url(@environment)
      end
    else
      flash.now[:errors] = @test_suite.errors.full_messages
      render :edit
    end
  end

  def destroy
    if Current.user == @test_suite.user or @environment.project.creator == Current.user
      if @test_suite.destroy
        flash[:success] = 'Suite deleted Successfully.'
      else
        flash[:errors] = @test_suite.errors.full_messages
      end
      redirect_to environment_test_suites_url(@environment)
    else
      redirect_to environment_test_suites_url(@environment), notice: "You are not allowed to delete the suite which are created by other user."
    end
  end

  def assign_users
    @error = false
    @assign_manual_test_suite = AssignManualTestSuite.new
    @schedulers = @test_suite.assign_manual_test_suites.order('id DESC')

    if request.post?
      user_ids = (assign_manual_test_suite_params[:assign_to] || []).map(&:to_i)
      test_suite_id = @test_suite.id #assign_manual_test_suite_params[:test_suite_id]
      if user_ids.empty? or @test_suite.manual_cases.empty?
        str = ''
        str << 'At-least one email must be selected.<br/>' if user_ids.empty?
        str << 'No manual case exist for test suite.' if @test_suite.manual_cases.empty?
        flash.now[:errors] = str
      else
        ## checking: if assignment exist for the user then dont create new entry into the system, only update the assignment cases
        user_assignment_exists = AssignManualTestSuite.where(assign_to: user_ids,
                                                        state: [AssignManualTestSuite::STATE_ASSIGN, AssignManualTestSuite::STATE_START],
                                                        test_suite_id: test_suite_id, browser: assign_manual_test_suite_params[:browser]
        ).collect(&:assign_to)
        error = ''
        [user_ids - user_assignment_exists].flatten.each do |user_id|
          ats =  AssignManualTestSuite.new(assign_to: user_id, test_suite_id: test_suite_id, browser: assign_manual_test_suite_params[:browser], assign_number: Time.now.to_i)
          ats.state = AssignManualTestSuite::STATE_ASSIGN
          if ats.save
          else
            error = ats.errors.full_messages.join(',')
            @error = true
            break
            #Rails.logger.info "Error: Test Suite Assign: #{ats.errors.full_messages.inspect}"
          end
        end
        if @error
          flash.now[:errors] = error
        else
          flash[:success] = 'Test suite assigned successfully!'
          redirect_to assign_users_environment_test_suite_url(@environment, @test_suite)
        end
      end
    end
  end

  def remove_assign_suite
    @assign_suite = AssignManualTestSuite.where(id: params[:suite]).take
    if @assign_suite.try(:state) == AssignManualTestSuite::STATE_ASSIGN
      @assign_suite.destroy
      flash[:success] = 'Assign suite successfully deleted.'
    else
      flash[:errors] = "#{@assign_suite.try(:state)} state test suite could not be deleted."
    end
    redirect_to assign_users_environment_test_suite_url(@environment, @test_suite)
  end

  def import
    if request.post?
      @test_suite = TestSuite.new(test_suite_import_params)
      errors = []
      errors << 'Import file must be present.' unless test_suite_import_params[:import_suite_cases].present?

      @test_suite.user = Current.user
      @test_suite.environment = @environment

      if @test_suite.save and errors.blank?
        flash[:success] = "Test suite '#{@test_suite.name}' & #{@test_suite.test_cases.count} test case(s) have been imported successfully."
        redirect_to environment_test_suites_path(@environment)
      else
        errors << @test_suite.errors.full_messages
        flash[:errors] = errors.flatten
      end
    else
      @test_suite = TestSuite.new
    end
  end

  private

  def get_environment
    @environment = Environment.where(id: params[:environment_id]).take
  end

  def get_test_suite
    @test_suite = @environment.test_suites.where(id: params[:id]).take
  end

  def test_suite_params
    params.require(:test_suite).permit(:name, :description, :short_description, :test_plan_id, :is_automated, :jira_id, :base_suite_id, :post_suite_id, :status, :is_stale)
  end

  def test_suite_import_params
    params.require(:test_suite).permit(:name, :short_description, :is_automated, :import_suite_cases, :dependency)
  end
  def assign_manual_test_suite_params
    params.require(:assign_manual_test_suite).permit(:test_suite_id, :browser, assign_to: [])
  end
end
