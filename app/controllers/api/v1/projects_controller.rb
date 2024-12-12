class Api::V1::ProjectsController < ApplicationApiController
  def index
    begin
      @projects = Current.user.assign_projects.select(:id, :name).as_json
      render(json: { message: 'Projects retrieved successfully!', result: @projects, status: true }, status: :ok)
    rescue StandardError => error
      Rails.logger.info "==========================="
      Rails.logger.info "Error retrieving projects api: #{error.inspect}"
      Rails.logger.info "==========================="
      render(json: { message: 'Failed to retrieve projects!', result: nil, status: false }, status: 500)
    end
  end
end
