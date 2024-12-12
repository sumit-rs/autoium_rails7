json.message 'Test suite retrieved successfully!'
json.status true
json.data do
  json.partial! 'test_suite', test_suite: @test_suite, include_scheduler: false
end