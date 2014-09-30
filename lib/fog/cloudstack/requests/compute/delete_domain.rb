module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a specified domain
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteDomain.html]
        def delete_domain(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteDomain') 
          else
            options.merge!('command' => 'deleteDomain', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

