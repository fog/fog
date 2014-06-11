require 'fog/core/model'

module Fog
  module Volume
    class SakuraCloud
      class Plan < Fog::Model
        identity :id, :aliases => 'ID'
        attribute :name, :aliases => 'Name'
      end
    end
  end
end
