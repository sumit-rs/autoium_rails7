class ExportTestSuites

  AUTOMATE_TYPE_FIELD_MAPPING = {
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
      label: 'Status',
      proc: proc { |record| record.status },
      mandatory_header: true,
    }
  }

  def generate_suite_results_xls(items, file_path = File.join(Rails.root, "tmp", "download.xlsx"))
    package = Axlsx::Package.new
    workbook = package.workbook
    text_style = workbook.styles.add_style(sz: 12, font_name: 'Helvetica', alignment: { horizontal: :left, wrap_text: false })

    workbook.add_worksheet(name: "Result-Suite") do |wb_sheet|
      generate_header(wb_sheet, AUTOMATE_TYPE_FIELD_MAPPING, text_style)
      (items || {}).each_with_index do |item, index|
        wb_sheet.add_row(TRANSACTION_SHEET_MAPPING.values.collect { |_hash| _hash[:proc].call(item) }, style: text_style)
      end
    end
    workbook.add_worksheet(name: "Variants") do |wb_sheet|
      generate_header(wb_sheet, ORDER_VARIANT_SHEET_MAPPING, text_style)
      (variant_items || {}).each_with_index do |item, index|
        wb_sheet.add_row(ORDER_VARIANT_SHEET_MAPPING.values.collect { |_hash| _hash[:proc].call(item) }, style: text_style)
      end
    end

    workbook.add_worksheet(name: "Memberships") do |wb_sheet|
      generate_header(wb_sheet, MEMBERSHIP_VARIANT_SHEET_MAPPING, text_style)
      (membership_items || {}).each_with_index do |item, index|
        wb_sheet.add_row(MEMBERSHIP_VARIANT_SHEET_MAPPING.values.collect { |_hash| _hash[:proc].call(item) }, style: text_style)
      end
    end

    workbook.add_worksheet(name: "Questionnaries") do |wb_sheet|
      generate_header(wb_sheet, QUESTIONNARIE_SHEET_MAPPING, text_style)
      (questionnarie_items || {}).each_with_index do |item, index|
        wb_sheet.add_row(QUESTIONNARIE_SHEET_MAPPING.values.collect { |_hash| _hash[:proc].call(item) }, style: text_style)
      end
    end

    _path = file_path
    File.unlink(_path) if File.exist?(_path)
    FileUtils.touch(_path)
    package.serialize(_path)
    _path
  end
end