module Fog
  module AWS
    class EC2

      # Acquire an elastic IP address.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'publicIp'<~String> - The acquired address
      #     * 'requestId'<~String> - Id of the request
      def allocate_address
        request({
          'Action' => 'AllocateAddress'
        }, Fog::Parsers::AWS::EC2::AllocateAddress.new)
      end

    end
  end
end
