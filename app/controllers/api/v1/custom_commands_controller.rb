class Api::V1::CustomCommandsController < ApplicationApiController
  include CommonConcern
  def index
    if @environment.present?
      @custom_commands = @environment.custom_commands.select(:id, :name).as_json
      render(json: { message: 'Custom commands retrieved!', result: @custom_commands, status: true }, status: :ok)
    else
      render(json: { message: 'Failed to retrieve custom commands!', result: [], status: false }, status: :precondition_failed)
    end
  end
end