require 'fog/core/model'

module Fog
  module Compute
    class SakuraCloud
      class Zone < Fog::Model
        identity :id, :aliases => 'ID'
        attribute :name, :aliases => 'Name'
        attribute :description, :aliases => 'Description'
      end
    end
  end
end
