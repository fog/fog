module Fog
  module Compute
    class IBM
      class Real
        # Returns the Instance that the authenticated user manages with the specified :instance_id
        #
        # ==== Parameters
        # * instance_id<~String> - Id of instance
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'name'<~String>: instance name
        #     * 'location'<~String>: instance location id
        #     * 'keyName'<~String>: instance assigned keypair
        #     * 'primaryIP'<~Hash>: assigned ip address, type, and hostname
        #     * 'productCodes'<~Array>: associated product codes
        #     * 'requestId'<~String>:
        #     * 'imageId'<~String>:
        #     * 'launchTime'<~Integer>: UNIX time integer representing when the instance was launched
        #     * 'id'<~String>: instance id
        #     * 'volumes'<~Array>:
        #     * 'isMiniEphemeral'<~Boolean>: minimal local storage
        #     * 'instanceType'<~String>: instance type
        #     * 'diskSize'<~String>: instance disk size
        #     * 'requestName'<~String>: instance request name
        #     * 'secondaryIP'<~Array>: additional IP Addresses associated with this instance
        #     * 'status'<~Integer>: instance status flag
        #     * 'software'<~Array>: Software associated with this instance
        #       * 'application'<~Hash>: Application name, type, and version (primarily OS information)
        #     * 'expirationTime'<~Integer>: UNIX timestamp representing when the instance expires
        #     * 'owner'<~String>: instance owner
        def get_instance(instance_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/instances/#{instance_id}"
          )
        end
      end

      class Mock
        def get_instance(instance_id)
          response = Excon::Response.new
          if instance_exists? instance_id
            activate_instance(instance_id) # Set it to Active if it's not running
            response.status = 200
            response.body   = self.data[:instances][instance_id]
          else
            raise Fog::Compute::IBM::NotFound
          end
          response
        end

        # Checks if an instance exists
        def instance_exists?(instance_id)
          self.data[:instances].key? instance_id
        end

        # Sets instance status to Active if it's not already set.
        def activate_instance(instance_id)
          self.data[:instances][instance_id]["status"] = 5 unless instance_active? instance_id
        end

        # Checks if an instance is Active
        def instance_active?(instance_id)
          self.data[:instances][instance_id]["status"] == 5
        end
      end
    end
  end
end
