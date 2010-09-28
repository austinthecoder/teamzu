class EmailsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :team
  before_filter :players
  before_filter :ensure_emailable_players, :only => %w(new create)

  def create
    if params[:email].blank? || params[:email][:message].blank?
      flash[:alert] = "Looks like you left the message blank."
      render 'new'
    else
      PlayerMailer.bulk_message(*[
        players,
        current_user.email,
        params[:email][:subject],
        params[:email][:message]
      ]).deliver
      flash[:notice] = "Message was sent to players."
      redirect_to team_url(team)
    end
  end

  ##################################################

  def team
    @team ||= teams_scope.find(params[:team_id])
  end

  def players_scope
    @players_scope ||= team.players
  end

  def players
    @players ||= players_scope.find(params[:bulk_player_id].split(":"))
  end

  def ensure_emailable_players
    if players.any? { |p| p.email.blank? }
      flash[:alert] = "Some of the players selected do not have an email address."
      redirect_to team_url(team)
    end
  end

end
