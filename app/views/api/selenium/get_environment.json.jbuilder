json.message 'Environment retrieved successfully!'
json.status true
json.data do
  json.partial! 'environment', environment: @environment, include_custom_commands: true
end