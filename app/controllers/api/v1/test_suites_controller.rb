class Api::V1::TestSuitesController < ApplicationApiController
  before_action :get_environments
  def index
    puts Current.user.inspect
    if @environment
      @test_suites = @environment.test_suites.where(is_automated: true).select(:id, :name).as_json
      render(json: { message: 'Test suites retrieved!', result: @test_suites, status: true }, status: :ok)
    else
      render(json: { message: 'Failed to retrieve test suites! Invalid environment', status: false }, status: :ok)
    end
  end

  def create
    @test_suite = TestSuite.new(test_suite_params)
    @test_suite.user = Current.user
    @test_suite.platform = TestSuite::CHROME_PLATFORM
    @test_suite.environment = @environment

    if @test_suite.save
      render json: { message: 'Test suite created!', status: true }, status: :ok
    else
      puts @test_suite.errors.full_messages.inspect
      render json: { message: @test_suite.errors.full_messages.join(','), status: false }, status: :precondition_failed
    end
  end

  private

  def get_environments
    @environment = Environment.where(project_id: Current.user.assign_projects.collect(&:id), id: params[:environment_id]).take
  end

  def test_suite_params
    params.require(:test_suite).permit(:name, :short_description, :base_suite_id, :environment_id)
  end
end