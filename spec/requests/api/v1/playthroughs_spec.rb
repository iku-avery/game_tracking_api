require 'rails_helper'

RSpec.describe "Api::V1::Playthroughs", type: :request do
  let(:player) { create(:player) }

  describe "POST /api/v1/players/:player_id/playthroughs" do
    context "with valid params" do
      let(:valid_params) do
        {
          playthrough: {
            started_at: "2025-05-12T10:00:00Z",
            finished_at: "2025-05-12T11:00:00Z",
            score: 1500.5,
            time_spent: 3600.0
          }
        }
      end

      it "creates a new playthrough" do
        expect do
          post "/api/v1/players/#{player.id}/playthroughs", params: valid_params
        end.to change(Playthrough, :count).by(1)
      end

      it "returns status 201 and correct data" do
        post "/api/v1/players/#{player.id}/playthroughs", params: valid_params
        expect(response).to have_http_status(:created)
        json = response.parsed_body
        expect(json["score"].to_f).to eq(1500.5)
      end
    end

    context "with invalid params" do
      it "returns 422 if required fields are missing" do
        post "/api/v1/players/#{player.id}/playthroughs", params: { playthrough: { score: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to include("errors")
      end
    end
  end

  describe "GET /api/v1/players/:player_id/playthroughs" do
    before do
      create_list(:playthrough, 3, player: player)
    end

    it "returns all playthroughs for a player" do
      get "/api/v1/players/#{player.id}/playthroughs"
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.size).to eq(3)
    end
  end
end
