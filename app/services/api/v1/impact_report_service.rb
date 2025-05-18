module Api
  module V1
    class ImpactReportService
      def self.call
        new.call
      end

      def call
        player_data = collect_players_data
        calculate_and_sort_impact(player_data)
      end

      private

      def collect_players_data
        player_ids = Player.joins(:playthroughs).distinct.pluck(:id)

        first_scores = find_first_scores(player_ids)
        best_scores = find_best_scores(player_ids)

        players = Player.where(id: player_ids).index_by(&:id)

        {
          players: players,
          first_scores: first_scores,
          best_scores: best_scores,
          player_ids: player_ids
        }
      end

      def find_first_scores(player_ids)
        scores = {}

        Playthrough.select("DISTINCT ON (player_id) player_id, score")
                   .where(player_id: player_ids)
                   .order("player_id, started_at ASC, id ASC")
                   .each do |pt|
          scores[pt.player_id] = pt.score.to_f
        end

        scores
      end

      def find_best_scores(player_ids)
        Playthrough.where(player_id: player_ids)
                   .group(:player_id)
                   .maximum(:score)
                   .transform_values(&:to_f)
      end

      def calculate_and_sort_impact(data) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        players = data[:players]
        first_scores = data[:first_scores]
        best_scores = data[:best_scores]
        player_ids = data[:player_ids]

        # Calculate impact for each player
        impact_data = player_ids.map do |player_id|
          player = players[player_id]
          first_score = first_scores[player_id]
          best_score = best_scores[player_id]
          impact = best_score - first_score

          {
            player_id: player_id,
            player_name: player.name,
            first_score: first_score,
            best_score: best_score,
            impact: impact
          }
        end

        impact_data.sort_by { |player| -player[:impact] }
      end
    end
  end
end
