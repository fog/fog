module Fog
  module Compute
    class Cloudstack
      class Real

        def list_hypervisors(options={})
          options.merge!(
            'command' => 'listHypervisors'
          )
          
          request(options)
        end

      end
    end
  end
end
