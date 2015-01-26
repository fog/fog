module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available ISO files.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listIsos.html]
        def list_isos(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listIsos') 
          else
            options.merge!('command' => 'listIsos')
          end
          request(options)
        end
      end

    end
  end
end

