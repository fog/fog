module Fog
  module Compute
    class Cloudstack

      class Real
        # List LUN
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listLunsOnFiler.html]
        def list_luns_on_filer(options={})
          options.merge!(
            'command' => 'listLunsOnFiler', 
            'poolname' => options['poolname']  
          )
          request(options)
        end
      end

    end
  end
end

