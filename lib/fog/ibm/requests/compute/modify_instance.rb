module Fog
  module Compute
    class IBM
      class Real

        # Modify an instance
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def modify_instance(instance_id, params={})
          options = {
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/instances/#{instance_id}",
          }
          options.merge!(Fog::IBM.form_body(params))
          request(options)
        end

      end
    end
  end
end
