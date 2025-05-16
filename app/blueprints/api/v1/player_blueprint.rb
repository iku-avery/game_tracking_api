module Api
  module V1
    class PlayerBlueprint < Blueprinter::Base
      identifier :id

      view :create do
        fields :id, :name
      end
    end
  end
end
