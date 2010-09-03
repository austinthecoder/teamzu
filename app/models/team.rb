class Team < ActiveRecord::Base
  
  belongs_to :user
  
  normalize_attribute :name, :with => :strip
  
  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  
end