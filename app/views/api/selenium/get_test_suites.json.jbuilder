json.data do
  json.array! @test_suites do |test_suite|
    json.partial! 'test_suite', test_suite: test_suite, include_scheduler: true
  end
end
json.message 'Test suites retrieved successfully!'
json.status true