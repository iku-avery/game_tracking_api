class Api::V1::PlaythroughsController < Api::V1::BaseController
  def create
    player = Player.find(params[:player_id])
    playthrough = player.playthroughs.create!(playthrough_params)
    render json: playthrough, status: :created
  end

  def index
    player = Player.find(params[:player_id])
    playthroughs = player.playthroughs.order(started_at: :desc)
    render json: playthroughs
  end

  private

  def playthrough_params
    params.require(:playthrough).permit(:player_id, :started_at, :finished_at, :score, :time_spent)
  end
end
