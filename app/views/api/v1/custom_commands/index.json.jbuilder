if @environment.present? and @custom_commands.present?
  json.message 'Custom commands retrieved!'
  json.status true
  json.result @custom_commands, partial: 'custom_command', as: :custom_command
else
  json.message 'Failed to custom commands retrieved! Environment does not exist!'
  json.status false
  json.result []
end