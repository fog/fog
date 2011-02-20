require 'fog/core'

module Fog
  module Linode

    extend Fog::Provider

    service(:compute, 'compute/linode')
    service(:dns,     'dns/linode')

  end
end

