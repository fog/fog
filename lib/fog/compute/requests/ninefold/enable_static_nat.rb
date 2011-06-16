module Fog
  module Compute
    class Ninefold
      class Real

        def enable_static_nat(options = {})
          request('enableStaticNat', options, :expects => [200],
                  :response_prefix => 'enablestaticnatresponse', :response_type => Hash)
        end

      end
    end
  end
end
