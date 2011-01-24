require 'nokogiri'

require File.join(File.dirname(__FILE__), '..', 'core')
require 'fog/core/parser'

module Fog
  module TerremarkEcloud

    extend Fog::Provider

    service(:compute, 'compute/terremark_ecloud')

    class Mock

    end
  end
end
