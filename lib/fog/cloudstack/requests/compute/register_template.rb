module Fog
  module Compute
    class Cloudstack

      class Real
        # Registers an existing template into the CloudStack cloud. 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/registerTemplate.html]
        def register_template(options={})
          request(options)
        end


        def register_template(zoneid, format, hypervisor, url, name, ostypeid, displaytext, options={})
          options.merge!(
            'command' => 'registerTemplate', 
            'zoneid' => zoneid, 
            'format' => format, 
            'hypervisor' => hypervisor, 
            'url' => url, 
            'name' => name, 
            'ostypeid' => ostypeid, 
            'displaytext' => displaytext  
          )
          request(options)
        end
      end
 
      class Mock
        def register_template(options={})
          mock_template_id = self.data[:images].keys.first
          registered_template = self.data[:images][mock_template_id]

          {
              'registertemplateresponse' =>
              {
                  'count' => 1,
                  'template' => [registered_template]
              }
          }
        end
      end 
    end
  end
end

