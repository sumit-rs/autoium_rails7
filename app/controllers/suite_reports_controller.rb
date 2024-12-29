class SuiteReportsController < ApplicationController
  # -------------------------------------------------------------
  before_action :user_projects_and_environments, only: [:index, :automated]

  # -------------------------------------------------------------

  def index
    @reports = AssignManualTestSuite.joins(test_suite: [:environment]).where('environments.id' => Current.user.prefer_environment).order('id DESC').distinct
    @section = 'reports'
  end

  def automated
    @schedulers = Scheduler.includes(:user, :browser, :result_suites, test_suite: [:environment]).where('environments.id': Current.user.prefer_environment).order(id: :desc).distinct

    @scheduler_success = @schedulers.collect{|scheduler| scheduler if scheduler.status == Scheduler::SUCCESS_STATUS}.compact.count
    @scheduler_ready = @schedulers.collect{|scheduler| scheduler if scheduler.status == Scheduler::READY_STATUS}.compact.count
    @scheduler_error = @schedulers.collect{|scheduler| scheduler if scheduler.status == Scheduler::ERROR_STATUS}.compact.count
    @scheduler_running = @schedulers.collect{|scheduler| scheduler if scheduler.status == Scheduler::RUNNING_STATUS}.compact.count
    @scheduler_complete = @schedulers.collect{|scheduler| scheduler if scheduler.status == Scheduler::COMPLETE_STATUS}.compact.count

    schedulers = Scheduler.joins(test_suite: [:environment]).where('environments.id': Current.user.prefer_environment).select('browser_id')
    @browsers = schedulers.select('browser_id').group(:browser_id).count

    @recorded = schedulers.where(record_session: true).count
    @non_recorded = schedulers.where(record_session: false).count

    @section = 'reports'
    render :index
  end

  def show
    @suite_report = AssignManualTestSuite.joins(:manual_case_results,
                                           test_suite: [environment: [project: [:project_team_members]]]
    ).where('project_team_members.team_member_id' => Current.user.id, 'assign_manual_test_suites.id' => params[:id]).take
  end
end
