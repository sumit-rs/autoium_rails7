class SoftwareVersionsController < ApplicationController

  before_action :get_software_version, only: %i[show edit update destroy]
  before_action :redirect_if_not_admin, except: %i[index]
  def index
    @versions = SoftwareVersion.all
  end

  def new
    @version = SoftwareVersion.new
  end

  def create
    @version = SoftwareVersion.new(version_params)
    if @version.save
      flash[:success] = 'Version created successfully.'
      redirect_to software_versions_path
    else
      flash.now[:errors] = @version.errors.full_messages
      render :new
    end
  end

  def edit; end

  def update
    if @version.update(version_params)
      flash[:success] = 'Version updated successfully.'
      redirect_to software_versions_path
    else
      flash.now[:errors] = @version.errors.full_messages
      render :new
    end
  end

  def destroy
    if @version.destroy
      flash[:success] = 'Project deleted Successfully.'
    else
      flash[:errors] = @version.errors.full_messages
    end
    redirect_to software_versions_path
  end

  private

  def redirect_if_not_admin
    redirect_to software_versions_path, notice: "You are not allowed to perform this action." and return unless Current.user.is_admin?
  end

  def get_software_version
    @version = SoftwareVersion.find(params[:id])
  end

  def version_params
    params.require(:software_version).permit(:name, :description, :release_date, :software_type)
  end
end
