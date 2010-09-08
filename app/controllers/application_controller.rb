class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  helper :buttons
  
  ##################################################
  private
  
  def find_team(id)
    current_user.teams.find(id)
  end
  
end
