require 'fog/core'

module Fog
  module Ecloud

    extend Fog::Provider

    service(:compute, 'ecloud/compute')

  end
end
