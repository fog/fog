module Fog
  module Parsers
    module Redshift
      module AWS

        class ClusterParser < Fog::Parsers::Base
          # :allow_version_upgrade` - (Boolean) z
          # :automated_snapshot_retention_period` - (Integer) w
          # :availability_zone`  - (String) x
          # :cluster_create_time` - (Time) y
          # :cluster_identifier` - (String) x
          # :cluster_parameter_groups` - (Array<Hash>)
          #   :parameter_group_name` - (String)
          #   :parameter_apply_status` - (String)
          # :cluster_security_groups`  - (Array<Hash>)
          #   :cluster_security_group_name` - (String)
          #   :status`  - (String)
          # :cluster_status` - (String) x
          # :cluster_subnet_group_name` - (String) x
          # :cluster_version`  - (String) x
          # :db_name` - (String) x
          # :encrypted` - (Boolean) z
          # :endpoint` - (Hash)
          #   :address` - (String)
          #   :port` - (Integer)
          # :master_username` - (String) x
          # :modify_status` - (String) x
          # :node_type` - (String) x
          # :number_of_nodes` - (Integer) w
          # :pending_modified_values`  - (Hash)
          #   :master_user_password` - (String)
          #   :node_type` - (String)
          #   :number_of_nodes` - (Integer)
          #   :cluster_type` - (String)
          #   :cluster_version`  - (String)
          #   :automated_snapshot_retention_period` - (Integer)
          # :preferred_maintenance_window` - (String) x
          # :publicly_accessible` - (Boolean) z
          # :restore_status`  - (Hash)
          #   :status` - (String)
          #   :current_restore_rate_in_mega_bytes_per_second`  - (Numeric)
          #   :snapshot_size_in_mega_bytes` - (Integer)
          #   :progress_in_mega_bytes`  - (Integer)
          #   :elapsed_time_in_seconds` - (Integer)
          #   :estimated_time_to_completion_in_seconds`  - (Integer)
          # :vpc_id` - (String) x
          # :vpc_security_groups` - (Array<Hash>)
          #   :vpc_security_group_id`  - (String)
          #   :status` - (String)

          def reset
            @response = { 'ClusterParameterGroups' => [], 'ClusterSecurityGroups' => [], 'VpcSecurityGroups' => [], 
                          'EndPoint' => {}, 'PendingModifiedValues'=> {}, 'RestoreStatus' => {}}
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'ClusterSecurityGroups'
              @in_cluster_security_groups = true
              @cluster_security_group = {}
            when 'ClusterParameterGroups'
              @cluster_parameter_group = {}
            when 'VpcSecurityGroups'
              @in_vpc_security_groups = true
              @vpc_security_group = {}
            when 'PendingModifiedValues'
              @in_pending_modified_values = true
            end
          end

          def end_element(name)            
            case name
            when 'AvailabilityZone', 'ClusterIdentifier', 'ClusterStatus', 'ClusterSubnetGroupName', 'DBName', 
              'MasterUsername', 'ModifyStatus', 'PreferredMaintenanceWindow', 'VpcId'
              @response[name] = value
            when 'ClusterCreateTime'
              @response[name] = Time.parse(value)
            when 'AllowVersionUpgrade', 'Encrypted', 'PubliclyAccessible'
              @response[name] = (value == true)
            when 'Address'
              @response['EndPoint'][name] = value            
            when 'Port'
              @response['EndPoint'][name] = value.to_i
            when 'NodeType', 'ClusterVersion'
              if @in_pending_modified_values
                @response['PendingModifiedValues'][name] = value
              else
                @response[name] = value
              end
            when 'NumberOfNodes', 'AutomatedSnapshotRetentionPeriod'
              if @in_pending_modified_values
                @response['PendingModifiedValues'][name] = value.to_i
              else
                @response[name] = value.to_i
              end
            when 'MasterUserPassword', 'ClusterType'
              @response['PendingModifiedValues'][name] = value
            when 'Status'
              if @in_vpc_security_groups
                @vpc_security_group[name] = value
              elsif @in_cluster_security_groups
                @cluster_security_group[name] = value
              else
                @response['RestoreStatus'][name] = value
              end
            when 'ParameterGroupName', 'ParameterApplyStatus'
              @cluster_parameter_group[name] = value
            when 'ClusterSecurityGroupName'
              @cluster_security_group[name] = value
            when 'VpcSecurityGroupId'
              @vpc_security_group[name] = value
            when 'SnapshotSizeInMegaBytes', 'ProgressInMegaBytes', 'ElapsedTimeInSeconds', 'EstimatedTimeToCompletionInSeconds'
              @response['RestoreStatus'][name] = value.to_i
            when 'CurrentRestoreRateInMegaBytesPerSecond'
              @response['RestoreStatus'][name] = value.to_f

            when 'ClusterSecurityGroups'
              @in_cluster_security_groups = false
            when 'VpcSecurityGroups'
              @in_vpc_security_groups = false
            when 'PendingModifiedValues'
              @in_pending_modified_values = false

            when 'ClusterParameterGroup'
              @response['ClusterParameterGroups'] << @cluster_parameter_group
              @cluster_parameter_group = {}
            when 'ClusterSecurityGroup'
              @response['ClusterSecurityGroups'] << @cluster_security_group
              @cluster_security_group = {}
            when 'VpcSecurityGroup'
              @response['VpcSecurityGroups'] << @vpc_security_group
              @vpc_security_group = {}

            end
          end
        end
      end
    end
  end
end