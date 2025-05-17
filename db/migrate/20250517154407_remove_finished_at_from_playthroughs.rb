class RemoveFinishedAtFromPlaythroughs < ActiveRecord::Migration[8.0]
  def change
    remove_column :playthroughs, :finished_at, :datetime
  end
end
