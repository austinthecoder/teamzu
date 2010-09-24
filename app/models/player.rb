class Player < ActiveRecord::Base

  belongs_to :team

  normalize_attribute :name, :with => :strip
  normalize_attribute :email, :with => :strip

  validates :name, :presence => true
  validates :team, :presence => true

  class << self
    def emailable
      Player.where(['email != ? OR email != ?', nil, ''])
    end
  end

end
