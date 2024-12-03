if @test_cases.present?
  json.message 'Test cases retrieved!'
  json.status true
  json.result @test_cases, partial: 'test_case', as: :test_case
else
  json.message 'Failed to test cases retrieved! Test suite does not exist!'
  json.status false
  json.result []
end
