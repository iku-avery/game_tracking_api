class CreatePlaythroughs < ActiveRecord::Migration[8.0]
  def change
    create_table :playthroughs, id: :uuid do |t|
      t.references :player, null: false, foreign_key: true, type: :uuid
      t.datetime :started_at, null: false
      t.datetime :finished_at, null: false
      t.decimal :score, precision: 12, scale: 2, null: false
      t.float :time_spent, null: false

      t.timestamps
    end

    add_index :playthroughs, [ :player_id, :started_at ]
    add_index :playthroughs, [ :player_id, :score ]
  end
end
