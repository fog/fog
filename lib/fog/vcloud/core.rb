require 'fog/core'
require 'fog/xml'

module Fog
  module Vcloud
    extend Fog::Provider

    service(:compute, 'Compute')
  end
end
