module Fog
  module Parsers
    module AWS
      module RDS

        class DbParser < Fog::Parsers::Base

          def reset
            @db_instance = fresh_instance
            
          end
          
          def fresh_instance
            {'PendingModifiedValues' => [], 'DBSecurityGroups' => [], 'ReadReplicaDBInstanceIdentifiers' => [], 'Endpoint' => {}}
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'PendingModifiedValues'
              @in_pending_modified_values = true
              @pending_modified_values = {}
            when 'DBSecurityGroups'
              @in_db_security_groups = true
              @db_security_groups = []
            when 'DBSecurityGroup'
              @db_security_group = {}
            when 'Endpoint'
              @in_endpoint = true
              @endpoint = {}
            when 'DBParameterGroup'
              @db_parameter_group = {}
            when 'DBParameterGroups'
              @in_db_parameter_groups = true
              @db_parameter_groups = []
            end
            
          end

          def end_element(name)
            case name
              
            when 'LatestRestorableTime', 'InstanceCreateTime'
              @db_instance[name] = Time.parse value
            when 'Engine', 
              'DBInstanceStatus', 'DBInstanceIdentifier', 'EngineVersion', 
              'PreferredBackupWindow', 'PreferredMaintenanceWindow', 
              'AvailabilityZone', 'MasterUsername', 'DBName', 'LicenseModel'
              @db_instance[name] = value
            when 'MultiAZ', 'AutoMinorVersionUpgrade'
              if value == 'false'
                @db_instance[name] = false
              else
                @db_instance[name] = true
              end
            when 'DBParameterGroups'
              @in_db_parameter_groups = false
              @db_instance['DBParameterGroups'] = @db_parameter_groups
            when 'DBParameterGroup'
              @db_parameter_groups << @db_parameter_group
              @db_parameter_group = {}
            when 'ParameterApplyStatus', 'DBParameterGroupName'
              if @in_db_parameter_groups
                @db_parameter_group[name] = value
              end
            
            when 'BackupRetentionPeriod'
              if @in_pending_modified_values
                @pending_modified_values[name] = value.to_i
              else
                @db_instance[name] = value.to_i
              end
            when 'DBInstanceClass', 'EngineVersion', 'MasterUserPassword', 'MultiAZ'
              if @in_pending_modified_values
                @pending_modified_values[name] = value
              else
                @db_instance[name] = value
              end
            when 'DBSecurityGroups'
              @in_db_security_groups = false
              @db_instance['DBSecurityGroups'] = @db_security_groups
            when 'Status', 'DBSecurityGroupName'
              if @in_db_security_groups
                @db_security_group[name]=value
              end
            when 'DBSecurityGroup'
              @db_security_groups << @db_security_group
              @db_security_group = {}
            
            when 'AllocatedStorage'
              if @in_pending_modified_values
                @pending_modified_values[name] = value.to_i
              else
                @db_instance[name] = value.to_i
              end
            when 'Address'
              @endpoint[name] = value
            when 'Port'
              if @in_pending_modified_values
                @pending_modified_values[name] = value.to_i
              elsif @in_endpoint
                @endpoint[name] = value.to_i
              end
      
            when 'PendingModifiedValues'
              @in_pending_modified_values = false
              @db_instance['PendingModifiedValues'] = @pending_modified_values
            when 'Endpoint'
              @in_endpoint = false
              @db_instance['Endpoint'] = @endpoint
            when 'ReadReplicaDBInstanceIdentifier'
              @db_instance['ReadReplicaDBInstanceIdentifiers'] << value
            when 'ReadReplicaSourceDBInstanceIdentifier'
              @db_instance['ReadReplicaSourceDBInstanceIdentifier'] = value
            when 'DBInstance'
              @db_instance = fresh_instance
            end
          end
        end
      end
    end
  end
end
