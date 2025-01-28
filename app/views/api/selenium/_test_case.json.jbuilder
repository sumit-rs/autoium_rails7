json.extract! test_case, :id, :field_name, :field_type, :read_element, :input_value, :action, :action_url,
              :xpath, :full_xpath, :sleeps, :description, :need_screenshot, :enter_action, :custom_command_id, :javascript_conditional_enabled, :javascript_conditional, :selenium_file, :element_class

json.new_tab test_case.new_tab ? 1 : 0
json.base_url test_case.test_suite.base_url
json.sequence test_case.priority
json.accepted_case_ids [].to_s
json.rejected_case_ids [].to_s