class ResultCase < ApplicationRecord
  # -------------------------------------------------------------
  belongs_to :results_dictionary, foreign_key: :rd_id
  belongs_to :test_case
  belongs_to :result_suite
  belongs_to :scheduler

end
