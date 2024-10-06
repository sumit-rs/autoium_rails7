class TestPlan < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :environment
  has_many  :test_plan_steps, dependent: :destroy
  accepts_nested_attributes_for :test_plan_steps, allow_destroy: true, reject_if: :all_blank
  has_and_belongs_to_many :test_roles

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :suite_count, length: {minimum: 1}
end
