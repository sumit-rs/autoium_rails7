class TestPlansController < ApplicationController
  before_action :get_environment
  before_action :get_test_plan, only: [:show, :edit, :update, :destroy, :connected_flow_nodes]

  def index
    @test_plans = @environment.test_plans
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
    if Current.user == @test_plan.user or @environment.project.creator == Current.user
      if @test_plan.destroy
        flash[:success] = 'Test plan deleted Successfully.'
      else
        flash[:errors] = @test_plan.errors.full_messages
      end
      redirect_to environment_test_plans_url(@environment)
    else
      redirect_to environment_test_plans_url(@environment), notice: 'You are not allowed to delete the test plan which are created by other user.' and return unless Current.user == @test_plan.user
    end
  end

  def flow_states
    @test_plan_flows = TestPlanFlow.build_node_hirerchy(@environment)
  end

  def connected_flow_nodes
    test_plans = TestPlan.where("name like ?", "#{params[:term]}%").where(status: 1, environment: @environment).where.not(id: params[:test_plan])
    render json: {results: test_plans.collect{|test_plan| {id: test_plan.id, text: test_plan.name }}}
  end

  private

  def get_environment
    @environment = Environment.where(id: params[:environment_id]).take
  end

  def get_test_plan
    @test_plan = @environment.test_plans.where(id: params[:id]).take
  end
  def test_plan_params
    params.require(:test_plan).permit(:name, :description, :suite_count, :status, test_role_ids: [], plan_flows: [], test_plan_steps_attributes: [:id, :name, :description, :_destroy])
  end
end
