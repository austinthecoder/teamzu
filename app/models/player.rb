class Player < ActiveRecord::Base
  
  belongs_to :team
  
  normalize_attribute :name, :with => :strip
  
  validates :name, :presence => true
  validates :team, :presence => true
  
end
