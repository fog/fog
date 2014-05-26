module Fog
  module Network
    class StormOnDemand
      class Real
        def update_ruleset(options={})
          request(
            :path => '/Network/Firewall/Ruleset/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
