json.message 'Test suite retrieved successfully!'
json.status true
json.data do
  #json.partial! 'test_suite', test_suite: @test_suite, include_scheduler: false
  json.id @test_suite.id
  json.flow_not_defined @test_suite.flow_state.blank? ? 1 : 0
  json.base_suite_id @test_suite.base_suite_id
  json.post_suite_id @test_suite.post_suite_id
end