require 'fog/core/model'

module Fog
  module Compute
    class SakuraCloud
      class Plan < Fog::Model
        identity :id, :aliases => 'ID'
        attribute :name, :aliases => 'Name'
        attribute :server_class, :aliases => 'ServiceClass'
        attribute :cpu, :aliases => 'CPU'
        attribute :memory_mb, :aliases => 'MemoryMB'
      end
    end
  end
end
