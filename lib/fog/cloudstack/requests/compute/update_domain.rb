module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a domain with a new name
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateDomain.html]
        def update_domain(id, options={})
          options.merge!(
            'command' => 'updateDomain', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

