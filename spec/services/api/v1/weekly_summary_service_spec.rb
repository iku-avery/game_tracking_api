require 'rails_helper'

RSpec.describe Api::V1::WeeklySummaryService do
  describe '.call' do
    let(:week_start) { Date.new(2025, 1, 6) }  # Monday
    let(:week_end)   { Date.new(2025, 1, 12) } # Sunday

    let!(:high_score_player)    { create(:player, name: 'High Score Player') }
    let!(:long_duration_player) { create(:player, name: 'Long Duration Player') }
    let!(:balanced_player)      { create(:player, name: 'Balanced Player') }

    before do
      create_playthroughs_for_players
    end

    def create_playthroughs_for_players # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      # High Score Player: 300 pts, 3000 sec
      create(:playthrough, player: high_score_player, started_at: week_start.noon, score: 100,
                           time_spent: 1000)
      create(:playthrough, player: high_score_player, started_at: week_start + 2.days, score: 200,
                           time_spent: 2000)

      # Long Duration Player: 500 pts, 3000 sec
      create(:playthrough, player: long_duration_player, started_at: week_start + 4.days,
                           score: 500, time_spent: 3000)

      # Balanced Player: 150 pts, 1500 sec
      create(:playthrough, player: balanced_player, started_at: week_end.noon, score: 150,
                           time_spent: 1500)

      # Outside of week — should be ignored
      create(:playthrough, player: high_score_player, started_at: week_end + 1.day, score: 999,
                           time_spent: 9999)
      create(:playthrough, player: long_duration_player, started_at: week_start - 1.day,
                           score: 888, time_spent: 8888)
    end

    context 'when playthroughs exist in the given week' do
      it 'returns correct summary for the week' do # rubocop:disable RSpec/ExampleLength
        summary = described_class.call(date: week_start + 2.days)

        expect(summary[:week_start_date]).to eq(week_start)
        expect(summary[:week_end_date]).to eq(week_end)

        expect(summary[:player_summaries].size).to eq(3)

        expect(summary[:player_summaries]).to include(
          a_hash_including(player_name: 'High Score Player', total_score: 300.0,
                           total_duration: 3000.0),
          a_hash_including(player_name: 'Long Duration Player', total_score: 500.0,
                           total_duration: 3000.0),
          a_hash_including(player_name: 'Balanced Player', total_score: 150.0,
                           total_duration: 1500.0)
        )
      end

      it 'sorts by total_score descending by default' do
        summary = described_class.call(date: week_start)
        names = summary[:player_summaries].map { |ps| ps[:player_name] }

        expect(names).to eq(['Long Duration Player', 'High Score Player', 'Balanced Player'])
      end

      it 'sorts by total_duration ascending' do
        summary = described_class.call(date: week_start, sort_by: 'total_duration',
                                       direction: 'asc')
        names = summary[:player_summaries].map { |ps| ps[:player_name] }

        expect(names).to eq(['Balanced Player', 'High Score Player', 'Long Duration Player'])
      end

      it 'sorts by total_score ascending' do
        summary = described_class.call(date: week_start, sort_by: 'total_score', direction: 'asc')
        names = summary[:player_summaries].map { |ps| ps[:player_name] }

        expect(names).to eq(['Balanced Player', 'High Score Player', 'Long Duration Player'])
      end
    end

    context 'when no playthroughs exist in the given week' do
      it 'returns an empty player_summaries array' do
        summary = described_class.call(date: Date.new(2020, 1, 1))
        expect(summary[:player_summaries]).to eq([])
      end
    end
  end
end
