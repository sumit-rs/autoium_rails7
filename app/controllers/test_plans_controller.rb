class TestPlansController < ApplicationController
  before_action :get_environment
  before_action :get_test_plan, only: [:show, :edit, :update, :destroy]

  def index
    @test_plans = @environment.test_plans.where(user_id: Current.user.id)
  end

  def new
    @test_plan = TestPlan.new
    @test_plan.test_plan_steps.build
  end

  def create
    @test_plan = TestPlan.new(test_plan_params)
    @test_plan.user = Current.user
    @test_plan.environment = @environment

    if @test_plan.save
      flash[:success] = 'Test plan created successfully.'
      redirect_to environment_test_plans_url(@environment)
    else
      flash.now[:errors] = @test_plan.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @test_plan.update(test_plan_params)
      flash[:success] = 'Test plan updated successfully.'
      redirect_to environment_test_plans_url(@environment)
    else
      flash.now[:errors] = @test_plan.errors.full_messages
      render :new
    end
  end

  def destroy
    if @test_plan.destroy
      flash[:success] = 'Test plan deleted Successfully.'
    else
      flash[:errors] = @test_plan.errors.full_messages
    end
    redirect_to environment_test_plans_url(@environment)
  end

  private

  def get_environment
    @environment = Current.user.environments.where(id: params[:environment_id]).take
  end

  def get_test_plan
    @test_plan = @environment.test_plans.where(id: params[:id]).take
  end
  def test_plan_params
    params.require(:test_plan).permit(:name, :description, :suite_count, :status, test_role_ids: [], test_plan_steps_attributes: [:id, :name, :description, :_destroy])
  end
end
