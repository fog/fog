require 'nokogiri'

require 'fog/core'
require 'fog/core/parser'

module Fog
  module Slicehost

    extend Fog::Provider

    service(:compute, 'compute/slicehost')
    service(:dns,     'dns/slicehost')

  end
end
