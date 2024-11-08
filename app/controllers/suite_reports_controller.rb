class SuiteReportsController < ApplicationController

  def index
    @reports = AssignManualTestSuite.joins(:manual_case_results,
                                           test_suite: [environment: [project: [:project_team_members]]]
    ).where('project_team_members.team_member_id' => Current.user.id)
  end

  def show
    @suite_report = AssignManualTestSuite.joins(:manual_case_results,
                                           test_suite: [environment: [project: [:project_team_members]]]
    ).where('project_team_members.team_member_id' => Current.user.id, 'assign_manual_test_suites.id' => params[:id]).take
  end
end
