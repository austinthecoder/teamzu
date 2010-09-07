class TeamsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :build_team, :only => %w(new create)
  before_filter :find_team, :only => %w(show edit update delete destroy)
  
  respond_to :html
  
  ##################################################
  
  def index
    @teams = current_user.teams.paginate(
      :page => params[:page],
      :per_page => 20,
      :order => 'created_at DESC'
    )
  end
  
  def create
    set_flash_and_respond("Team was created.") { @team.save }
  end
  
  def new; end
  
  ##################################################
  
  def update
    set_flash_and_respond("Team was saved.") { @team.update_attributes(params[:team]) }
  end
  
  def destroy
    set_flash_and_respond("Team was deleted.") { @team.destroy }
  end
  
  def show; end
  def edit; end
  def delete; end
  
  ##################################################
  private
  
  def find_team
    super(params[:id])
  end
  
  def build_team
    @team = current_user.teams.new(params[:team])
  end
  
  def set_flash_and_respond(message)
    flash[:notice] = message if yield
    respond_with(@team, :location => teams_url)
  end
  
end