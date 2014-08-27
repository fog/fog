module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a Pod.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/dedicatePod.html]
        def dedicate_pod(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'dedicatePod') 
          else
            options.merge!('command' => 'dedicatePod', 
            'podid' => args[0], 
            'domainid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

