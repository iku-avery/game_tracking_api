class Playthrough < ApplicationRecord
  belongs_to :player

  validates :started_at, presence: true
  validates :finished_at, presence: true
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :time_spent, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
