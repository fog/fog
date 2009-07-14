module Fog
  module AWS
    class EC2

      # Create a snapshot of an EBS volume and store it in S3
      #
      # ==== Parameters
      # * volume_id<~String> - Id of EBS volume to snapshot
      #
      # ==== Returns
      # FIXME: docs
      def create_snapshot(volume_id)
        request({
          'Action' => 'CreateSnapshot',
          'VolumeId' => 'VolumeId'
        }, Fog::Parsers::AWS::EC2::CreateSnapshot.new)
      end

    end
  end
end
