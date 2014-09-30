module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a domain with a new name
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateDomain.html]
        def update_domain(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateDomain') 
          else
            options.merge!('command' => 'updateDomain', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

