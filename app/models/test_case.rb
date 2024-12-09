class TestCase < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :test_suite
  belongs_to :custom_command, optional: true
  has_one :environment, through: :test_suite

  # -------------------------------------------------------------
  before_save :check_javascript_conditional

  # -------------------------------------------------------------
  private

  def check_javascript_conditional
    self.javascript_conditional = '' if self.javascript_conditional_enabled === "0"
  end
end
