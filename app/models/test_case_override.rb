class TestCaseOverride < ApplicationRecord
  # -------------------------------------------------------------
  belongs_to :test_case
  #before_save :set_error_hash

  # -------------------------------------------------------------
  def set_error_hash
    self.error_hash = TestCaseOverride.generate_error_hash(self.error_message)
  end

  def self.create_override(test_case, error_message, override_message)
    error_hash = generate_error_hash(error_message)
    test_case_override = TestCaseOverride.find_or_initialize_by(test_case: test_case, error_hash: error_hash)
    test_case_override.error_message = error_message
    test_case_override.override_message = override_message
    test_case_override.save
  end

  def self.generate_error_hash(error_message)
    Digest::MD5.hexdigest(error_message)
  end
end
