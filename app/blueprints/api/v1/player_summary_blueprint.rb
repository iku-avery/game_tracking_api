module Api
  module V1
    class PlayerSummaryBlueprint < Blueprinter::Base
      fields :player_id, :player_name, :total_score, :total_duration
    end
  end
end
