geralt = Player.create!(name: "Geralt")
yennefer = Player.create!(name: "Yennefer")
ciri = Player.create!(name: "Ciri")
dandelion = Player.create!(name: "Dandelion")
triss = Player.create!(name: "Triss")

Playthrough.create!([
                      { player: geralt, started_at: 1.week.ago.beginning_of_week + 1.hour, score: 150.5,
                        time_spent: 3600.0 },
                      { player: geralt, started_at: 2.days.ago.beginning_of_day, score: 200.0,
                        time_spent: 3600.0 },
                      { player: geralt, started_at: 3.weeks.ago.beginning_of_week + 3.days, score: 120.0,
                        time_spent: 1800.0 }
                    ])

Playthrough.create!([
                      { player: yennefer, started_at: 1.week.ago.beginning_of_week + 2.days + 2.hours, score: 300.0,
                        time_spent: 5400.0 },
                      { player: yennefer, started_at: 2.days.ago.beginning_of_day + 30.minutes, score: 400.0,
                        time_spent: 3600.0 },
                      { player: yennefer, started_at: 4.weeks.ago.beginning_of_week + 1.day, score: 500.0,
                        time_spent: 7200.0 }
                    ])

Playthrough.create!([
                      { player: ciri, started_at: 3.days.ago.beginning_of_day + 3.hours, score: 500.0,
                        time_spent: 5400.0 },
                      { player: ciri, started_at: 1.week.ago.beginning_of_week + 5.days, score: 100.0,
                        time_spent: 1800.0 }
                    ])

Playthrough.create!([
                      { player: dandelion, started_at: 5.weeks.ago.beginning_of_week, score: 50.0,
                        time_spent: 1200.0 }
                    ])

Playthrough.create!([
                      { player: triss, started_at: 1.week.ago.beginning_of_week + 1.day + 1.hour, score: 250.0,
                        time_spent: 2700.0 },
                      { player: triss, started_at: 1.week.ago.beginning_of_week + 3.days + 3.hours, score: 300.0,
                        time_spent: 3300.0 },
                      { player: triss, started_at: 1.week.ago.beginning_of_week + 6.days + 2.hours, score: 150.0,
                        time_spent: 1800.0 }
                    ])
