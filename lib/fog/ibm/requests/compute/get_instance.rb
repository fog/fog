module Fog
  module Compute
    class IBM
      class Real

        # Get an instance
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
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
            response.status = 404
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
