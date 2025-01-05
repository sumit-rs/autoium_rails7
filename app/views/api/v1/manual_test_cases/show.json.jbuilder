if @test_suite and @test_case.present?
  json.message 'Test case retrieved!'
  json.status true
  json.result do
    json.partial! partial: 'manual_case', locals: {test_case: @test_case}
  end
else
  json.message 'Failed to retrieve test case. Either Test case or Test suite does not exist!'
  json.status false
  json.result {}
end