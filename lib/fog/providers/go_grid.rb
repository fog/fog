require File.join(File.dirname(__FILE__), '..', 'core')

module Fog
  module GoGrid

    extend Fog::Provider

    service(:compute, 'compute/go_grid')

    def self.new(attributes = {})
      location = caller.first
      warning = "[yellow][WARN] Fog::GoGrid#new is deprecated, use Fog::GoGrid::Compute#new instead[/]"
      warning << " [light_black](" << location << ")[/] "
      Formatador.display_line(warning)
      Fog::GoGrid::Compute.new(attributes)
    end

  end
end
