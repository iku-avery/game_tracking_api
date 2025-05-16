class Player < ApplicationRecord
  has_many :playthroughs, dependent: :destroy

  validates :name, presence: true
end
