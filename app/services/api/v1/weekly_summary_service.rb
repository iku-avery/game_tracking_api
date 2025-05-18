module Api
  module V1
    class WeeklySummaryService
      ALLOWED_SORT_COLUMNS = %w[total_score total_duration].freeze
      ALLOWED_DIRECTIONS = %w[asc desc].freeze

      class InvalidDateFormatError < StandardError; end

      def self.call(date: nil, sort_by: 'total_score', direction: 'desc')
        date = normalize_date(date)
        sort_by = 'total_score' unless ALLOWED_SORT_COLUMNS.include?(sort_by)
        direction = 'desc' unless ALLOWED_DIRECTIONS.include?(direction)

        player_summaries = fetch_and_aggregate_playthroughs(date, sort_by, direction)

        week_start = date.beginning_of_week(:monday)
        week_end = week_start + 6.days

        summarize(week_start, week_end, player_summaries)
      rescue ArgumentError
        raise InvalidDateFormatError, 'Invalid date format'
      end

      class << self
        private

        def normalize_date(date)
          date ||= Date.current
          return date if date.is_a?(Date)

          Date.parse(date.to_s)
        end

        def fetch_and_aggregate_playthroughs(date, sort_by, direction) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
          week_start = date.beginning_of_week(:monday).beginning_of_day.utc
          week_end = (week_start.to_date + 6.days).end_of_day.utc

          # Stable order: primary sort + player_name ASC as secondary
          order_clause = "#{sort_by} #{direction}, players.name ASC"

          Playthrough.joins(:player)
                     .where(started_at: week_start..week_end)
                     .group('players.id', 'players.name')
                     .select(
                       'players.id as player_id',
                       'players.name as player_name',
                       'SUM(playthroughs.score) as total_score',
                       'SUM(playthroughs.time_spent) as total_duration'
                     )
                     .order(Arel.sql(order_clause))
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
