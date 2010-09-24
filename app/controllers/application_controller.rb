class ApplicationController < ActionController::Base

  protect_from_forgery

  helper :buttons

  def teams_scope
    @teams_scope ||= current_user.teams
  end

end
