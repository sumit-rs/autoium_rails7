json.id custom_command.id
json.name custom_command.name
json.command custom_command.command
json.parameters custom_command.parameters.collect{|parameter| parameter.dig('field') }.compact.join(',')