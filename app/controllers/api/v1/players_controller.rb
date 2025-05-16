class Api::V1::PlayersController < Api::V1::BaseController
  def create
    player = Player.create!(player_params)
    render json: PlayerBlueprint.render(player), status: :created
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end
end
