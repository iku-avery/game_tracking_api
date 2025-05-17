geralt = Player.create!(name: "Geralt")

Playthrough.create!([
                      {
                        player: geralt,
                        started_at: 1.week.ago.beginning_of_week + 1.hour,
                        score: 150.50,
                        time_spent: 3600.0
                      },
                      {
                        player: geralt,
                        started_at: 2.days.ago.beginning_of_day,
                        score: 200.00,
                        time_spent: 3600.0
                      }
                    ])
