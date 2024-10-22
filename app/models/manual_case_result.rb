class ManualCaseResult < ApplicationRecord
  #-------------------------------------------------------------
  STATUS_PASS = 'PASS'
  STATUS_FAIL = 'FAIL'
  STATUS = [STATUS_PASS, STATUS_FAIL]

  #-------------------------------------------------------------
  belongs_to :assign_manual_test_suite
  belongs_to :user, foreign_key: :assign_to
  belongs_to :manual_case

end
