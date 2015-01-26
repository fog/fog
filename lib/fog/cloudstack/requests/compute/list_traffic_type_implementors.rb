module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists implementors of implementor of a network traffic type or implementors of all network traffic types
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listTrafficTypeImplementors.html]
        def list_traffic_type_implementors(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listTrafficTypeImplementors') 
          else
            options.merge!('command' => 'listTrafficTypeImplementors')
          end
          request(options)
        end
      end

    end
  end
end

