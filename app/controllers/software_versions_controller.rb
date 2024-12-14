class SoftwareVersionsController < ApplicationController
  def index
    @versions = SoftwareVersion.all
  end
end
