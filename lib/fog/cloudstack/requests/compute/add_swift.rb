module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds Swift.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addSwift.html]
        def add_swift(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addSwift') 
          else
            options.merge!('command' => 'addSwift', 
            'url' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

