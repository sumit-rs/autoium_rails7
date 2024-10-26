class CustomCommandsController < ApplicationController
  before_action :get_environment

  def index
    @custom_commands = CustomCommand.where(environment_id: params[:environment_id])
  end

  def new
    @custom_command = CustomCommand.new
  end
  def create
    @custom_command = CustomCommand.new(custom_command_params)
    @custom_command.environment = @environment
    if @custom_command.save
      flash[:success] = "Custom command was successfully created."
      redirect_to environment_custom_commands_path(@environment)
    else
      flash.now[:errors] = @custom_command.errors.full_messages
      render :new
    end
  end

  def edit
    @custom_command = @environment.custom_commands.where(id: params[:id]).take
  end

  def update
    @custom_command = @environment.custom_commands.where(id: params[:id]).take
    if @custom_command.update(custom_command_params)
      flash[:success] = 'Custom command was successfully updated.'
      redirect_to environment_custom_commands_path(@environment)
    else
      flash.now[:errors] = @custom_command.errors.full_messages
      render :edit
    end
  end

  def destroy
    @custom_command = @environment.custom_commands.where(id: params[:id]).take
    if @custom_command.delete
      flash[:success] = 'Custom command deleted Successfully.'
    else
      flash[:errors] = @custom_command.errors.full_messages
    end
    redirect_to environment_custom_commands_path(@environment)
  end

  private
  def get_environment
    @environment = Environment.where(id: params[:environment_id]).take
  end

  def custom_command_params
    params.require(:custom_command).permit(:name, :command)
  end
end
