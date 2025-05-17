module Api
  module V1
    class PlaythroughsController < Api::V1::BaseController
      def index
        player = Player.find(params[:player_id])
        playthroughs = player.playthroughs.order(started_at: :desc)
        render json: Api::V1::PlaythroughBlueprint.render(playthroughs)
      end

      def create
        player = Player.find(params[:player_id])
        playthrough = player.playthroughs.create!(playthrough_params)
        render json: Api::V1::PlaythroughBlueprint.render(playthrough), status: :created
      end

      private

      def playthrough_params
        params.require(:playthrough).permit(:started_at, :score, :time_spent)
      end
    end
  end
end
