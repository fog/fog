unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Delete a snapshot of an EBS volume that you own
        #
        # ==== Parameters
        # * snapshot_id<~String> - ID of snapshot to delete
        # ==== Returns
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def delete_snapshot(snapshot_id)
          request({
            'Action' => 'DeleteSnapshot',
            'SnapshotId' => snapshot_id
          }, Fog::Parsers::AWS::EC2::Basic.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def delete_snapshot(snapshot_id)
          response = Fog::Response.new
          if snapshot = Fog::AWS::EC2.data[:snapshots].delete(snapshot_id)
            response.status = true
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
            }
          else
            response.status = 400
            raise(Fog::Errors.status_error(200, 400, response))
          end
          response
        end

      end
    end
  end

end
