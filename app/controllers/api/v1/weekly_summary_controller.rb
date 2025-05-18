module Api
  module V1
    class WeeklySummaryController < Api::V1::BaseController
      def index
        render json: { message: "Weekly summary" }
      end
    end
  end
end
