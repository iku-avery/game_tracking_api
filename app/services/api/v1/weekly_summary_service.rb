module Api
  module V1
    class WeeklySummaryService
      def self.call(date: nil, sort_by: 'total_score', direction: 'desc')
        date = normalize_date(date)
        playthroughs = fetch_playthroughs_for_the_week(date)
        player_summaries = calculate_player_summaries(playthroughs, sort_by, direction)

        summarize(date, date.end_of_week, player_summaries)
      end

      class << self
        private

        def normalize_date(date)
          date ||= Date.current
          date.beginning_of_week(:monday)
        end

        def fetch_playthroughs_for_the_week(date)
          Playthrough.where(started_at: date.beginning_of_day..date.end_of_week.end_of_day)
        end

        def calculate_player_summaries(playthroughs, sort_by, direction) # rubocop:disable Metrics/MethodLength
          summaries = playthroughs
                      .joins(:player)
                      .group('players.id', 'players.name')
                      .select(
                        'players.id as player_id',
                        'players.name as player_name',
                        'SUM(playthroughs.score) as total_score',
                        'SUM(playthroughs.time_spent) as total_duration'
                      )
                      .map do |result|
            {
              player_id: result.player_id,
              player_name: result.player_name,
              total_score: result.total_score.to_f,
              total_duration: result.total_duration.to_f
            }
          end

          summaries.sort_by! { |s| s[sort_by.to_sym] }
          summaries.reverse! if direction == 'desc'

          summaries
        end

        def summarize(start_date, end_date, summaries)
          {
            week_start_date: start_date,
            week_end_date: end_date,
            player_summaries: summaries
          }
        end
      end
    end
  end
end
