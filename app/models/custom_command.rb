class CustomCommand < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :environment
  has_many :test_cases

  # -------------------------------------------------------------
  store :additional_information, accessors: [:parameters], coder: JSON

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :command, presence: true

end
