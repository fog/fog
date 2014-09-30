module Fog
  module Compute
    class Cloudstack

      class Real
        # List hypervisors
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listHypervisors.html]
        def list_hypervisors(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listHypervisors') 
          else
            options.merge!('command' => 'listHypervisors')
          end
          request(options)
        end
      end

    end
  end
end

