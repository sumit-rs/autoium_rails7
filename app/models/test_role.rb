class TestRole < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :environment

  # -------------------------------------------------------------
  validates :name, presence: true
end
