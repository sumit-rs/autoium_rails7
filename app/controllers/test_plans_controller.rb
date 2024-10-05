class TestPlansController < ApplicationController
  before_action :get_environment

  def index
    @test_plans = @environment.test_plans.where(user_id: Current.user.id)
  end

  def new
    @test_plan = TestPlan.new
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
    @test_plan = @environment.test_plans.where(id: params[:id]).take
  end

  private

  def get_environment
    @environment = Current.user.environments.where(id: params[:environment_id]).take
  end
  def test_plan_params
    params.require(:test_plan).permit(:name, :description, :suit_count, :status)
  end
end
