json.extract! test_case, :id, :element_class, :field_name, :javascript_conditional_enabled, :javascript_conditional, :field_type, :read_element,
              :xpath, :full_xpath, :input_value, :action, :action_url, :sleeps, :custom_command_id, :new_tab, :need_screenshot, :description, :selenium_file, :enter_action
json.base_url test_case.test_suite.base_url
json.sequence test_case.priority
json.accepted_case_ids []
json.rejected_case_ids []