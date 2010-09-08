class TeamsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :set_team, :only => %w(show edit update delete destroy)
  before_filter :build_team, :only => %w(new create)
  
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
    flash[:notice] = "Team was created." if @team.save
    respond_with(@team, :location => teams_url)
  end
  
  ##################################################
  
  def update
    flash[:notice] = "Team was saved." if @team.update_attributes(params[:team])
    respond_with(@team, :location => teams_url)
  end
  
  def destroy
    flash[:notice] = "Team was deleted." if @team.destroy
    respond_with(@team, :location => teams_url)
  end
  
  def show; end
  def edit; end
  def delete; end
  
  ##################################################
  private
  
  def set_team
    @team = find_team(params[:id])
  end
  
  def build_team
    @team = current_user.teams.new(params[:team])
  end
  
end