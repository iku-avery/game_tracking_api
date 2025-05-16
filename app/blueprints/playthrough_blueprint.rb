class PlaythroughBlueprint < Blueprinter::Base
  identifier :id

  fields :started_at, :finished_at, :score, :time_spent, :created_at

  field :player_id
end
