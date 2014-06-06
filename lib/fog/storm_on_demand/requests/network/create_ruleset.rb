module Fog
  module Network
    class StormOnDemand
      class Real
        def create_ruleset(options={})
          request(
            :path => '/Network/Firewall/Ruleset/create',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
