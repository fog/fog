module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds metric counter
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createCounter.html]
        def create_counter(options={})
          request(options)
        end


        def create_counter(name, value, source, options={})
          options.merge!(
            'command' => 'createCounter', 
            'name' => name, 
            'value' => value, 
            'source' => source  
          )
          request(options)
        end
      end

    end
  end
end

