require 'nokogiri'

require 'fog/core'
require 'fog/core/parser'

module Fog
  module Dynect

    extend Fog::Provider

    service(:dns, 'dns/dynect')

  end
end
