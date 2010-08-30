class Users::RegistrationsController < Devise::RegistrationsController
  
  before_filter :authenticate_user!, :only => %w(delete)
  
end