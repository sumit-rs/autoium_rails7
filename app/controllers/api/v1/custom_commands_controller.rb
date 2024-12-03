class Api::V1::CustomCommandsController < ApplicationApiController
  include CommonConcern
  def index
    @custom_commands = @environment.try(:custom_commands)
  end
end