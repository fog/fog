module Fog
  module Parsers
    module AWS
      module RDS
        class SnapshotParser < Fog::Parsers::Base
          def reset
            @db_snapshot = fresh_snapshot
          end

          def fresh_snapshot
            {}
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
            when 'AllocatedStorage' then @db_snapshot['AllocatedStorage'] = value.to_i
            when 'AvailabilityZone' then @db_snapshot['AvailabilityZone'] = value
            when 'DBInstanceIdentifier' then @db_snapshot['DBInstanceIdentifier'] = value
            when 'DBSnapshotIdentifier' then @db_snapshot['DBSnapshotIdentifier'] = value
            when 'Engine' then @db_snapshot['Engine'] = value
            when 'EngineVersion' then @db_snapshot['EngineVersion'] = value
            when 'InstanceCreateTime' then @db_snapshot['InstanceCreateTime'] = Time.parse value
            when 'Iops' then @db_snapshot['Iops'] = value
            when 'MasterUsername' then @db_snapshot['MasterUsername'] = value
            when 'Port' then @db_snapshot['Port'] = value.to_i
            when 'SnapshotCreateTime' then @db_snapshot['SnapshotCreateTime'] = Time.parse value
            when 'SnapshotType' then @db_snapshot['SnapshotType'] = value
            when 'Status' then @db_snapshot['Status'] = value
            end
          end
        end
      end
    end
  end
end
