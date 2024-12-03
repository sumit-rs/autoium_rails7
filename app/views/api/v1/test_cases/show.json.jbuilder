if @test_case.present?
  json.message 'Test case retrieved!'
  json.status true
  json.result do
    json.partial! partial: 'test_case', locals: {test_case: @test_case}
  end
else
  json.message 'Failed to retrieve test case. Test case does not exist!'
  json.status false
  json.result {}
end