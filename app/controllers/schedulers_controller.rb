class SchedulersController < ApplicationController
  before_action :get_environment
  before_action :get_test_suite
  def index
    @schedulers = Scheduler.where(test_suite: @test_suite)
  end

  def create
    @scheduler = Scheduler.new(scheduler_params)
    @scheduler.user = Current.user
    @scheduler.test_suite  = @test_suite
    @scheduler.browser = Browser.where(id: scheduler_params[:browser_id]).take
    if @scheduler.save
      flash[:success] = 'Scheduler created successfully.'
    else
      flash[:errors] = @scheduler.errors.full_messages
    end
    redirect_to environment_test_suite_schedulers_path(@environment, @test_suite)
  end

  def destroy
    @scheduler = Scheduler.where(id: params[:id]).take
    if @scheduler.destroy
      flash[:success] = 'Scheduler deleted successfully.'
    else
      flash[:errors] = @scheduler.errors.full_messages
    end
    redirect_to environment_test_suite_schedulers_path(@environment, @test_suite)
  end

  private
  def get_environment
    @environment = Environment.where(id: params[:environment_id]).take
  end
  def get_test_suite
    @test_suite = @environment.test_suites.where(id: params[:test_suite_id]).take
  end
  def scheduler_params
    params.require(:scheduler).permit(:number_of_times, :browser_id, :record_session)
  end

end
