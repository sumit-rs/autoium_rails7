class PeriodicsController < ApplicationController
  before_action :get_environment
  before_action :get_test_suite
  before_action :fetch_browsers
  before_action :fetch_suite_scheduler, only: %i[edit update destroy]
  #-------------------------------------------------------------
  def index
    @periodics = SuiteSchedule.where(test_suite: @test_suite).order(id: :desc)
  end

  def new
    @suite_schedule = SuiteSchedule.new
  end

  def create
    @suite_schedule = SuiteSchedule.new(periodic_params)
    @suite_schedule.test_suite = @test_suite
    if @suite_schedule.save
      flash[:success] = 'Periodic schedule created successfully.'
      redirect_to environment_test_suite_periodics_path(@environment, @test_suite)
    else
      flash.now[:errors] = @suite_schedule.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @suite_schedule.update(periodic_params)
      flash[:success] = 'Periodic schedule updated successfully.'
      redirect_to environment_test_suite_periodics_path(@environment, @test_suite)
    else
      flash.now[:errors] = @suite_schedule.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @suite_schedule.destroy
      flash[:success] = 'Periodic schedule deleted Successfully.'
    else
      flash[:errors] = @suite_schedule.errors.full_messages
    end
    redirect_to environment_test_suite_periodics_path(@environment, @test_suite)
  end

  private

  def fetch_suite_scheduler
    @suite_schedule = SuiteSchedule.where(id: params[:id]).take
  end
  def get_environment
    @environment = Environment.where(id: params[:environment_id]).take
  end

  def get_test_suite
    @test_suite = @environment.test_suites.where(id: params[:test_suite_id]).take
  end

  def fetch_browsers
    @browsers = Browser.pluck(:name, :id)
  end

  def periodic_params
    cleaned_params = params.require(:suite_schedule).permit(:name, :start_date, :end_date, :time, browsers: [])
    if cleaned_params[:browsers]
      cleaned_params[:browsers].reject!(&:blank?)
      cleaned_params[:browsers].map!(&:to_i)
    end
    cleaned_params
  end
end
