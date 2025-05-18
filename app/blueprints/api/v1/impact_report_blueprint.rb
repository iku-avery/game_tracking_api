module Api
  module V1
    class ImpactReportBlueprint < Blueprinter::Base
      fields :player_id, :player_name, :first_score, :best_score, :impact
    end
  end
end
