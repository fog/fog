module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a domain
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createDomain.html]
        def create_domain(name, options={})
          options.merge!(
            'command' => 'createDomain', 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

