require 'rails_helper'

RSpec.describe Api::V1::WeeklySummaryService do
  describe '.call' do
    let(:week_start) { Date.new(2025, 1, 6) }  # Monday
    let(:week_end)   { Date.new(2025, 1, 12) } # Sunday

    let!(:high_score_player) do
      create(:player, name: 'High Score Player')
    end

    let!(:long_duration_player) do
      create(:player, name: 'Long Duration Player')
    end

    let!(:balanced_player) do
      create(:player, name: 'Balanced Player')
    end

    before do
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

      # Playthroughs outside the week — should be ignored
      create(:playthrough, player: high_score_player, started_at: week_end + 1.day, score: 999,
                           time_spent: 9999)
      create(:playthrough, player: long_duration_player, started_at: week_start - 1.day,
                           score: 888, time_spent: 8888)
    end

    it 'returns correct summary for the week sorted by total_score desc by default' do # rubocop:disable RSpec/ExampleLength
      summary = described_class.call(date: week_start)

      expect(summary[:week_start_date]).to eq(week_start)
      expect(summary[:week_end_date]).to eq(week_end)

      summaries = summary[:player_summaries]
      expect(summaries.size).to eq(3)

      expect(summaries.first[:player_name]).to eq('Long Duration Player')
      expect(summaries.first[:total_score]).to eq(500.0)

      expect(summaries.map { |s| s[:player_name] }).to contain_exactly(
        'High Score Player', 'Long Duration Player', 'Balanced Player'
      )
    end

    it 'sorts by total_duration ascending' do
      summary = described_class.call(date: week_start, sort_by: 'total_duration', direction: 'asc')
      names = summary[:player_summaries].map { |s| s[:player_name] }

      expect(names).to eq(['Balanced Player', 'High Score Player', 'Long Duration Player'])
    end

    it 'sorts by total_score ascending' do
      summary = described_class.call(date: week_start, sort_by: 'total_score', direction: 'asc')
      names = summary[:player_summaries].map { |s| s[:player_name] }

      expect(names).to eq(['Balanced Player', 'High Score Player', 'Long Duration Player'])
    end

    it 'returns empty summary if no playthroughs exist in the given week' do
      summary = described_class.call(date: Date.new(2020, 1, 1))
      expect(summary[:player_summaries]).to be_empty
    end

    it 'raises error for invalid date format' do
      expect do
        described_class.call(date: 'not-a-date')
      end.to raise_error(Api::V1::WeeklySummaryService::InvalidDateFormatError,
                         'Invalid date format')
    end
  end
end
