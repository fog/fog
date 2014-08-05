require 'fog/core/model'

module Fog
  module Compute
    class HP
      class Flavor < Fog::Model
        identity :id

        attribute :disk
        attribute :name
        attribute :ram
        attribute :cores, :aliases => 'vcpus'

        #def bits
        #  64
        #end
      end
    end
  end
end
