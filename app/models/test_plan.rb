class TestPlan < ApplicationRecord

  # -------------------------------------------------------------
  belongs_to :user
  belongs_to :environment
  has_many  :test_plan_steps, dependent: :destroy
  has_and_belongs_to_many :test_roles

  accepts_nested_attributes_for :test_plan_steps, allow_destroy: true, reject_if: :all_blank

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :suite_count, numericality: { greater_than: 0 }
  #validates :suite_count, length: {minimum: 1}

  before_validation :change_suit_count_data_type

  # def suite_count=(suite_count) #creates a setter method for name
  #   @suite_count = suite_count.to_i
  # end

  private

  def change_suit_count_data_type
    self.suite_count = self.suite_count.to_i
  end
end
