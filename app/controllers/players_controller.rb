class PlayersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :team
  before_filter :set_player, :only => %w(edit update delete destroy)
  before_filter :build_player, :only => %w(new create)

  respond_to :html

  ##################################################

  def create
    flash[:notice] = "Player was added." if player.save
    respond_with(player, :location => team_url(team))
  end

  def bulk
    players_scope.find(params[:player_ids])
    redirect_to case params[:bulk_action]
      when 'email'
        new_team_bulk_player_email_path(team, params[:player_ids].join(':'))
      else
        team_url(team)
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to(team_url(team))
  end

  ##################################################

  def update
    flash[:notice] = "Player was saved." if player.update_attributes(params[:player])
    respond_with(player, :location => team_url(team))
  end

  def destroy
    flash[:notice] = "Player was removed." if player.destroy
    respond_with(player, :location => team_url(team))
  end

  def edit; end
  def delete; end

  ##################################################

  def team
    @team ||= teams_scope.find(params[:team_id])
  end

  attr_reader :player

  def players_scope
    @players_scope ||= team.players
  end

  def set_player
    @player = players_scope.find(params[:id])
  end

  def build_player
    @player = players_scope.new(params[:player])
  end

end