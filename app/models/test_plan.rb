class TestPlan < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :environment

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :suite_count, length: {minimum: 1}
end
