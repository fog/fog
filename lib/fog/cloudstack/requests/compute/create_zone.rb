module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createZone.html]
        def create_zone(options={})
          options.merge!(
            'command' => 'createZone', 
            'name' => options['name'], 
            'dns1' => options['dns1'], 
            'internaldns1' => options['internaldns1'], 
            'networktype' => options['networktype']  
          )
          request(options)
        end
      end

    end
  end
end

