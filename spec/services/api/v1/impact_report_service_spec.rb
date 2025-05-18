require 'rails_helper'

RSpec.describe Api::V1::ImpactReportService do
  describe '.call' do
    let!(:consistent_improver) { create(:player, name: 'Consistent Improver') }
    let!(:moderate_progress)   { create(:player, name: 'Moderate Progress') }
    let!(:no_progress)         { create(:player, name: 'No Progress') }
    let!(:declining_player)    { create(:player, name: 'Declining Player') }
    let!(:inactive_player)     { create(:player, name: 'Inactive Player') } # no playthroughs # rubocop:disable RSpec/LetSetup

    before do
      # Consistent Improver: first_score = 100, best_score = 300, impact = 200
      create(:playthrough, player: consistent_improver, score: 100, started_at: 3.days.ago)
      create(:playthrough, player: consistent_improver, score: 300, started_at: 1.day.ago)

      # Moderate Progress: first_score = 150, best_score = 250, impact = 100
      create(:playthrough, player: moderate_progress, score: 150, started_at: 4.days.ago)
      create(:playthrough, player: moderate_progress, score: 250, started_at: 2.days.ago)

      # No Progress: only 1 playthrough, first_score = best_score = 180, impact = 0
      create(:playthrough, player: no_progress, score: 180, started_at: 2.days.ago)

      # Declining Player: first_score = 200, best_score = 200, impact = 0
      # + one lower score later, best_score stays 200, impact = 0
      create(:playthrough, player: declining_player, score: 200, started_at: 3.days.ago)
      create(:playthrough, player: declining_player, score: 150, started_at: 1.day.ago)
    end

    it 'returns players sorted by highest impact' do # rubocop:disable RSpec/ExampleLength
      result = described_class.call

      expect(result.length).to eq(4)

      impacts = result.map { |r| r[:impact] }
      expect(impacts).to eq(impacts.sort.reverse)

      players = result.index_by { |r| r[:player_name] }

      expect(players['Consistent Improver']).to include(
        first_score: 100.0,
        best_score: 300.0,
        impact: 200.0
      )

      expect(players['Moderate Progress']).to include(
        first_score: 150.0,
        best_score: 250.0,
        impact: 100.0
      )

      expect(players['No Progress']).to include(
        first_score: 180.0,
        best_score: 180.0,
        impact: 0.0
      )

      expect(players['Declining Player']).to include(
        first_score: 200.0,
        best_score: 200.0,
        impact: 0.0
      )
    end

    it 'excludes players without any playthroughs' do
      names = described_class.call.map { |r| r[:player_name] }
      expect(names).not_to include('Inactive Player')
    end

    it 'returns expected keys in each result' do
      result = described_class.call.first
      expect(result.keys).to match_array(%i[player_id player_name first_score best_score impact])
    end
  end
end
