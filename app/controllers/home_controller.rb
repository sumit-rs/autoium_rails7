class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:privacy_policy]
  def index
  end

  def privacy_policy

  end
end
