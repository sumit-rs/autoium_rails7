require 'axlsx'
class PopulateExcel

  TEST_SUITE_FIELDS_MAPPING = {
    id: {
      label: 'Test Suite Id',
      proc: proc { |record| record.id },
      mandatory_header: true,
    },
    environment_id: {
      label: 'Environment',
      proc: proc { |record| record.environment.name },
      mandatory_header: true,
    },
    name: {
      label: 'Suite Name',
      proc: proc { |record| record.name },
      mandatory_header: true,
    },
    short_description: {
      label: 'Short Description',
      proc: proc { |record| record.short_description },
      mandatory_header: true,
    },
    description: {
      label: 'Description',
      proc: proc { |record| record.description },
      mandatory_header: true,
    },
    base_url: {
      label: 'Base URL',
      proc: proc { |record| record.base_url },
      mandatory_header: true,
    },
    video_file: {
      label: 'Video File',
      proc: proc { |record| record.video_file },
      mandatory_header: true,
    },
    status: {
      label: 'State',
      proc: proc { |record| record.status },
      mandatory_header: true,
    }
  }

  RESULT_SUITE_FIELDS_MAPPING = {
    id: {
      label: 'Result Suite Id',
      proc: proc { |record| record.id },
      mandatory_header: true,
    },
    rd_id: {
      label: 'Status',
      proc: proc { |record| ResultsDictionary.status.dig(record.rd_id).to_s },
      mandatory_header: true,
    },
    scheduler_id: {
      label: 'Scheduler',
      proc: proc { |record| record.scheduler_id },
      mandatory_header: true,
    },
    video_file: {
      label: 'Video Fle',
      proc: proc { |record| record.video_file.present? ? record.video_file_url : '' },
      mandatory_header: true,
    },
    end_time: {
      label: 'FinishAt',
      proc: proc { |record| record.end_time },
      mandatory_header: true,
    }
  }

  RESULT_CASES_FIELDS_MAPPING = {
    id: {
      label: 'Result Case Id',
      proc: proc { |record| record.id },
      mandatory_header: true,
    },
    rd_id: {
      label: 'Status',
      proc: proc { |record| ResultsDictionary.status.dig(record.rd_id).to_s },
      mandatory_header: true,
    },
    scheduler_id: {
      label: 'Scheduler',
      proc: proc { |record| record.scheduler_id },
      mandatory_header: true,
    },
    error_description: {
      label: 'Description',
      proc: proc { |record| record.error_description },
      mandatory_header: true,
    },
    override_comment: {
      label: 'Override Comment',
      proc: proc { |record| record.override_comment },
      mandatory_header: true,
    },
    screenshot_file_location: {
      label: 'Error Screenshot File',
      proc: proc { |record| record.screenshot_file_location },
      mandatory_header: true,
    }
  }

  def generate_suite_results_xls(result_suites, file_path = File.join(Rails.root, "tmp", "download.xlsx"))
    package = Axlsx::Package.new
    workbook = package.workbook
    text_style = workbook.styles.add_style(sz: 12, font_name: 'Helvetica', alignment: { horizontal: :left, wrap_text: false })

    workbook.add_worksheet(name: "Test-Suite") do |wb_sheet|
      headers = PopulateExcel::TEST_SUITE_FIELDS_MAPPING
      generate_header(wb_sheet, headers, text_style)
      data = []
      (result_suites || {}).each_with_index do |result_suite, index|
        data << PopulateExcel::TEST_SUITE_FIELDS_MAPPING.values.collect { |_hash| _hash[:proc].call(result_suite.test_suite) }
        wb_sheet.add_row(data.flatten, style: text_style)
      end
    end

    workbook.add_worksheet(name: "Result-Suite") do |wb_sheet|
      headers = PopulateExcel::RESULT_SUITE_FIELDS_MAPPING
      generate_header(wb_sheet, headers, text_style)
      (result_suites || {}).each_with_index do |result_suite, index|
        wb_sheet.add_row(PopulateExcel::RESULT_SUITE_FIELDS_MAPPING.values.collect { |_hash| _hash[:proc].call(result_suite) }, style: text_style)
      end
    end

    workbook.add_worksheet(name: "Test-Result-Cases") do |wb_sheet|
      headers = PopulateExcel::RESULT_CASES_FIELDS_MAPPING
      generate_header(wb_sheet, headers, text_style)
      (result_suites.first.result_cases || {}).each_with_index do |result_case, index|
        wb_sheet.add_row(PopulateExcel::RESULT_CASES_FIELDS_MAPPING.values.collect { |_hash| _hash[:proc].call(result_case) }, style: text_style)
      end
    end

    _path = file_path
    File.unlink(_path) if File.exist?(_path)
    FileUtils.touch(_path)
    package.serialize(_path)
    _path
  end

  def generate_header(wb_sheet, header_colms, style)
    wb_sheet.add_row(header_colms.values.collect { |_hash| _hash.dig(:label) }, style: style, b: true)
    wb_sheet
  end

end