module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds Swift.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addSwift.html]
        def add_swift(url, options={})
          options.merge!(
            'command' => 'addSwift', 
            'url' => url  
          )
          request(options)
        end
      end

    end
  end
end

