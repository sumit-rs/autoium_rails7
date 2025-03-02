class TestPlanFlow < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :test_plan
  belongs_to :link_test_plan, class_name: 'TestPlan', foreign_key: :link_test_plan_id

  # -------------------------------------------------------------
  def self.build_node_hirerchy(environment)
    test_flows = environment.test_plan_flows
    tree = {}

    test_flows.each do |test_flow|
      parent_node = test_flow[:test_plan_id]
      child_node = test_flow[:link_test_plan_id]

      tree[parent_node] ||= { id: parent_node, name: test_flow.test_plan.name, children: [] }
      tree[child_node] ||= { id: child_node, name: test_flow.link_test_plan.name, children: [] }

      tree[parent_node][:children] << tree[child_node]
    end
    # Get the root nodes (parents that are not children in any row)
    root_nodes = tree.keys - test_flows.map { |row| row[:link_test_plan_id] }

    # Convert root nodes into a structured hierarchy
    root_nodes.map { |id| tree[id] }.first
  end
end
