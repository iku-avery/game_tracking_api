module Api
  module V1
    class WeeklySummaryController < Api::V1::BaseController
      def index
        date = parse_date(params[:date]) || Date.current

        summary = Api::V1::WeeklySummaryService.call(date)
        render json: Api::V1::WeeklySummaryBlueprint.render(summary)
      rescue ArgumentError
        render json: { error: "Invalid date format" }, status: :unprocessable_entity
      end

      private

      def parse_date(date_str)
        return nil if date_str.blank?

        Date.parse(date_str)
      rescue ArgumentError
        raise ArgumentError, "Invalid date format"
      end
    end
  end
end
