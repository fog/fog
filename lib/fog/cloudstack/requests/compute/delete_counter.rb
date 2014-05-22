module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a counter
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteCounter.html]
        def delete_counter(options={})
          options.merge!(
            'command' => 'deleteCounter',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

