module Fog
  module AWS
    class EC2

      # Describe all or specified IP addresses.
      #
      # ==== Parameters
      # * public_ip<~Array> - List of ips to describe, defaults to all
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'requestId'<~String> - Id of request
      #     * 'addressesSet'<~Array>:
      #       * 'instanceId'<~String> - instance for ip address
      #       * 'publicIp'<~String> - ip address for instance
      def describe_addresses(public_ip = [])
        params = indexed_params('PublicIp', public_ip)
        request({
          'Action' => 'DescribeAddresses'
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeAddresses.new)
      end

    end
  end
end
