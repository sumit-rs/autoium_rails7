class CustomCommand < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :environment

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :command, presence: true

end
