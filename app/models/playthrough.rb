class Playthrough < ApplicationRecord
  belongs_to :player

  validates :started_at, presence: true
  validates :finished_at, presence: true
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :time_spent, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :finished_at_after_started_at

  private

  def finished_at_after_started_at
    return if finished_at.blank? || started_at.blank?
    if finished_at < started_at
      errors.add(:finished_at, "must be after the start time")
    end
  end
end
