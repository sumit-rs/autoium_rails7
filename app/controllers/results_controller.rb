class ResultsController < ApplicationController
  before_action :get_environment
  before_action :get_test_suite
  before_action :get_scheduler

  def index
    @result_suite = ResultSuite.where(test_suite: @test_suite, scheduler: @scheduler).order('id DESC').take
    @result_cases = ResultCase.includes(:test_case).where(result_suite: @result_suite).order('test_cases.priority asc')
  end

  def update
    @result_case = ResultCase.where(id: params[:id]).take
    if request.xhr?
      @error = false
      @result_case.override_comment = params.dig("result_case", "override_comment")
      @result_case.rd_id = ResultsDictionary::STATUS[:SUCCESS]
      @result_case.override_status = true
      @result_case.mark_override = true
      @result_case.override_status_permanently = params.dig("result_case", "override_status_permanently")
      if @result_case.save
        flash[:success] = "Result Case sequence #{@result_case.test_case.priority} - override status has been marked successfully!"
        render js: "window.location.href =' #{environment_test_suite_scheduler_results_path(@environment, @test_suite, @scheduler)}'"
      else
        @error = true
        flash.now[:errors] = @result_case.errors.full_messages
      end
    end
  end
  def status_override
    @result_case = ResultCase.where(id: params[:id]).take
  end

  private
  def get_environment
    @environment = Environment.where(id: params[:environment_id]).take
  end
  def get_test_suite
    @test_suite = @environment.test_suites.where(id: params[:test_suite_id]).take
  end

  def get_scheduler
    @scheduler = Scheduler.where(id: params[:scheduler_id]).take
  end
end
