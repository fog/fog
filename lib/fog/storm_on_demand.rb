require 'fog/core'

module Fog
  module StormOnDemand

    extend Fog::Provider

    service(:compute, 'storm_on_demand/compute', 'Compute')
    service(:network, 'storm_on_demand/network', 'Network')
    service(:storage, 'storm_on_demand/storage', 'Storage')
    service(:dns, 'storm_on_demand/dns', 'DNS')
    service(:billing, 'storm_on_demand/billing', 'Billing')
    service(:monitoring, 'storm_on_demand/monitoring', 'Monitoring')
    service(:support, 'storm_on_demand/support', 'Support')
    service(:account, 'storm_on_demand/account', 'Account')
    service(:vpn, 'storm_on_demand/vpn', 'VPN')
    
  end
end

