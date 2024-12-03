module CommonConcern
  extend ActiveSupport::Concern

  included do
    before_action :get_environments
    before_action :get_test_suite
  end

  private
  def get_environments
    @environment = Environment.where(project_id: Current.user.assign_projects.collect(&:id), id: params[:environment_id]).take
  end

  def get_test_suite
    return unless params[:test_suite_id].present? and @environment.present?
    @test_suite = @environment.test_suites.where(id: params[:test_suite_id]).take
  end
end