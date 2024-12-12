class Api::V1::TestCasesController < ApplicationApiController
  include CommonConcern
  before_action :get_test_cases, only: [:show, :update]
  def index
    @test_cases =  @test_suite.present? ? @test_suite.test_cases : []
  end

  def show
  end
  def create
    if (custom_command_id = params.dig('test_case', 'custom_command_id').to_i).present? and custom_command_id > 0 and (custom_command = CustomCommand.where(id: custom_command_id).take).present?
      param_fields = params.dig('test_case', 'fields')
      param_values = params.dig('test_case', 'values')
      parameters = []
      param_fields.each_with_index do |field, index|
        parameters << {"field" => field, "value" => param_values[index]}
      end
    end
    @test_case = TestCase.new(automate_test_params)
    @test_case.parameters = parameters if parameters.present?

    @test_case.user = Current.user
    @test_case.test_suite = @test_suite
    @test_case.custom_command = custom_command if custom_command.present?
    @test_case.priority = @test_suite.test_cases.count + 1
    if @test_case.save
      custom_command.save if custom_command.present?
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
    return nil unless @test_suite.present?
    @test_case = @test_suite.test_cases.where(id: params[:id]).take
  end
  def automate_test_params
    params.require(:test_case).permit(:field_name, :field_type, :read_element, :element_class, :input_value, :string, :action, :action_url, :base_url, :sleeps, :xpath, :full_xpath, :new_tab, :need_screenshot, :description, :javascript_conditional, :javascript_conditional_enabled, :enter_action, :custom_command_id, parameters: [:field, :value])
  end
end
