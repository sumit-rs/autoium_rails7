json.message 'Custom commands retrieved successfully!'
json.status true
json.data do
  json.array! @custom_commands do |custom_command|
    json.partial! 'custom_command', custom_command: custom_command
  end
end
