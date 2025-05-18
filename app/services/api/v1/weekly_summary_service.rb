module Api
  module V1
    require 'benchmark'
    class WeeklySummaryService
      def self.call(date = nil)
        date = normalize_date(date)
        playthroughs = fetch_playthroughs_for_the_week(date)
        player_summaries = calculate_player_summaries(playthroughs)
        summarize(date, date.end_of_week, player_summaries)
      end

      class << self
        private

        def normalize_date(date)
          date ||= Date.current
          date.beginning_of_week(:monday)
        end

        def fetch_playthroughs_for_the_week(date)
          end_date = date.end_of_week
          Playthrough.where(started_at: date.beginning_of_day..end_date.end_of_day)
        end

        def calculate_player_summaries(playthroughs) # rubocop:disable Metrics/MethodLength
          playthroughs
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
