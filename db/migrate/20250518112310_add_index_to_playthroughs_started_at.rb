class AddIndexToPlaythroughsStartedAt < ActiveRecord::Migration[8.0]
  def change
    add_index :playthroughs, [:started_at, :player_id]
  end
end
