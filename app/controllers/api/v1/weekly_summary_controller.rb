module Api
  module V1
    class WeeklySummaryController < Api::V1::BaseController
      def index
        summary = Api::V1::WeeklySummaryService.call(
          date: parsed_date,
          sort_by: validated_sort_by,
          direction: validated_direction
        )

        render json: Api::V1::WeeklySummaryBlueprint.render(summary)
      rescue ArgumentError
        render json: { error: 'Invalid date format' }, status: :unprocessable_entity
      end

      private

      def parsed_date
        return Date.current if params[:date].blank?

        Date.parse(params[:date])
      end

      def validated_sort_by
        %w[total_score total_duration].include?(params[:sort_by]) ? params[:sort_by] : 'total_score'
      end

      def validated_direction
        %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
      end
    end
  end
end
