require 'fog/core'

module Fog
  module Vcloud

    extend Fog::Provider

    service(:compute, 'vcloudng/compute', 'Compute')

  end
end