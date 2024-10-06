class TestRole < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :environment
  has_and_belongs_to_many :test_plans

  # -------------------------------------------------------------
  validates :name, presence: true
end
