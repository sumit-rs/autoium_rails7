class TestCaseOverride < ApplicationRecord
  # -------------------------------------------------------------
  belongs_to :test_case
  before_save :set_error_hash

  # -------------------------------------------------------------
  def set_error_hash
    self.error_hash = TestCaseOverride.generate_error_hash(self.error_message)
  end

  def self.create_override(test_case_id, error_message, override_message)
    error_hash = generate_error_hash(error_message)
    override_exists = TestCaseOverride.where(test_case_id: test_case_id, error_hash: error_hash).count.positive?

    unless override_exists
      override = TestCaseOverride.new
      override.test_case_id = test_case_id
      override.error_message = error_message
      override.override_message = override_message
      override.save!
    end
    true
  end

  def self.generate_error_hash(error_message)
    Digest::MD5.hexdigest(error_message)
  end
end
