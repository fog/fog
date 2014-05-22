module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an ISO file.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteIso.html]
        def delete_iso(options={})
          options.merge!(
            'command' => 'deleteIso',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

