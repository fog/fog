require 'nokogiri'

require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))
require 'fog/core/parser'

module Fog
  module Dynect

    extend Fog::Provider

    service(:dns, 'dynect/dns')

  end
end
