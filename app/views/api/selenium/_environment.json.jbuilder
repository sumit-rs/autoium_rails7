json.extract! environment, :id, :url, :password, :login_field, :password_field, :name, :action_button, :login_required
json.username environment.user_name
json.user_emails environment.user_email

#json.custom_commands environment.custom_commands
json.custom_commands environment.custom_commands do |custom_command|
  json.partial! 'custom_command', custom_command: custom_command
end
