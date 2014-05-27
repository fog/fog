module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all supported OS types for this cloud.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listOsTypes.html]
        def list_os_types(options={})
          options.merge!(
            'command' => 'listOsTypes'  
          )
          request(options)
        end
      end
 
      class Mock
        # TODO: add id, category_id filters and paging params
        def list_os_types(options={})
          os_types = self.data[:os_types]
          { "listostypesresponse" => { "count"=> os_types.count, "ostype"=> os_types.values } }
        end

      end 
    end
  end
end

