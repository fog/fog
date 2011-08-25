require 'fog/core'

module Fog
  module Brightbox
    extend Fog::Provider

    service(:compute, 'brightbox/compute')

  end
end
