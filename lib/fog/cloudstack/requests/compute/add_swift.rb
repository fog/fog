  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Adds Swift.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/addSwift.html]
          def add_swift(options={})
            options.merge!(
              'command' => 'addSwift'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
