module Fog
  module Ninefold
    class Compute
      class Real

        def disable_static_nat(options = {})
          request('disableStaticNat', options, :expects => [200],
                  :response_prefix => 'disablestaticnatresponse', :response_type => Hash)
        end

      end
    end
  end
end
