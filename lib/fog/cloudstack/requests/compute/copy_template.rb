module Fog
  module Compute
    class Cloudstack

      class Real
        # Copies a template from one zone to another.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/copyTemplate.html]
        def copy_template(destzoneid, id, sourcezoneid, options={})
          options.merge!(
            'command' => 'copyTemplate', 
            'destzoneid' => destzoneid, 
            'id' => id, 
            'sourcezoneid' => sourcezoneid  
          )
          request(options)
        end
      end

    end
  end
end

