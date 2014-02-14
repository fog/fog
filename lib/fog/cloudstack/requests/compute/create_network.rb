  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a network
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createNetwork.html]
          def create_network(options={})
            options.merge!(
              'command' => 'createNetwork'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
