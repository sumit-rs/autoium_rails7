class TestRolesController < ApplicationController
  before_action :get_environment
  def index
    @test_roles = TestRole.where(environment_id: params[:environment_id])
  end

  def new
    @test_role = TestRole.new
  end

  def create
    @test_role = TestRole.new(test_role_params)
    @test_role.user = Current.user
    @test_role.environment = @environment

    if @test_role.save
      flash[:success] = 'Test plan role created successfully.'
      redirect_to environment_test_roles_url(@environment)
    else
      flash.now[:errors] = @test_role.errors.full_messages
      render :new
    end
  end

  def edit
    @test_role = TestRole.find(params[:id])
  end

  def update
    @test_role = TestRole.find(params[:id])
    if @test_role.update(test_role_params)
      flash[:success] = 'Test plan role updated successfully.'
      redirect_to environment_test_roles_url(@environment)
    else
      flash.now[:errors] = @test_role.errors.full_messages
      render :edit
    end
  end

  private

  def get_environment
    @environment = Environment.where(id: params[:environment_id]).take
  end
  def test_role_params
    params.require(:test_role).permit(:name, :status)
  end
end
