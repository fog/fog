module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists Regions
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listRegions.html]
        def list_regions(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listRegions') 
          else
            options.merge!('command' => 'listRegions')
          end
          request(options)
        end
      end

    end
  end
end

