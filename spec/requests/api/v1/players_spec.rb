require 'rails_helper'

RSpec.describe "Api::V1::Players", type: :request do
  describe "POST /api/v1/players" do
    context "with valid params" do
      let(:valid_params) { { player: { name: "Geralt" } } }

      it "creates a new player" do
        expect do
          post "/api/v1/players", params: valid_params
        end.to change(Player, :count).by(1)
      end

      it "returns status 201 and correct body" do
        post "/api/v1/players", params: valid_params
        expect(response).to have_http_status(:created)
        json = response.parsed_body
        expect(json["name"]).to eq("Geralt")
        expect(json.keys).to match_array(%w[id name])
      end
    end

    context "with invalid params" do
      it "returns status 422 when name is nil" do
        post "/api/v1/players", params: { player: { name: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
        json = response.parsed_body
        expect(json).to have_key("errors")
      end
    end
  end
end
