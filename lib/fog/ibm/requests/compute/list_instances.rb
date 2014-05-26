module Fog
  module Compute
    class IBM
      class Real
        # Returns list of instances that the authenticated user manages.
        #
        # ==== Parameters
        # No parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'instances'<~Array>: list of instances
        #       * 'name'<~String>: instance name
        #       * 'location'<~String>: instance location id
        #       * 'keyName'<~String>: instance assigned keypair
        #       * 'primaryIP'<~Hash>: assigned ip address, type, and hostname
        #       * 'productCodes'<~Array>: associated product codes
        #       * 'requestId'<~String>:
        #       * 'imageId'<~String>:
        #       * 'launchTime'<~Integer>: UNIX time integer representing when the instance was launched
        #       * 'id'<~String>: instance id
        #       * 'volumes'<~Array>:
        #       * 'isMiniEphemeral'<~Boolean>: minimal local storage
        #       * 'instanceType'<~String>: instance type
        #       * 'diskSize'<~String>: instance disk size
        #       * 'requestName'<~String>: instance request name
        #       * 'secondaryIP'<~Array>: additional IP Addresses associated with this instance
        #       * 'status'<~Integer>: instance status flag
        #       * 'software'<~Array>: Software associated with this instance
        #         * 'application'<~Hash>: Application name, type, and version (primarily OS information)
        #       * 'expirationTime'<~Integer>: UNIX timestamp representing when the instance expires
        #       * 'owner'<~String>: instance owner
        def list_instances
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/instances'
          )
        end
      end

      class Mock
        def list_instances
          response = Excon::Response.new
          response.status = 200
          response.body = { 'instances' => self.data[:instances].values }
          response
        end
      end
    end
  end
end
