module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds stratosphere ssp server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addStratosphereSsp.html]
        def add_stratosphere_ssp(options={})
          request(options)
        end


        def add_stratosphere_ssp(url, zoneid, name, options={})
          options.merge!(
            'command' => 'addStratosphereSsp', 
            'url' => url, 
            'zoneid' => zoneid, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

