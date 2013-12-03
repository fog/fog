module Fog
  module Network
    class StormOnDemand
      class Real

        def get_ruleset(options={})
          request(
            :path => '/Network/Firewall/Ruleset/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
