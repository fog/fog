require 'fog/core'

module Fog
  module Cloudkick

    extend Fog::Provider

    service(:monitoring, 'cloudkick/monitoring')

  end
end

