module Fog
  module AWS
    module EC2
      class Real

        # Delete an EBS volume
        #
        # ==== Parameters
        # * volume_id<~String> - Id of volume to delete.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def delete_volume(volume_id)
          request(
            'Action'    => 'DeleteVolume',
            'VolumeId'  => volume_id,
            :idempotent => true,
            :parser     => Fog::Parsers::AWS::EC2::Basic.new
          )
        end

      end

      class Mock

        def delete_volume(volume_id)
          response = Excon::Response.new
          if volume = @data[:volumes][volume_id]
            @data[:deleted_at][volume_id] = Time.now
            volume['status'] = 'deleting'
            response.status = 200
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
