module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Ucs manager
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addUcsManager.html]
        def add_ucs_manager(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addUcsManager') 
          else
            options.merge!('command' => 'addUcsManager', 
            'url' => args[0], 
            'password' => args[1], 
            'username' => args[2], 
            'zoneid' => args[3])
          end
          request(options)
        end
      end

    end
  end
end

