class SuiteSchedule < ApplicationRecord

  # -------------------------------------------------------------
  STATUS_PICKED = 'picked'

  # -------------------------------------------------------------
  belongs_to :test_suite

  # -------------------------------------------------------------
  store :additional_info, accessors: [:browsers], coder: JSON

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :start_date, date: true
  validates :end_date, date: true
  validates :time, presence: true
  validates :browsers, presence: true
  validates :start_date, presence: true, date: { before_or_equal_to: :end_date, message: 'must be before or equal to end date' }

  # -------------------------------------------------------------
  def self.schedule_daily_suites
    today = Time.now.utc.to_date
    @site_schedules = SuiteSchedule.where(active: true, status: [nil,''])
                                   .where('start_date <= ?', today)
                                   .where('? <= end_date', today)
                                   .limit(5)

    @site_schedules.each do |site_schedule|
      browsers = Browser.where(id: site_schedule.browsers)
      browsers = browsers.present? ? browsers : [Browser.first]
      browsers.each do |browser|
        schedule = Scheduler.new(
                           test_suite: site_schedule.test_suite,
                           scheduled_date: Time.parse(site_schedule.time),
                           number_of_times: 1,
                           browser: browser,
                           status: Scheduler::READY_STATUS,
                           record_session: 0,
                           user_id: 0
                         )
        if schedule.valid?
          site_schedule.update_column(:status, SuiteSchedule::STATUS_PICKED)
          schedule.save
        else
          puts "Error: Scheduler not created for test suite: #{schedule.test_suite.name} on browser: #{browser.name} due to errors: #{schedule.errors.full_messages.join(', ')}"
        end
      end
    end
  end

  def self.clear_daily_suite_status
    today = Time.now.utc.to_date
    @schedules = SuiteSchedule.where(active: true, status: SuiteSchedule::STATUS_PICKED).where('start_date <= ?', today)
                              .where('? <= end_date', today)
                              .update_all(status: nil)
  end

  private

end