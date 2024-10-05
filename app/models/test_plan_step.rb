class TestPlanStep < ApplicationRecord
  # -------------------------------------------------------------
  belongs_to :test_plan, optional: true

  # -------------------------------------------------------------
  validates :name, presence: true
end
