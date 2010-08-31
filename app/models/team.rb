class Team < ActiveRecord::Base
  
  belongs_to :user
  
  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  
end