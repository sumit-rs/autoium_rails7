class ManualCase < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :test_suite
  has_one_attached :file

  # -------------------------------------------------------------
  validates :name, :presence => true
  validates :description, :presence => true
end
