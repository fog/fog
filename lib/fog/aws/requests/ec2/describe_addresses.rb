module Fog
  module AWS
    module EC2
      class Real

        require 'fog/aws/parsers/ec2/describe_addresses'

        # Describe all or specified IP addresses.
        #
        # ==== Parameters
        # * public_ip<~Array> - List of ips to describe, defaults to all
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'addressesSet'<~Array>:
        #       * 'instanceId'<~String> - instance for ip address
        #       * 'publicIp'<~String> - ip address for instance
        def describe_addresses(public_ip = [])
          params = AWS.indexed_param('PublicIp', public_ip)
          request({
            'Action'    => 'DescribeAddresses',
            :idempotent => true,
            :parser     => Fog::Parsers::AWS::EC2::DescribeAddresses.new
          }.merge!(params))
        end

      end

      class Mock

        def describe_addresses(public_ip = [])
          response = Excon::Response.new
          public_ip = [*public_ip]
          if public_ip != []
            addresses_set = @data[:addresses].reject {|key, value| !public_ip.include?(key)}.values
          else
            addresses_set = @data[:addresses].values
          end
          if public_ip.length == 0 || public_ip.length == addresses_set.length
            response.status = 200
            response.body = {
              'requestId'     => Fog::AWS::Mock.request_id,
              'addressesSet'  => addresses_set
            }
            response
          else
            raise Fog::AWS::EC2::NotFound.new("Address #{public_ip.inspect} not found.")
          end
        end

      end
    end
  end
end
