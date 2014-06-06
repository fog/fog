module Fog
  module Compute
    class Cloudstack

      class Real
        # load template into primary storage
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/prepareTemplate.html]
        def prepare_template(templateid, zoneid, options={})
          options.merge!(
            'command' => 'prepareTemplate', 
            'templateid' => templateid, 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

