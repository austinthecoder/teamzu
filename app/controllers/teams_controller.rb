class TeamsController < ApplicationController
  
  before_filter :authenticate_user!
  
  respond_to :html
  
  ##################################################
  
  def index
    @teams = current_user.teams.paginate(
      :page => params[:page],
      :per_page => 20,
      :order => 'created_at DESC'
    )
  end
  
  def new
    build_team
  end
  
  def create
    build_team
    flash[:notice] = "Team was created." if team.save
    respond_with(team, :location => teams_url)
  end
  
  def edit
    find_team
  end
  
  def update
    find_team
    flash[:notice] = "Team was saved." if team.update_attributes(params[:team])
    respond_with(team, :location => teams_url)
  end
  
  def delete
    find_team
  end
  
  def destroy
    find_team
    team.destroy
    flash[:notice] = "Team was deleted."
    respond_with(team, :location => teams_url)
  end
  
  ##################################################
  
  attr_reader :team
  
  def build_team
    @team = current_user.teams.new(params[:team])
  end
  
  def find_team
    @team = current_user.teams.find(params[:id])
  end
  
end