module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds stratosphere ssp server
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addStratosphereSsp.html]
        def add_stratosphere_ssp(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addStratosphereSsp') 
          else
            options.merge!('command' => 'addStratosphereSsp', 
            'url' => args[0], 
            'zoneid' => args[1], 
            'name' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

