class Api::V1::TestSuitesController < ApplicationApiController
  include CommonConcern
  def index
    if @environment
      @test_suites = @environment.test_suites.select(:id, :name, :is_automated).as_json
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
      render json: { message: @test_suite.errors.full_messages.join(','), status: false }, status: :precondition_failed
    end
  end

  private

  def test_suite_params
    params.require(:test_suite).permit(:name, :short_description, :base_suite_id, :environment_id, :is_automated, :post_suite_id)
  end
end