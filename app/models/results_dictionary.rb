class ResultsDictionary < ApplicationRecord
  #has_many :result_suites
  #has_many :result_cases
  STATUS = { SUCCESS: 1, ERROR: 2, PENDING: 3 }
end
