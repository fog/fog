module Fog
  module Compute
    class Cloudstack

      class Real
        # create a profile of template and associate to a blade
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/instantiateUcsTemplateAndAssocaciateToBlade.html]
        def instantiate_ucs_template_and_assocaciate_to_blade(options={})
          options.merge!(
            'command' => 'instantiateUcsTemplateAndAssocaciateToBlade', 
            'templatedn' => options['templatedn'], 
            'ucsmanagerid' => options['ucsmanagerid'], 
            'bladeid' => options['bladeid']  
          )
          request(options)
        end
      end

    end
  end
end

