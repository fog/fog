require 'fog/core/model'

module Fog
  module Compute
    class SakuraCloud
      class Plan < Fog::Model

        identity :ID
        attribute :Name
        attribute :ServiceClass
        attribute :CPU
        attribute :MemoryMB


      end
    end
  end
end
