module Api
  module V1
    class ImpactReportController < Api::V1::BaseController
      def index
        report = Api::V1::ImpactReportService.call
        render json: Api::V1::ImpactReportBlueprint.render(report)
      end
    end
  end
end
