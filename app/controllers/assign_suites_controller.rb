class AssignSuitesController < ApplicationController

  def index
  end

  def manual
    @assign_manual_suites = AssignManualTestSuite.joins(:test_suite, :user).where(assign_to: Current.user.id, 'test_suites.is_automated': false, 'test_suites.status': TestSuite::SUITE_STATUS).order('id desc')
  end

  def manual_cases
    @assign_manual_test = AssignManualTestSuite.where(id: params[:id], assign_to: Current.user.id).take
    redirect_to manual_assign_suites_path, notice: 'There is no assign test suites exist.' and return if @assign_manual_test.nil?

    @manual_case_results = if @assign_manual_test.manual_case_results.present?
                             @assign_manual_test.manual_case_results
                           else
                             manual_test_cases = @assign_manual_test.test_suite.include_base_post_suite.flatten.map { |suite| suite.manual_cases }.flatten.compact
                             manual_test_cases.each do |manual_case|
                               ManualCaseResult.find_or_create_by(assign_manual_test_suite: @assign_manual_test, manual_case: manual_case, user: @assign_manual_test.user)
                             end
                             @assign_manual_test.state = AssignManualTestSuite::STATE_START
                             @assign_manual_test.save
                             #@assign_manual_test.reload!
                             @assign_manual_suites.manual_case_results
                           end
  end
end
