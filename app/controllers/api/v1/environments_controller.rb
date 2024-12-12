class Api::V1::EnvironmentsController < ApplicationApiController

  def index
    begin
      _projects = Current.user.assign_projects.collect(&:id)
      if params[:project_id].present?
        render(json: { message: 'Invalid project', result: nil, status: false }, status: :precondition_failed) and return unless _projects.include?(params[:project_id].to_i)
        @environments = Environment.where(project_id: params[:project_id]).select(:id, :name).as_json
      else
        @environments = Environment.where(project_id: Current.user.assign_projects.collect(&:id)).select(:id, :name).as_json
      end
      render(json: { message: 'Environments retrieved!', result: @environments, status: true }, status: :ok)
    rescue StandardError  => error
      Rails.logger.info "==========================="
      Rails.logger.info "Error retrieving environments api: #{error.inspect}"
      Rails.logger.info "==========================="
      render(json: { message: 'Failed to retrieve environments!', result: nil, status: false }, status: 500)
    end
  end
end