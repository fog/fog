module Fog
  module Parsers
    module Redshift
      module AWS

        class DescribeClusterSnapshots < Fog::Parsers::Base
          # :marker - (String)
          # :snapshots - (Array)
          #   :snapshot_identifier - (String)
          #   :cluster_identifier - (String)
          #   :snapshot_create_time - (Time)
          #   :status - (String)
          #   :port - (Integer)
          #   :availability_zone - (String)
          #   :cluster_create_time - (Time)
          #   :master_username - (String)
          #   :cluster_version - (String)
          #   :snapshot_type - (String)
          #   :node_type - (String)
          #   :number_of_nodes - (Integer)
          #   :db_name - (String)
          #   :vpc_id - (String)
          #   :encrypted - (Boolean)
          #   :accounts_with_restore_access - (Array)
          #     :account_id - (String)
          #   :owner_account - (String)
          #   :total_backup_size_in_mega_bytes - (Numeric)
          #   :actual_incremental_backup_size_in_mega_bytes - (Numeric)
          #   :backup_progress_in_mega_bytes - (Numeric)
          #   :current_backup_rate_in_mega_bytes_per_second - (Numeric)
          #   :estimated_seconds_to_completion - (Integer)
          #   :elapsed_time_in_seconds - (Integer)

          def reset
            @response = { 'Snapshots' => [] }
          end

          def fresh_snapshot
            {'AccountsWithRestoreAccess' => []}
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'Snapshots'
              @snapshot = fresh_snapshot
            end
          end

          def end_element(name)   
            super         
            case name
            when 'Marker'
              @response[name] = value
            when 'SnapshotIdentifier', 'ClusterIdentifier', 'Status', 'AvailabilityZone', 'MasterUsername', 'ClusterVersion',
              'SnapshotType', 'NodeType', 'DBName', 'VpcId', 'OwnerAccount'
              @snapshot[name] = value
            when 'SnapshotCreateTime', 'ClusterCreateTime'
              @snapshot[name] = Time.parse(value)              
            when 'Port', 'NumberOfNodes', 'EstimatedSecondsToCompletion', 'ElapsedTimeInSeconds'
              @snapshot[name] = value.to_i
            when 'Encrypted'
              @snapshot[name] = value == true
            when 'AccountId'
              @snapshot['AccountsWithRestoreAccess'] << value
            when 'CurrentBackupRateInMegaBytesPerSecond', 'BackupProgressInMegaBytes', 'ActualIncrementalBackupSizeInMegaBytes',
              'TotalBackupSizeInMegaBytes'
              @snapshot[name] = value.to_f
            when 'Snapshot'
              @response['Snapshots'] << @snapshot
              @snapshot = fresh_snapshot
            end
          end
        end
      end
    end
  end
end