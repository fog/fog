unless Fog.mocking?

  module Fog
    module AWS
      class EC2
      
        # Describe all or specified snapshots
        #
        # ==== Parameters
        # * snapshot_id<~Array> - List of snapshots to describe, defaults to all
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'snapshotSet'<~Array>:
        #       * 'progress'<~String>: The percentage progress of the snapshot
        #       * 'snapshotId'<~String>: Id of the snapshot
        #       * 'startTime'<~Time>: Timestamp of when snapshot was initiated
        #       * 'status'<~String>: Snapshot state, in ['pending', 'completed']
        #       * 'volumeId'<~String>: Id of volume that snapshot contains
        def describe_snapshots(snapshot_id = [])
          params = AWS.indexed_param('SnapshotId', snapshot_id)
          request({
            'Action'  => 'DescribeSnapshots',
            :parser   => Fog::Parsers::AWS::EC2::DescribeSnapshots.new
          }.merge!(params))
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def describe_snapshots(snapshot_id = [])
          response = Excon::Response.new
          snapshot_id = [*snapshot_id]
          if snapshot_id != []
            snapshot_set = Fog::AWS::EC2.data[:snapshots].reject {|key,value| !snapshot_id.include?(key)}.values
          else
            snapshot_set = Fog::AWS::EC2.data[:snapshots].values
          end

          snapshot_set.each do |snapshot|
            case snapshot['status']
            when 'creating'
              if Time.now - volume['createTime'] > 2
                snapshot['progress']  = '100%'
                snapshot['status']    = 'completed'
              else
                snapshot['progress']  = '50%'
                snapshot['status']    = 'in progress'
              end
            end
          end

          if snapshot_id.length == 0 || snapshot_id.length == snapshot_set.length
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'snapshotSet' => snapshot_set
            }
          else
            response.status = 400
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

      end
    end
  end

end
