require 'fog/core/model'

module Fog
  module AWS
    class RDS
      class InstanceOption < Fog::Model
        attribute :multi_az_capable, :aliases => 'MultiAZCapable', :type => :boolean
        attribute :engine, :aliases => 'Engine'
        attribute :license_model, :aliases => 'LicenseModel'
        attribute :read_replica_capable, :aliases => 'ReadReplicaCapable', :type => :boolean
        attribute :engine_version, :aliases => 'EngineVersion'
        attribute :availability_zones, :aliases => 'AvailabilityZones', :type => :array
        attribute :db_instance_class, :aliases => 'DBInstanceClass'
        attribute :vpc, :aliases => 'Vpc', :type => :boolean
      end
    end
  end
end
