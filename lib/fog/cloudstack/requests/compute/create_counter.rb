module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds metric counter
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createCounter.html]
        def create_counter(options={})
          options.merge!(
            'command' => 'createCounter', 
            'name' => options['name'], 
            'source' => options['source'], 
            'value' => options['value']  
          )
          request(options)
        end
      end

    end
  end
end

