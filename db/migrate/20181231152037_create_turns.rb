class CreateTurns < ActiveRecord::Migration[5.2]
  def change
    create_table :turns do |t|
      t.belongs_to :game, foreign_key: true
      t.belongs_to :word, foreign_key: true
      t.integer :user_id
      t.integer :admin_id
      t.integer :place
      t.boolean :play
      t.boolean :played

      t.timestamps
    end
  end
end
