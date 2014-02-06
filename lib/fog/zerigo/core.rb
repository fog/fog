require 'fog/core'

module Fog
  module Zerigo

    extend Fog::Provider

    service(:dns, 'DNS')

  end
end
