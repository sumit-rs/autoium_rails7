class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:privacy_policy]
  before_action :user_projects, except: [:privacy_policy]
  def index
    @environments = Environment.where(project_id: @projects.collect(&:id))
    @test_suites = TestSuite.where(environment_id: @environments.collect(&:id))
    @test_cases = TestCase.where(test_suite_id: @test_suites.collect(&:id))
    @manual_cases = ManualCase.where(test_suite_id: @test_suites.collect(&:id))

    @scheduler_success = @test_suites.collect{|ts| ts.schedulers.where(status: Scheduler::SUCCESS_STATUS).count}.compact.sum
    @scheduler_ready = @test_suites.collect{|ts| ts.schedulers.where(status: Scheduler::READY_STATUS).count}.compact.sum
    @scheduler_error = @test_suites.collect{|ts| ts.schedulers.where(status: Scheduler::ERROR_STATUS).count}.compact.sum
    @scheduler_running = @test_suites.collect{|ts| ts.schedulers.where(status: Scheduler::RUNNING_STATUS).count}.compact.sum
    @scheduler_complete = @test_suites.collect{|ts| ts.schedulers.where(status: Scheduler::COMPLETE_STATUS).count}.compact.sum

    @browsers = Scheduler.select('browser_id').group(:browser_id).count

    @recent_schedulers = Scheduler.order('updated_at DESC').limit(5)
    @manual_test_suites = @test_suites.where(is_automated: false)
    @automate_test_suites = @test_suites.where(is_automated: true)
  end

  def privacy_policy

  end
end
