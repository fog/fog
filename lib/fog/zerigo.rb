require File.join(File.dirname(__FILE__), 'core')
require 'fog/core/parser'

module Fog
  module Zerigo

    extend Fog::Provider

    service_path 'fog/zerigo'
    service :compute

  end
end
