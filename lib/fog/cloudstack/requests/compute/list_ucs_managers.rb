module Fog
  module Compute
    class Cloudstack

      class Real
        # List ucs manager
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listUcsManagers.html]
        def list_ucs_managers(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listUcsManagers') 
          else
            options.merge!('command' => 'listUcsManagers')
          end
          request(options)
        end
      end

    end
  end
end

