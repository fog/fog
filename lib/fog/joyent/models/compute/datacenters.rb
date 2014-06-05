require 'fog/core/collection'
require 'fog/joyent/models/compute/datacenter'

module Fog
  module Compute
    class Joyent
      class Datacenters < Fog::Collection
        model Fog::Compute::Joyent::Datacenter

        def all
          data = service.list_datacenters().body.map {|k,v| {:name => k, :url => v}}
          load(data)
        end

        def get(id)
          all[id]
        end
      end
    end # Joyent
  end # Compute
end # Fog
