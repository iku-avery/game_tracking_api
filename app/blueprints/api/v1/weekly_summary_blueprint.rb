module Api
  module V1
    class WeeklySummaryBlueprint < Blueprinter::Base
      fields :week_start_date, :week_end_date

      association :player_summaries, blueprint: Api::V1::PlayerSummaryBlueprint
    end
  end
end
