class Api::V1::EnvironmentsController < ApplicationApiController

  def index
    @environments = Environment.where(project_id: Current.user.assign_projects.collect(&:id)).select(:id, :name).as_json
    render(json: { message: 'Environments retrieved!', result: @environments, status: true }, status: :ok)
  end
end