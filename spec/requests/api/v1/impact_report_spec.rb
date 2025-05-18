require 'rails_helper'

RSpec.describe 'Impact Report API', type: :request do
  describe 'GET /api/v1/impact_report' do
    let!(:improving_player) { create(:player, name: 'Improving Player') }
    let!(:static_player)    { create(:player, name: 'Static Player') }
    let!(:declining_player) { create(:player, name: 'Declining Player') }
    let!(:no_data_player)   { create(:player, name: 'No Data Player') } # bez playthroughów # rubocop:disable RSpec/LetSetup

    before do
      # Improving Player: first_score = 100, best_score = 200, impact = 100
      create(:playthrough, player: improving_player, score: 100, started_at: 3.days.ago)
      create(:playthrough, player: improving_player, score: 200, started_at: 1.day.ago)

      # Static Player: impact = 0
      create(:playthrough, player: static_player, score: 150, started_at: 2.days.ago)

      # Declining Player: first_score = 150, best_score = 150, impact = 0
      create(:playthrough, player: declining_player, score: 150, started_at: 3.days.ago)
      create(:playthrough, player: declining_player, score: 100, started_at: 1.day.ago)

      # No Data Player: brak playthroughów
    end

    it 'returns a successful response with expected structure' do # rubocop:disable RSpec/ExampleLength
      get '/api/v1/impact_report'

      expect(response).to have_http_status(:ok)

      json = response.parsed_body

      expect(json).to be_an(Array)

      expect(json.first.keys).to match_array(%w[player_id player_name first_score best_score
                                                impact])
    end

    it 'returns players sorted by descending impact' do
      get '/api/v1/impact_report'

      json = response.parsed_body
      expect(json.first['player_name']).to eq('Improving Player')

      remaining_names = json.drop(1).map { |entry| entry['player_name'] }
      expect(remaining_names).to contain_exactly('Static Player', 'Declining Player')
    end

    it 'calculates correct impact values' do # rubocop:disable RSpec/ExampleLength
      get '/api/v1/impact_report'

      json = response.parsed_body
      player_data = json.index_by { |entry| entry['player_name'] }

      expect(player_data['Improving Player']['impact']).to eq(100.0)
      expect(player_data['Static Player']['impact']).to eq(0.0)
      expect(player_data['Declining Player']['impact']).to eq(0.0)
    end

    it 'does not include players without playthroughs' do
      get '/api/v1/impact_report'

      json = response.parsed_body
      names = json.map { |entry| entry['player_name'] }

      expect(names).not_to include('No Data Player')
    end
  end
end
