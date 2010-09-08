class PlayersController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :set_team
  before_filter :set_player, :only => %w(edit update delete destroy)
  before_filter :build_player, :only => %w(new create)
  
  respond_to :html
  
  ##################################################
  
  def create
    flash[:notice] = "Player was added." if @player.save
    respond_with(@player, :location => team_url(@team))
  end
  
  ##################################################
  
  def update
    flash[:notice] = "Player was saved." if @player.update_attributes(params[:player])
    respond_with(@player, :location => team_url(@team))
  end
  
  def destroy
    flash[:notice] = "Player was removed." if @player.destroy
    respond_with(@player, :location => team_url(@team))
  end
  
  def edit; end
  def delete; end
  
  ##################################################
  private
  
  def set_team
    @team = find_team(params[:team_id])
  end
  
  def set_player
    @player = @team.players.find(params[:id])
  end
  
  def build_player
    @player = @team.players.new(params[:player])
  end
  
end