class TestSuitesController < ApplicationController
  before_action :get_environment
  before_action :get_test_suite, only: [:show, :edit, :update, :destroy, :assign_users]

  def index
    @test_suites = @environment.test_suites
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
      redirect_to environment_test_suites_url(@environment)
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
    if request.xhr? and request.post?
      user_ids = assign_manual_test_suite_params[:assign_to].map(&:to_i) || []
      test_suite_id = assign_manual_test_suite_params[:test_suite_id]
      if user_ids.empty? or assign_manual_test_suite_params[:test_suite_id].empty?
        str = ''
        str << 'User must exist.<br/>' if user_ids.empty?
        str << 'Test suite must exist.' if assign_manual_test_suite_params[:test_suite_id].empty?
        @error = true
        flash.now[:errors] = str
      else
        ## checking: if assignment exist for the user then dont create new entry into the system, only update the assignment cases
        user_assignment_exists = AssignManualTestSuite.where(assign_to: user_ids,
                                                        state: [AssignManualTestSuite::STATE_ASSIGN, AssignManualTestSuite::STATE_START],
                                                        test_suite_id: test_suite_id, browser: assign_manual_test_suite_params[:browser]
        ).collect(&:assign_to)
        [user_ids - user_assignment_exists].flatten.each do |user_id|
          ats =  AssignManualTestSuite.new(assign_to: user_id, test_suite_id: test_suite_id, browser: assign_manual_test_suite_params[:browser], assign_number: Time.now.to_i)
          ats.state = AssignManualTestSuite::STATE_ASSIGN
          if ats.save
          else
            Rails.logger.info "Error: Test Suite Assign: #{ats.errors.full_messages.inspect}"
          end
        end
        flash[:success] = 'Test suite assigned successfully!'
        render js: "window.location.href =' #{environment_test_suites_url(@environment)}'"
      end
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

  def assign_manual_test_suite_params
    params.require(:assign_manual_test_suite).permit(:test_suite_id, :browser, assign_to: [])
  end
end
