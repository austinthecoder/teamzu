class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.integer :team_id
      t.string :name
      t.string :email
      t.timestamps
    end
    
    add_index :players, :team_id
  end

  def self.down
    drop_table :players
  end
end
