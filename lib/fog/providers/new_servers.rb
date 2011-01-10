require 'nokogiri'

require 'fog/core'
require 'fog/core/parser'

module Fog
  module NewServers

    extend Fog::Provider

    service(:compute, 'compute/new_servers')

    def self.new(attributes = {})
      location = caller.first
      warning = "[yellow][WARN] Fog::NewServers#new is deprecated, use Fog::NewServers::Compute#new instead[/]"
      warning << " [light_black](" << location << ")[/] "
      Formatador.display_line(warning)
      Fog::NewServers::Compute.new(attributes)
    end

  end
end
