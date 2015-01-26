module Fog
  module Compute
    class IBM
      class Real
        # Deletes the Instance that the authenticated user manages with the specified :instance_id
        #
        # ==== Parameters
        # * instance_id<~String> - Id of instance
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     *'success'<~Bool>: true or false for success
        def delete_instance(instance_id)
          request(
            :method   => 'DELETE',
            :expects  => 200,
            :path     => "/instances/#{instance_id}"
          )
        end
      end

      class Mock
        def delete_instance(instance_id)
          response = Excon::Response.new
          if deleteable? instance_id
            # remove from memoreeeez.
            self.data[:instances].delete instance_id
            response.body = { 'success' => true }
            response.status = 200
          else
            # TODO: we should really return a 412 if the instance is in an invalid state, and a 404 if it doesn't exist.
            response.status = 404
          end
          response
        end

        # we can't delete the instance if it doesn't exist, or is in an invalid state.
        def deleteable?(instance_id)
          return false unless instance_exists? instance_id
          instance = self.data[:instances][instance_id]
          return false if [0, 1, 7, 14, 15].include?(instance["status"].to_i)
          true
        end
      end
    end
  end
end
