module Fog
  module Network
    class StormOnDemand
      class Real
        def list_rulesets(options={})
          request(
            :path => '/Network/Firewall/Ruleset/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
