module Fog
  module Compute
    class Cloudstack
      class Real

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
