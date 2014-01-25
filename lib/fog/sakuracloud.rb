require 'fog/core'

module Fog
  module SakuraCloud
    extend Fog::Provider

    SAKURACLOUD_API_VERSION = '1.1' unless defined? SAKURACLOUD_API_VERSION
    SAKURACLOUD_API_ZONE = "is1b" unless defined? SAKURACLOUD_API_ZONE
    SAKURACLOUD_API_ENDPOINT = "/cloud/zone/#{SAKURACLOUD_API_ZONE}/api/cloud/#{SAKURACLOUD_API_VERSION}/"

    service(:compute, 'sakuracloud/compute', 'Compute')
    service(:volume, 'sakuracloud/volume', 'Volume')

  end
end
