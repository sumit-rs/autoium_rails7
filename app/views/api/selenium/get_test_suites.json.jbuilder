json.data do
  json.array! @test_suites do |test_suite|
    #json.partial! 'test_suite', test_suite: test_suite, include_scheduler: false
    json.id test_suite.id
    json.name test_suite.name
    json.scheduler_id test_suite.schedulers.where(status: Scheduler::READY_STATUS).take.try(:id)
  end
end
json.message 'Test suites retrieved successfully!'
json.status true