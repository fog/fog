require 'fog/core/collection'
require 'fog/cloudstack/models/compute/server'
require 'pp'

module Fog
  module Compute
    class Cloudstack

      class Servers < Fog::Collection

        attribute :filters

        model Fog::Compute::Cloudstack::Server

        def initialize(attribute)
          self.filters ||= {}
          super
        end

        def all(filters = self.filters)
          data = connection.list_virtual_machines.body
          load(
            data['virtualMachines'].map do |instance|
                instance
            end.flatten
          )
        end
      end
    end
  end
end
