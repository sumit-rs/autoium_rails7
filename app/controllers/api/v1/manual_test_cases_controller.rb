class Api::V1::ManualTestCasesController < ApplicationApiController
  include CommonConcern

  before_action :get_test_cases, only: [:show, :update]

  def index
    @test_cases =  @test_suite.present? ? @test_suite.manual_cases : []
  end

  def show
  end

  def create
    @test_case = ManualCase.new(manual_test_params)
    @test_suite.user = Current.user
    @test_case.test_suite = @test_suite

    if @test_case.save
      render json: { message: 'Test case created!', status: true }, status: :ok
    else
      render json: { message: @test_case.errors.full_messages.join(','), status: false }, status: :precondition_failed
    end
  end

  def update

    begin
      if @test_case.update(manual_test_params)
        render json: { message: 'Test case updated!', status: true }, status: :ok
      else
        render json: { message: @test_case.errors.full_messages.join(','), status: false }, status: :precondition_failed
      end
    rescue ArgumentError => e
      Rails.logger.info "======#{e.inspect}"
      render json: { message: 'Something went wrong.Please try later.', status: false }, status: :precondition_failed
    end
  end

  private

  def get_test_cases
    return nil unless @test_suite.present?
    @test_case = @test_suite.manual_cases.where(id: params[:id]).take
  end

  def manual_test_params
    params.require(:manual_case).permit(:name, :url, :description, :file)
  end
end
