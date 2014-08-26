module Fog
  module Compute
    class Cloudstack

      class Real
        # Copies a template from one zone to another.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/copyTemplate.html]
        def copy_template(options={})
          request(options)
        end


        def copy_template(id, destzoneid, options={})
          options.merge!(
            'command' => 'copyTemplate', 
            'id' => id, 
            'destzoneid' => destzoneid  
          )
          request(options)
        end
      end

    end
  end
end

