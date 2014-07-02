module Fog
  module Compute
    class Cloudstack

      class Real
        # List Swift.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listSwifts.html]
        def list_swifts(options={})
          options.merge!(
            'command' => 'listSwifts'  
          )
          request(options)
        end
      end

    end
  end
end

