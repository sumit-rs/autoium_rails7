class TestCase < ApplicationRecord

  belongs_to :user
  belongs_to :test_suite
  has_one :environment, through: :test_suite
end
