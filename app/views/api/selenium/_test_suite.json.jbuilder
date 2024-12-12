json.id test_suite.id
json.name test_suite.name
json.short_description test_suite.short_description
json.is_automated test_suite.is_automated
json.flow_not_defined test_suite.flow_state.blank? ? 1 : 0
json.base_suite_id test_suite.base_suite_id
json.post_suite_id test_suite.post_suite_id

if include_scheduler
  json.scheduler_id test_suite.schedulers.where(status: Scheduler::READY_STATUS).take.try(:id)
end
