class FileHandlerController < ApplicationController

  def load_image
    @result_case = ResultCase.find(params[:result_case])
    @file_url = @result_case.get_screenshot_url
  end

  def load_video

  end
end
