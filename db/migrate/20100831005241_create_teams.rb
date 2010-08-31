class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.integer :user_id
      t.string :name
      t.timestamps
    end
    
    add_index :teams, [:user_id, :name], :unique => true
  end

  def self.down
    drop_table :teams
  end
end
