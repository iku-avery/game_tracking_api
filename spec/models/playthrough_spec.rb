require 'rails_helper'

RSpec.describe Playthrough, type: :model do
  let(:player) { create(:player) }

  it "is valid with valid attributes" do
    playthrough = build(:playthrough, player: player)
    expect(playthrough).to be_valid
  end

  it "is not valid if finished_at is before started_at" do
    playthrough = build(:playthrough, player: player, started_at: Time.now, finished_at: 1.hour.ago)
    expect(playthrough).not_to be_valid
    expect(playthrough.errors[:finished_at]).to include("must be after the start time")
  end
end
