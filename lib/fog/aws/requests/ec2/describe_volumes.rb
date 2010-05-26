module Fog
  module AWS
    module EC2
      class Real

        # Describe all or specified volumes.
        #
        # ==== Parameters
        # * volume_id<~Array> - List of volumes to describe, defaults to all
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'volumeSet'<~Array>:
        #       * 'availabilityZone'<~String> - Availability zone for volume
        #       * 'createTime'<~Time> - Timestamp for creation
        #       * 'size'<~Integer> - Size in GiBs for volume
        #       * 'snapshotId'<~String> - Snapshot volume was created from, if any
        #       * 'status'<~String> - State of volume
        #       * 'volumeId'<~String> - Reference to volume
        #       * 'attachmentSet'<~Array>:
        #         * 'attachmentTime'<~Time> - Timestamp for attachment
        #         * 'device'<~String> - How value is exposed to instance
        #         * 'instanceId'<~String> - Reference to attached instance
        #         * 'status'<~String> - Attachment state
        #         * 'volumeId'<~String> - Reference to volume
        def describe_volumes(volume_id = [])
          params = AWS.indexed_param('VolumeId', volume_id)
          request({
            'Action'    => 'DescribeVolumes',
            :idempotent => true,
            :parser     => Fog::Parsers::AWS::EC2::DescribeVolumes.new
          }.merge!(params))
        end

      end

      class Mock

        def describe_volumes(volume_id = [])
          response = Excon::Response.new
          volume_id = [*volume_id]
          if volume_id != []
            volume_set = @data[:volumes].reject {|key,value| !volume_id.include?(key)}.values
          else
            volume_set = @data[:volumes].values
          end

          if volume_id.length == 0 || volume_id.length == volume_set.length
            volume_set.each do |volume|
              case volume['status']
              when 'attaching'
                if Time.now - volume['attachmentSet'].first['attachTime'] > Fog::Mock.delay
                  volume['attachmentSet'].first['status'] = 'in-use'
                  volume['status'] = 'in-use'
                end
              when 'creating'
                if Time.now - volume['createTime'] > Fog::Mock.delay
                  volume['status'] = 'available'
                end
              when 'deleting'
                if Time.now - @data[:deleted_at][volume['volumeId']] > Fog::Mock.delay
                  @data[:deleted_at].delete(volume['volumeId'])
                  @data[:volumes].delete(volume['volumeId'])
                end
              end
            end

            volume_set = volume_set.reject {|volume| !@data[:volumes][volume['volumeId']]}
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'volumeSet' => volume_set
            }
            response
          else
            raise Fog::AWS::EC2::Error.new("InvalidVolume.NotFound => The volume #{volume_id.inspect} does not exist.")
          end
        end

      end
    end
  end
end
