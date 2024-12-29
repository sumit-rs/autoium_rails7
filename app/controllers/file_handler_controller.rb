class FileHandlerController < ApplicationController
  def load_image
    @result_case = ResultCase.find(params[:result_case])
    @file_url = @result_case.get_screenshot_url
  end

  def load_video
    @result_suite = ResultSuite.find(params[:result])
    @file_url = @result_suite.video_file_url
  end
end
