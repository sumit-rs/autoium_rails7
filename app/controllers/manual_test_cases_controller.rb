class ManualTestCasesController < ApplicationController
  before_action :get_environment
  before_action :get_test_suite
  before_action :get_test_cases, only: [:show, :edit, :update, :destroy, :delete_attachment]

  def index
    @test_cases = @test_suite.manual_cases
  end

  def new
    @test_case = ManualCase.new
  end

  def create
    @test_case = ManualCase.new(manual_test_params)
    #@test_suite.user = Current.user
    @test_case.test_suite = @test_suite

    if @test_case.save
      flash[:success] = 'Manual test case created successfully.'
      redirect_to environment_test_suite_manual_test_cases_path(@environment, @test_suite)
    else
      flash.now[:errors] = @test_case.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @test_case.update(manual_test_params)
      flash[:success] = 'Manual test case updated successfully.'
      redirect_to environment_test_suite_manual_test_cases_path(@environment, @test_suite)
    else
      flash.now[:errors] = @test_case.errors.full_messages
      render :edit
    end
  end

  def destroy
    if Current.user == @test_suite.user or @environment.project.creator == Current.user
      if @test_case.destroy
        flash[:success] = 'Manual case deleted Successfully.'
      else
        flash[:errors] = @test_case.errors.full_messages
      end
      redirect_to environment_test_suite_manual_test_cases_path(@environment, @test_suite)
    else
      redirect_to environment_test_suite_manual_test_cases_path(@environment, @test_suite), notice: "You are not allowed to delete the case which are created by other user."
    end
  end

  def delete_attachment
    @test_case.file.purge
    flash[:success] = "Case attachment has been removed successfully."
    redirect_to environment_test_suite_manual_test_cases_path(@environment, @test_suite)
  end

  private
  def get_environment
    @environment = Environment.where(id: params[:environment_id]).take
  end
  def get_test_suite
    @test_suite = @environment.test_suites.where(id: params[:test_suite_id]).take
  end
  def get_test_cases
    @test_case = @test_suite.manual_cases.where(id: params[:id]).take
  end
  def manual_test_params
    params.require(:manual_case).permit(:name, :description, :url, :is_active, :file)
  end
end
