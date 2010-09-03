class User < ActiveRecord::Base
  
  normalize_attribute :email, :with => :strip
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :teams
  
  def remember_me
    @remember_me = true unless defined?(@remember_me)
    @remember_me
  end
  
end
