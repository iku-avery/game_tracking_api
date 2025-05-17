module Api
  module V1
    class PlaythroughBlueprint < Blueprinter::Base
      identifier :id

      fields :started_at, :score, :time_spent, :created_at

      field :player_id
    end
  end
end
