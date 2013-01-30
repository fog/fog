require 'fog/core/model'

module Fog
  module Glesys
    class Compute

      class Template < Fog::Model
        extend Fog::Deprecation

        identity :name

        attribute :platform
        attribute :operating_system, :aliases => "operatingsystem"
        attribute :minimum_memory_size, :aliases => "minimummemorysize"
        attribute :minimum_disk_size, :aliases => "minimumdisksize"
        attribute :instance_cost, :aliases => "instancecost"
        attribute :license_cost, :aliases => "licensecost"

        def list
          service.template_list
        end

      end
    end
  end
end
