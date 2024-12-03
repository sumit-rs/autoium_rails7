class Api::V1::TestCasesController < ApplicationApiController
  include CommonConcern
  before_action :get_test_cases, only: [:show, :update]
  def index
    @test_cases =  @test_suite.present? ? @test_suite.test_cases : []
  end

  def show
  end
  def create
    @test_case = TestCase.new(automate_test_params)
    @test_case.user = Current.user
    @test_case.test_suite = @test_suite

    if @test_case.save
      render json: { message: 'Test case created!', status: true }, status: :ok
    else
      render json: { message: @test_case.errors.full_messages.join(','), status: false }, status: :precondition_failed
    end
  end

  def update
    if @test_case.update(automate_test_params)
      render json: { message: 'Test case updated!', status: true }, status: :ok
    else
      render json: { message: @test_case.errors.full_messages.join(','), status: false }, status: :precondition_failed
    end
  end

  private
  def get_test_cases
    @test_case = @test_suite.test_cases.where(id: params[:id]).take
  end
  def automate_test_params
    params.require(:test_case).permit(:field_name, :field_type, :read_element, :element_class, :input_value, :string, :action, :action_url, :base_url, :sleeps, :xpath, :full_xpath, :new_tab, :need_screenshot, :description, :javascript_conditional, :javascript_conditional_enabled, :enter_action)
  end
end
