require 'csv'
class PopulateCsv

  TEST_CASE_FIELDS_MAPPING = {
    field_name: {
      label: 'field_name',
      proc: proc { |record| record.field_name },
      mandatory_header: true,
    },
    xpath: {
      label: 'xpath',
      proc: proc { |record| record.xpath },
      mandatory_header: true,
    },
    full_xpath: {
      label: 'full_xpath',
      proc: proc { |record| record.full_xpath },
      mandatory_header: true,
    },
    field_type: {
      label: 'field_type',
      proc: proc { |record| record.field_type },
      mandatory_header: true,
    },
    read_element: {
      label: 'read_element',
      proc: proc { |record| record.read_element },
      mandatory_header: true,
    },
    input_value: {
      label: 'input_value',
      proc: proc { |record| record.input_value },
      mandatory_header: true,
    },
    action: {
      label: 'action',
      proc: proc { |record| record.action },
      mandatory_header: true,
    },
    action_url: {
      label: 'action_url',
      proc: proc { |record| record.action_url },
      mandatory_header: true,
    },
    sleeps: {
      label: 'sleeps',
      proc: proc { |record| record.sleeps },
      mandatory_header: true,
    },
    description: {
      label: 'description',
      proc: proc { |record| record.description },
      mandatory_header: true,
    },
    new_tab: {
      label: 'new_tab',
      proc: proc { |record| record.new_tab },
      mandatory_header: true,
    },
    base_url: {
      label: 'base_url',
      proc: proc { |record| record.base_url },
      mandatory_header: true,
    },
    priority: {
      label: 'priority',
      proc: proc { |record| record.priority },
      mandatory_header: true,
    },
    selenium_file: {
      label: 'selenium_file',
      proc: proc { |record| record.selenium_file },
      mandatory_header: true,
    },
    need_screenshot: {
      label: 'need_screenshot',
      proc: proc { |record| record.need_screenshot },
      mandatory_header: true,
    },
    custom_command_id: {
      label: 'custom_command_id',
      proc: proc { |record| record.custom_command_id },
      mandatory_header: true,
    },
    enter_action: {
      label: 'enter_action',
      proc: proc { |record| record.enter_action },
      mandatory_header: true,
    },
    javascript_conditional_enabled: {
      label: 'javascript_conditional_enabled',
      proc: proc { |record| record.javascript_conditional_enabled },
      mandatory_header: true,
    },
    javascript_conditional: {
      label: 'javascript_conditional',
      proc: proc { |record| record.javascript_conditional },
      mandatory_header: true,
    },
    element_class: {
      label: 'element_class',
      proc: proc { |record| record.element_class },
      mandatory_header: true,
    }
  }

  def populate_test_cases_csv(data)
    CSV.generate(headers: true) do |csv|
      # Add headers
      csv << PopulateCsv::TEST_CASE_FIELDS_MAPPING.values.collect { |_hash| _hash.dig(:label) }

      # Add data rows
      data.each do |test_case|
        csv << PopulateCsv::TEST_CASE_FIELDS_MAPPING.values.collect { |_hash| _hash[:proc].call(test_case) }
      end
    end
  end
end