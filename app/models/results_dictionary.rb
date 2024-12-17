class ResultsDictionary < ApplicationRecord

  STATUS = { SUCCESS: 1, ERROR: 2, PENDING: 3 }

  def self.status
    ResultsDictionary::STATUS.invert
  end
end
