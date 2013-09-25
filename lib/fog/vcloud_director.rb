require 'fog/core'

module Fog
  module VcloudDirector

    extend Fog::Provider

    service(:compute, 'vcloud_director/compute', 'Compute')

  end
end
