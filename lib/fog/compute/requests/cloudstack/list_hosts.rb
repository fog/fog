module Fog
  module Compute
    class Cloudstack
      class Real

        def list_hosts(options={})
          options.merge!(
            'command' => 'listHosts'
          )
          
          request(options)
        end

      end
    end
  end
end
