# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

geralt = Player.create!(name: "Geralt")

Playthrough.create!([
  {
    player: geralt,
    started_at: 1.week.ago.beginning_of_week + 1.hour,
    finished_at: 1.week.ago.beginning_of_week + 2.hours,
    score: 150.50,
    time_spent: 3600.0
  },
  {
    player: geralt,
    started_at: 2.days.ago.beginning_of_day,
    finished_at: 2.days.ago.beginning_of_day + 1.hour,
    score: 200.00,
    time_spent: 3600.0
  }
])
