class ManualCaseResultsController < ApplicationController

  before_action :get_manual_case_result, only: [:show, :edit, :update]
  def edit
  end
  def update
    if @manual_case_result and @manual_case_result.user == Current.user and mark_test_case_param.dig(:status).present?
      if @manual_case_result.update(mark_test_case_param)
        flash[:success] = 'Test case status updated successfully.'
      else
        Rails.logger.error "Error: ====#{@manual_case_result.errors.full_messages.inspect}"
        flash[:errors] = 'There is issue to update the test case status.Please try later'
      end
    else
      flash[:errors] = 'Invalid operation to perform.'
    end
    #if params[:section] == 'more_info' //comment this if condition as of now later we will uncomment and change flash to flash.now according to condition
    # dropdown change event for status update -- flash.now should be there
    # add more button update -- flash should be there
    if mark_test_case_param[:case_result_file].present?
      return redirect_to manual_cases_assign_suite_path(@manual_case_result.assign_manual_test_suite), format: :js
    else
      render js: "window.location.href =' #{manual_cases_assign_suite_path(@manual_case_result.assign_manual_test_suite)}'"
    end
  end

  private

  def get_manual_case_result
    @manual_case_result =  ManualCaseResult.where(id: params[:id]).take
  end
  def mark_test_case_param
    params.require(:manual_case_result).permit(:status, :description, :case_result_file)
  end
end
