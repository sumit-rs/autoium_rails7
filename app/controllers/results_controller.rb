class ResultsController < ApplicationController
  before_action :get_environment
  before_action :get_test_suite
  def index
    @scheduler = Scheduler.where(id: params[:scheduler_id]).take
    @result_suite = ResultSuite.where(test_suite: @test_suite, scheduler: @scheduler).order('id DESC').take
    @result_cases = ResultCase.includes(:test_case).where(result_suite: @result_suite).order('test_cases.priority asc')
  end

  private
  def get_environment
    @environment = Environment.where(id: params[:environment_id]).take
  end
  def get_test_suite
    @test_suite = @environment.test_suites.where(id: params[:test_suite_id]).take
  end
end
