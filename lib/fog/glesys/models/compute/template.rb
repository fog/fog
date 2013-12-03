require 'fog/core/model'

module Fog
  module Compute
    class Glesys
      class Template < Fog::Model
        identity :name
        attribute :platform
        attribute :operating_system, :aliases => "operatingsystem"
        attribute :minimum_memory_size, :aliases => "minimummemorysize"
        attribute :minimum_disk_size, :aliases => "minimumdisksize"
        attribute :instance_cost, :aliases => "instancecost"
        attribute :license_cost, :aliases => "licensecost"
      end
    end
  end
end
