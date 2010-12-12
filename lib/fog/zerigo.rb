require 'nokogiri'
require 'fog/core/parser'

module Fog
  module Zerigo

    extend Fog::Provider

    service_path 'fog/zerigo'
    service :compute

    def self.new(attributes = {})
      location = caller.first
      warning = "[yellow][WARN] Fog::Zerigo#new is deprecated, use Fog::Zerigo::Compute#new instead[/]"
      warning << " [light_black](" << location << ")[/] "
      Formatador.display_line(warning)
      Fog::Zerigo::Compute.new(attributes)
    end

  end
end
