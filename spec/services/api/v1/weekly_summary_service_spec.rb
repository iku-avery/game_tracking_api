require 'rails_helper'

RSpec.describe Api::V1::WeeklySummaryService do
  describe '.call' do
    let(:week_start) { Date.new(2025, 1, 6) } # Monday
    let(:week_end)   { Date.new(2025, 1, 12) } # Sunday

    let!(:high_score_player)     { create(:player, name: 'High Score Player') }
    let!(:long_duration_player)  { create(:player, name: 'Long Duration Player') }
    let!(:balanced_player)       { create(:player, name: 'Balanced Player') }

    context 'when playthroughs exist in the given week' do
      before do
        # High Score Player: 100 + 200 = 300 score, 1000 + 2000 = 3000 time
        create(:playthrough, player: high_score_player, started_at: week_start.noon, score: 100,
                             time_spent: 1000)
        create(:playthrough, player: high_score_player, started_at: week_start + 2.days,
                             score: 200, time_spent: 2000)

        # Long Duration Player: 500 score, 3000 time
        create(:playthrough, player: long_duration_player, started_at: week_start + 4.days,
                             score: 500, time_spent: 3000)

        # Balanced Player: 150 score, 1500 time
        create(:playthrough, player: balanced_player, started_at: week_end.noon, score: 150,
                             time_spent: 1500)

        # Outside week — ignored
        create(:playthrough, player: high_score_player, started_at: week_end + 1.day, score: 999,
                             time_spent: 9999)
        create(:playthrough, player: long_duration_player, started_at: week_start - 1.day,
                             score: 888, time_spent: 8888)
      end

      it 'returns correct summary for a date in the middle of the week' do # rubocop:disable RSpec/ExampleLength
        summary = described_class.call(week_start + 2.days)

        expect(summary[:week_start_date]).to eq(week_start)
        expect(summary[:week_end_date]).to eq(week_end)
        expect(summary[:player_summaries].size).to eq(3)

        expect(summary[:player_summaries]).to include(
          a_hash_including(
            player_name: 'High Score Player',
            total_score: 300,
            total_duration: 3000
          ),
          a_hash_including(
            player_name: 'Long Duration Player',
            total_score: 500,
            total_duration: 3000
          ),
          a_hash_including(
            player_name: 'Balanced Player',
            total_score: 150,
            total_duration: 1500
          )
        )
      end
    end

    context 'when no playthroughs exist in the given week' do
      it 'returns empty player_summaries' do
        summary = described_class.call(Date.new(2020, 1, 1))
        expect(summary[:player_summaries]).to be_empty
      end
    end
  end
end
