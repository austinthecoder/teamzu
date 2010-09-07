class Team < ActiveRecord::Base
  
  belongs_to :user
  
  has_many :players
  
  normalize_attribute :name, :with => :strip
  
  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  
end