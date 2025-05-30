class TestCasesController < ApplicationController
  before_action :get_environment
  before_action :get_test_suite
  before_action :get_test_cases, only: [:show, :edit, :update, :destroy]

  def index
    @test_cases = @test_suite.test_cases
  end

  def new
    @test_case = TestCase.new
    @test_case.javascript_conditional = TestCase::DEFAULT_JAVASCRIPT_CONDITIONAL
  end

  def selenium_custom_code
    @test_case = TestCase.new
    @test_case.field_type = TestCase::SELENIUM_FIELD_TYPE
    @test_case.javascript_conditional = TestCase::DEFAULT_JAVASCRIPT_CONDITIONAL
    @test_case.custom_selenium_js = TestCase::DEFAULT_CUSTOM_SELENIUM_CODE
  end

  def create
    @test_case = TestCase.new(automate_test_params)
    @test_case.user = Current.user
    @test_case.test_suite = @test_suite
    @test_case.priority = @test_suite.test_cases.count + 1

    if @test_case.save
      flash[:success] = 'Automate test case created successfully.'
      redirect_to environment_test_suite_test_cases_path(@environment, @test_suite)
    else
      flash.now[:errors] = @test_case.errors.full_messages
      if @test_case.field_type == TestCase::SELENIUM_FIELD_TYPE
        render :selenium_custom_code
      else
        render :new
      end
    end
  end

  def edit
    @test_case.custom_selenium_js = @test_case.get_selenium_file_content
  end

  def update
    if @test_case.update(automate_test_params)
      flash[:success] = 'Automate test case case updated successfully.'
      redirect_to environment_test_suite_test_cases_path(@environment, @test_suite)
    else
      flash.now[:errors] = @test_case.errors.full_messages
      render :edit
    end
  end

  def destroy
    if Current.user == @test_suite.user or @environment.project.creator == Current.user
      if @test_case.destroy
        flash[:success] = 'Automate case deleted Successfully.'
      else
        flash[:errors] = @test_case.errors.full_messages
      end
      redirect_to environment_test_suite_test_cases_path(@environment, @test_suite)
    else
      redirect_to environment_test_suite_test_cases_path(@environment, @test_suite), notice: "You are not allowed to delete the case which are created by other user."
    end
  end

  def export
    test_cases = @test_suite.test_cases
    data = PopulateCsv.new.populate_test_cases_csv(test_cases)
    send_data data, filename: "#{@test_suite.name}-#{Date.today}.csv"
  end

  private
  def get_environment
    @environment = Environment.where(id: params[:environment_id]).take
  end
  def get_test_suite
    @test_suite = @environment.test_suites.where(id: params[:test_suite_id]).take
  end
  def get_test_cases
    @test_case = @test_suite.test_cases.where(id: params[:id]).take
  end
  def automate_test_params
    params.require(:test_case).permit(:field_name, :field_type, :read_element, :element_class, :input_value, :string, :action, :action_url, :base_url, :sleeps, :xpath, :full_xpath, :new_tab, :need_screenshot, :description, :javascript_conditional, :javascript_conditional_enabled, :enter_action, :custom_selenium_js)
  end
end
