class ResultSuite < ApplicationRecord
  # -------------------------------------------------------------
  belongs_to :results_dictionary, foreign_key: :rd_id
  belongs_to :test_suite
  belongs_to :user
  belongs_to :scheduler
  has_many :result_cases
end
