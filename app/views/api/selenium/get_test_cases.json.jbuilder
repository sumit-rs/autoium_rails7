json.message 'Test cases retrieved successfully!'
json.status true
json.data do
  json.array! @test_cases do |test_case|
    json.partial! 'test_case', test_case: test_case
  end
end