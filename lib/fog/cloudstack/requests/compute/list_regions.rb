module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists Regions
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listRegions.html]
        def list_regions(options={})
          options.merge!(
            'command' => 'listRegions'  
          )
          request(options)
        end
      end

    end
  end
end

