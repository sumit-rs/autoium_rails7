class ManualCase < ApplicationRecord
  include ScreenshotHandlerConcern

  # -------------------------------------------------------------
  belongs_to :test_suite
  has_one :environment, through: :test_suite
  has_many :manual_case_results, dependent: :destroy

  # -------------------------------------------------------------
  validates :name, :presence => true
  validates :description, :presence => true
  # -------------------------------------------------------------

end
