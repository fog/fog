require 'fog/core'

module Fog
  module Vcloud

    extend Fog::Provider

    service(:compute, 'vcloud_director/compute', 'Compute')

  end
end