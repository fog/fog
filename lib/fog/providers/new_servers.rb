require 'nokogiri'

require 'fog/core'
require 'fog/core/parser'

module Fog
  module NewServers

    extend Fog::Provider

    service(:compute, 'compute/new_servers')

  end
end
