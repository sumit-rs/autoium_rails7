class TestPlansController < ApplicationController
  before_action :get_environment
  before_action :get_test_plan, only: [:show, :edit, :update, :destroy, :connected_flow_nodes]

  def index
    @test_plans = @environment.test_plans.order('root_element DESC')
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

  def show
    test_plan = TestPlan.find(params[:id])
    render json: test_plan.to_json
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

  def hierarchy
    @root_test_plan = TestPlan.environment_root_plan(@environment)
    @non_root_test_plans = TestPlan.environment_non_root_plans(@environment)
    if request.post?
      tree_data = params[:tree]
      plan_hierarchy = build_plan_hierarchy(tree_data, @root_test_plan.id, {})
      @environment.test_plan_flows.each{|a| a.destroy}
      plan_hierarchy.each do |plan, plan_flow_nodes|
        test_plan = TestPlan.where(id: plan).take
        if test_plan.present?
          test_plan.plan_flows = plan_flow_nodes
          test_plan.save
        end
      end
      render json: { success: true, message: "Test plan hierarchy updated successfully!" }
    end
  end

  def load_plan_tree
    test_plan_flows = TestPlanFlow.build_node_hirerchy(@environment) || []
    if test_plan_flows.empty?
      @root_test_plan = TestPlan.environment_root_plan(@environment)
      test_plan_flows << {
        id: @root_test_plan.id,
        text: @root_test_plan.name,
        parent_id: "#",
        data: {},
        state: { opened: true },
        children: []
      }

      @non_root_test_plans = TestPlan.environment_non_root_plans(@environment)
      @non_root_test_plans.each do | non_root_test_plan|
        test_plan_flows[0][:children] << {
          id: non_root_test_plan.id,
          text: non_root_test_plan.name,
          data: {parent_id: @root_test_plan.id.to_s},
          parent_id: @root_test_plan.id.to_s,
          state: { opened: true },
          children: []
        }
      end

    end
    render json: test_plan_flows.to_json
  end

  private

  def build_plan_hierarchy(nodes, parent_id, data)
    nodes.each do |node|
      parent_node = (node.dig("data","parent_id") || parent_id).to_i
      # Initialize array if key doesn't exist
      data[parent_node] ||= []
      data[parent_node] << node[:id].to_i unless node[:id].to_i == parent_id
      build_plan_hierarchy(node[:children] || [], parent_id, data) if node[:children].present?
    end
    data
  end
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
