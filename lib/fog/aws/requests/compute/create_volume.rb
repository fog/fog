module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/create_volume'

        # Create an EBS volume
        #
        # ==== Parameters
        # * availability_zone<~String> - availability zone to create volume in
        # * size<~Integer> - Size in GiBs for volume.  Must be between 1 and 1024.
        # * options<~Hash>
        #   * 'SnapshotId'<~String> - Optional, snapshot to create volume from
        #   * 'VolumeType'<~String> - Optional, volume type. standard or io1, default is standard.
        #   * 'Iops'<~Integer> - Number of IOPS the volume supports. Required if VolumeType is io1, must be between 1 and 1000.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'availabilityZone'<~String> - Availability zone for volume
        #     * 'createTime'<~Time> - Timestamp for creation
        #     * 'size'<~Integer> - Size in GiBs for volume
        #     * 'snapshotId'<~String> - Snapshot volume was created from, if any
        #     * 'status's<~String> - State of volume
        #     * 'volumeId'<~String> - Reference to volume
        #     * 'volumeType'<~String> - Type of volume
        #     * 'iops'<~Integer> - Number of IOPS the volume supports
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-CreateVolume.html]
        def create_volume(availability_zone, size, options = {})
          unless options.is_a?(Hash)
            Fog::Logger.deprecation("create_volume with a bare snapshot_id is deprecated, use create_volume(availability_zone, size, 'SnapshotId' => snapshot_id) instead [light_black](#{caller.first})[/]")
            options = { 'SnapshotId' => options }
          end

          request({
            'Action'            => 'CreateVolume',
            'AvailabilityZone'  => availability_zone,
            'Size'              => size,
            :parser             => Fog::Parsers::Compute::AWS::CreateVolume.new
          }.merge(options))
        end

      end

      class Mock

        def create_volume(availability_zone, size, options = {})
          unless options.is_a?(Hash)
            Fog::Logger.deprecation("create_volume with a bare snapshot_id is deprecated, use create_volume(availability_zone, size, 'SnapshotId' => snapshot_id) instead [light_black](#{caller.first})[/]")
            options = { 'SnapshotId' => options }
          end

          response = Excon::Response.new
          if availability_zone && (size || options['SnapshotId'])
            snapshot = self.data[:snapshots][options['SnapshotId']]
            if options['SnapshotId'] && !snapshot
              raise Fog::Compute::AWS::NotFound.new("The snapshot '#{options['SnapshotId']}' does not exist.")
            end

            if snapshot && size && size < snapshot['volumeSize']
              raise Fog::Compute::AWS::NotFound.new("The snapshot '#{options['SnapshotId']}' has size #{snapshot['volumeSize']} which is greater than #{size}.")
            elsif snapshot && !size
              size = snapshot['volumeSize']
            end

            if options['VolumeType'] == 'io1'
              iops = options['Iops']
              if !iops
                raise Fog::Compute::AWS::Error.new("InvalidParameterCombination => The parameter iops must be specified for io1 volumes.")
              end

              if size < 10
                raise Fog::Compute::AWS::Error.new("InvalidParameterValue => Volume of #{size}GiB is too small; minimum is 10GiB.")
              end

              if (iops_to_size_ratio = iops.to_f / size.to_f) > 10.0
                raise Fog::Compute::AWS::Error.new("InvalidParameterValue => Iops to volume size ratio of #{"%.1f" % iops_to_size_ratio} is too high; maximum is 10.0")
              end

              if iops < 100
                raise Fog::Compute::AWS::Error.new("VolumeIOPSLimit => Volume iops of #{iops} is too low; minimum is 100.")
              end

              if iops > 2000
                raise Fog::Compute::AWS::Error.new("VolumeIOPSLimit => Volume iops of #{iops} is too high; maximum is 2000.")
              end
            end

            response.status = 200
            volume_id = Fog::AWS::Mock.volume_id
            data = {
              'availabilityZone'  => availability_zone,
              'attachmentSet'     => [],
              'createTime'        => Time.now,
              'iops'              => options['Iops'],
              'size'              => size,
              'snapshotId'        => options['SnapshotId'],
              'status'            => 'creating',
              'volumeId'          => volume_id,
              'volumeType'        => options['VolumeType'] || 'standard'
            }
            self.data[:volumes][volume_id] = data
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id
            }.merge!(data.reject {|key,value| !['availabilityZone','createTime','size','snapshotId','status','volumeId','volumeType'].include?(key) })
          else
            response.status = 400
            response.body = {
              'Code' => 'MissingParameter'
            }
            unless availability_zone
              response.body['Message'] = 'The request must contain the parameter availability_zone'
            else
              response.body['Message'] = 'The request must contain the parameter size'
            end
          end
          response
        end

      end
    end
  end
end
