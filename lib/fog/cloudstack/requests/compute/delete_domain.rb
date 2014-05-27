module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a specified domain
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteDomain.html]
        def delete_domain(options={})
          options.merge!(
            'command' => 'deleteDomain', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

