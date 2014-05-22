module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateNetwork.html]
        def update_network(options={})
          options.merge!(
            'command' => 'updateNetwork',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

