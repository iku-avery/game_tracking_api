require 'rails_helper'

RSpec.describe "Api::V1::WeeklySummary", type: :request do
  describe "GET /api/v1/weekly_summary" do
    let!(:high_score_player) { create(:player, name: "High Score Player") }
    let!(:long_duration_player) { create(:player, name: "Long Duration Player") }

    before do
      # High Score Player: total_score = 300, total_duration = 5400
      create(:playthrough, player: high_score_player,
                           started_at: Date.current.beginning_of_week + 1.day, score: 100,
                           time_spent: 1800)
      create(:playthrough, player: high_score_player,
                           started_at: Date.current.beginning_of_week + 2.days, score: 200,
                           time_spent: 3600)

      # Long Duration Player: total_score = 100, total_duration = 7200
      create(:playthrough, player: long_duration_player,
                           started_at: Date.current.beginning_of_week + 3.days, score: 100,
                           time_spent: 7200)
    end

    it "returns sorted summaries by total_score desc by default when no date param" do # rubocop:disable RSpec/ExampleLength
      get "/api/v1/weekly_summary"
      expect(response).to have_http_status(:ok)

      json = response.parsed_body
      summaries = json['player_summaries']
      expect(summaries.size).to eq(2)

      expect(summaries.first['player_name']).to eq("High Score Player")
      expect(summaries.first['total_score']).to eq(300.0)
    end

    it "returns sorted summaries by total_score desc with valid date param" do # rubocop:disable RSpec/ExampleLength
      get "/api/v1/weekly_summary", params: { date: Date.current.to_s }
      expect(response).to have_http_status(:ok)

      json = response.parsed_body
      summaries = json['player_summaries']
      expect(summaries.size).to eq(2)

      expect(summaries.first['player_name']).to eq("High Score Player")
      expect(summaries.first['total_score']).to eq(300.0)
    end

    it "returns sorted summaries by total_duration asc" do # rubocop:disable RSpec/ExampleLength
      get "/api/v1/weekly_summary", params: { sort_by: 'total_duration', direction: 'asc' }
      expect(response).to have_http_status(:ok)

      json = response.parsed_body
      summaries = json['player_summaries']
      expect(summaries.size).to eq(2)

      # Long Duration Player has higher total_duration so should come last in asc order
      expect(summaries.first['player_name']).to eq("High Score Player")
      expect(summaries.first['total_duration']).to eq(5400.0)
    end

    it "returns 422 for invalid date format" do
      get "/api/v1/weekly_summary", params: { date: "invalid-date" }
      expect(response).to have_http_status(:unprocessable_entity)

      json = response.parsed_body
      expect(json['error']).to eq('Invalid date format')
    end
  end
end
