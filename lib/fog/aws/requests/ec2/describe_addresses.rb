unless Fog.mocking?

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

else

  module Fog
    module AWS
      class EC2

        def describe_addresses(public_ip = [])
          response = Fog::Response.new
          public_ip = [*public_ip]
          if public_ip != []
            addresses_set = Fog::AWS::EC2.data[:addresses].reject {|key, value| !public_ip.include?(key)}.values
          else
            addresses_set = Fog::AWS::EC2.data[:addresses].values
          end
          if public_ip.length == 0 || public_ip.length == addresses_set.length
            response.status = 200
            response.body = {
              'requestId'     => Fog::AWS::Mock.request_id,
              'addressesSet'  => addresses_set
            }
          else
            response.status = 400
            raise(Fog::Errors.status_error(200, 400, response))
          end
          response
        end

      end
    end
  end

end
