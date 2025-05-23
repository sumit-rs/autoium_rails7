# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "#{Dir.pwd}/log/cron.log"
set :environment, ENV['RAILS_ENV'] || 'development'

job_type :runner, "cd :path && bundle exec rails runner -e :environment ':task' :output"

every 1.day, at: '11:55 pm' do
  runner 'SuiteSchedule.clear_daily_suite_status'
end

every 1.hour do
  puts 'Schdeuling'
  runner 'SuiteSchedule.schedule_daily_suites'
end
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
