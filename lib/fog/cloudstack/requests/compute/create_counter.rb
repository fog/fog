module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds metric counter
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createCounter.html]
        def create_counter(source, value, name, options={})
          options.merge!(
            'command' => 'createCounter', 
            'source' => source, 
            'value' => value, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

