class TestSuitesController < ApplicationController
  before_action :get_environment
  before_action :get_test_suite, only: [:show, :edit, :update, :destroy]

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

  private
  def get_environment
    @environment = Environment.where(id: params[:environment_id]).take
  end

  def get_test_suite
    @test_suite = @environment.test_suites.where(id: params[:id]).take
  end
  def test_suite_params
    params.require(:test_suite).permit(:name, :description, :short_description,:test_plan_id, :is_automated, :jira_id, :base_suite_id, :post_suite_id, :status, :is_stale )
  end
end
