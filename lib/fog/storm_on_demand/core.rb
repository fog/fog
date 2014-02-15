require 'fog/core'

module Fog
  module StormOnDemand

    extend Fog::Provider

    service(:compute, 'Compute')
    service(:network, 'Network')
    service(:storage, 'Storage')
    service(:dns, 'DNS')
    service(:billing, 'Billing')
    service(:monitoring, 'Monitoring')
    service(:support, 'Support')
    service(:account, 'Account')
    service(:vpn, 'VPN')
    
  end
end

