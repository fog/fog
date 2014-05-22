module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds detail for the Resource.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addResourceDetail.html]
        def add_resource_detail(options={})
          options.merge!(
            'command' => 'addResourceDetail',
            'resourceid' => options['resourceid'], 
            'resourcetype' => options['resourcetype'], 
            'details' => options['details'], 
             
          )
          request(options)
        end
      end

    end
  end
end

