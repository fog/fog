module Fog
  module AWS
    module EC2
      class Real

        # Delete a snapshot of an EBS volume that you own
        #
        # ==== Parameters
        # * snapshot_id<~String> - ID of snapshot to delete
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def delete_snapshot(snapshot_id)
          request(
            'Action'      => 'DeleteSnapshot',
            'SnapshotId'  => snapshot_id,
            :parser       => Fog::Parsers::AWS::EC2::Basic.new
          )
        end

      end

      class Mock

        def delete_snapshot(snapshot_id)
          response = Excon::Response.new
          if snapshot = @data[:snapshots].delete(snapshot_id)
            response.status = true
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
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
