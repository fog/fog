module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all available ISO files.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listIsos.html]
        def list_isos(options={})
          options.merge!(
            'command' => 'listIsos'
          )
          
          request(options)
        end

      end
    end
  end
end
