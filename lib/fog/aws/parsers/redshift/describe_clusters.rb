module Fog
  module Parsers
    module Redshift
      module AWS

        class DescribeClusters < Fog::Parsers::Base

          def reset
            @response = { 'ClusterSet' => [] }
            @cluster  = fresh_cluster
            @context  = []
            @contexts = ['EndPoint', 'ClusterSecurityGroups', 'VpcSecurityGroups', 'ClusterParameterGroups', 'PendingModifiedValues', 'RestoreStatus']
          end

          def fresh_cluster
            {
             'EndPoint'               => {}, 
             'ClusterSecurityGroups'  => [], 
             'VpcSecurityGroups'      => [],  
             'ClusterParameterGroups' => [], 
             'PendingModifiedValues'  => {}, 
             'RestoreStatus'          => {}
           }
          end

          def start_element(name, attrs = [])
            super
            @context.push(name) if @contexts.include?(name)
            case name
            when 'ClusterSecurityGroups'
              @in_cluster_security_groups = true              
              @cluster_security_groups = []
            when 'ClusterSecurityGroup'
              @cluster_security_group = {}
            when 'VpcSecurityGroups'
              @in_vpc_security_groups = true              
              @vpc_security_groups = []
            when 'VpcSecurityGroup'
              @vpc_security_group = {}
            when 'ClusterParameterGroups'
              @cluster_parameter_groups = []
            when 'ClusterParameterGroup'              
              @cluster_parameter_group = {}
            end
          end

          def end_element(name)
            super
            case name
            when 'Marker'
              @response[name] = value
            when 'ClusterIdentifier', 'NodeType', 'ClusterStatus', 'ModifyStatus', 'MasterUsername', 'DBName',
              'ClusterSubnetGroupName', 'VpcId', 'AvailabilityZone', 'PreferredMaintenanceWindow', 'ClusterVersion'
              @cluster[name] = value
            when 'Address'
              @cluster['EndPoint'][name] = value
            when 'Port','AutomatedSnapshotRetentionPeriod'
              @cluster['EndPoint'][name] = value.to_i
            when 'ClusterCreateTime'
              @cluster['EndPoint'][name] = Time.parse(value)
            when 'VpcSecurityGroups'
              @in_vpc_security_groups = false
              @cluster['VpcSecurityGroups'] = @vpc_security_groups
            when 'VpcSecurityGroup'
              @vpc_security_groups << @vpc_security_group
              @vpc_security_group = {}
            when 'VpcSecurityGroupId'
              @vpc_security_group[name]=value
            when 'ClusterSecurityGroups'
              @in_cluster_security_groups = false
              @cluster['ClusterSecurityGroups'] = @cluster_security_groups
            when 'ClusterSecurityGroup'
              @cluster_security_groups << @cluster_security_group
              @cluster_security_group = {}
            when 'ClusterSecurityGroupName'
              @cluster_security_group[name] = value
            when 'ClusterParameterGroups'
              @cluster['ClusterParameterGroups'] = @cluster_parameter_groups
            when 'ClusterParameterGroup'
              @cluster_parameter_groups << @cluster_parameter_group
              @cluster_parameter_group = {}
            when 'ParameterGroupName', 'ParameterApplyStatus'
              @cluster_parameter_group[name] = value
            when 'Status'
              if @in_vpc_security_groups
                @vpc_security_group[name] = value
              elsif @in_cluster_security_groups
                @cluster_security_group[name] = value
              else
                @cluster['RestoreStatus'][name] = value
              end
            when 'MasterUserPassword', 'NodeType', 'ClusterType', 'ClusterVersion'
              @cluster['PendingModifiedValues'][name] = value
            when 'AutomatedSnapshotRetentionPeriod'
              @cluster['PendingModifiedValues'][name] = value
            when 'NumberOfNodes'
              if @context.last == 'PendingModifiedValues'
                @cluster['PendingModifiedValues'][name] = value.to_i
              else
                @cluster[name] = value.to_i
              end
            when 'AllowVersionUpgrade', 'PubliclyAccessible', 'Encrypted'
              @cluster[name] = (value == true)
            when 'SnapshotSizeInMegaBytes', 'ProgressInMegaBytes', 'ElapsedTimeInSeconds', 'EstimatedTimeToCompletionInSeconds'
              @cluster['RestoreStatus'] = value.to_i
            when 'CurrentRestoreRateInMegaBytesPerSecond'
              @cluster['RestoreStatus'] = value.to_f
            when 'Cluster'
              @response['ClusterSet'] << @cluster
              @cluster = fresh_cluster
            end
            @context.pop if @contexts.include?(name)
          end
        end
      end
    end
  end
end


