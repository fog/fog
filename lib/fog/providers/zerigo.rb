require 'fog/core'

module Fog
  module Zerigo

    extend Fog::Provider

    service(:dns, 'dns/zerigo')

  end
end
