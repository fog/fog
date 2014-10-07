module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a domain
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createDomain.html]
        def create_domain(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createDomain') 
          else
            options.merge!('command' => 'createDomain', 
            'name' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

