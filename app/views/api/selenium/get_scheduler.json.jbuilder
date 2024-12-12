json.message 'Scheduler retrieved successfully!'
json.status true
json.data do
  json.id @scheduler.id
  json.test_suite_id @scheduler.test_suite_id
  json.test_suite do
    json.partial! 'test_suite', test_suite: @scheduler.test_suite, include_scheduler: false
  end
  json.scheduled_date @scheduler.scheduled_date
  json.number_of_times @scheduler.number_of_times
  json.browser_id @scheduler.browser_id
  json.browser @scheduler.browser
  json.record_session @scheduler.record_session
  json.environment_id @scheduler.test_suite.environment.id
  json.environment do
    json.name @scheduler.test_suite.environment.name
    json.url @scheduler.test_suite.environment.url
  end
end