module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates an ISO file.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateIso.html]
        def update_iso(options={})
          options.merge!(
            'command' => 'updateIso', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

