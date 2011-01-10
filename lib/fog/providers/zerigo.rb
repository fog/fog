require 'nokogiri'

require 'fog/core'
require 'fog/core/parser'

module Fog
  module Zerigo

    extend Fog::Provider

    service(:dns, 'dns/zerigo')

  end
end
