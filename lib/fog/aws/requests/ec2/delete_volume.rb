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
      #     * :request_id<~String> - Id of request
      #     * :return<~Boolean> - success?
      def delete_volume(volume_id)
        request({
          'Action' => 'DeleteVolume',
          'VolumeId' => volume_id
        }, Fog::Parsers::AWS::EC2::Basic.new)
      end

    end
  end
end
