class TestPlan < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :environment
  has_many  :test_plan_steps, dependent: :destroy
  has_many  :test_plan_flows, autosave: true, dependent: :destroy
  has_and_belongs_to_many :test_roles

  # -------------------------------------------------------------
  attr_accessor :plan_flows

  # -------------------------------------------------------------
  accepts_nested_attributes_for :test_plan_steps, allow_destroy: true, reject_if: :all_blank

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :suite_count, numericality: { greater_than: 0 }

  # -------------------------------------------------------------
  before_validation :change_suit_count_data_type
  before_save :populate_test_plan_flows

  # -------------------------------------------------------------

  # -------------------------------------------------------------
  def populate_test_plan_flows
    self.test_plan_flows.each{|test_plan_flow| test_plan_flow.mark_for_destruction}
    self.plan_flows&.each do |plan_flow|
      self.test_plan_flows.build(link_test_plan_id: plan_flow)
    end
  end

  private
  def change_suit_count_data_type
    self.suite_count = self.suite_count.to_i
  end
end
