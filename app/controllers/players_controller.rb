class PlayersController < ApplicationController
  
  before_filter :find_team, :only => %w(new create)
  before_filter :build_player, :only => %w(new create)
  
  respond_to :html
  
  def create
    flash[:notice] = "Player was added." if @player.save
    respond_with(@player, :location => team_url(@team))
  end
  
  ##################################################
  private
  
  def find_team
    super(params[:team_id])
  end
  
  def build_player
    @player = @team.players.new(params[:player])
  end
  
end