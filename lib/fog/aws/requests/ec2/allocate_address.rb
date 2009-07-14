module Fog
  module AWS
    class EC2

      # Acquire an elastic IP address.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :public_ip<~String> - The acquired address
      def allocate_address
        request({
          'Action' => 'AllocateAddress'
        }, Fog::Parsers::AWS::EC2::AllocateAddress.new)
      end

    end
  end
end
