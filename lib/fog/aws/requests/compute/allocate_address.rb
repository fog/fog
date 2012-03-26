module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/allocate_address'

        # Acquire an elastic IP address.
        #
        # ==== Parameters
        # * domain<~String> - Type of EIP, either standard or vpc
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'publicIp'<~String> - The acquired address
        #     * 'requestId'<~String> - Id of the request
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-AllocateAddress.html]
        def allocate_address(domain='standard')
          domain = domain == 'vpc' ? 'vpc' : 'standard'
          request(
            'Action'  => 'AllocateAddress',
            'Domain'  => domain,
            :parser   => Fog::Parsers::Compute::AWS::AllocateAddress.new
          )
        end

      end

      class Mock

        def allocate_address(domain = 'standard')
          domain = domain == 'vpc' ? 'vpc' : 'standard'
          response = Excon::Response.new
          if describe_addresses.body['addressesSet'].size < self.data[:limits][:addresses]
            response.status = 200
            public_ip = Fog::AWS::Mock.ip_address
            data = {
              'instanceId' => nil,
              'publicIp'   => public_ip,
              'domain'     => domain
            }
            self.data[:addresses][public_ip] = data
            response.body = {
              'domain'    => domain,
              'publicIp'  => public_ip,
              'requestId' => Fog::AWS::Mock.request_id
            }
            response
          else
            response.status = 400
            response.body = "<?xml version=\"1.0\"?><Response><Errors><Error><Code>AddressLimitExceeded</Code><Message>Too many addresses allocated</Message></Error></Errors><RequestID>#{Fog::AWS::Mock.request_id}</RequestID></Response>"
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
        end

      end
    end
  end
end
