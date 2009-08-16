unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Delete an EBS volume
        #
        # ==== Parameters
        # * volume_id<~String> - Id of volume to delete.
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def delete_volume(volume_id)
          request({
            'Action' => 'DeleteVolume',
            'VolumeId' => volume_id
          }, Fog::Parsers::AWS::EC2::Basic.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def delete_volume(volume_id)
          response = Fog::Response.new
          if volume = @data[:volumes][volume_id]
            @data[:deleted_at][volume['volumeId']] = Time.now
            volume['status'] = 'deleting'
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return' => true
            }
          else
            response.status = 400
          end
          response
        end

      end
    end
  end

end
