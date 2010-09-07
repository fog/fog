module Fog
  module GoGrid

    extend Fog::Provider

    service_path 'fog/go_grid'
    service 'servers'

    def self.new(attributes = {})
      location = caller.first
      warning = "[yellow][WARN] Fog::GoGrid#new is deprecated, use Fog::GoGrid::Servers#new instead[/]"
      warning << " [light_black](" << location << ")[/] "
      Formatador.display_line(warning)
      Fog::Bluebox::Blocks.new(attributes)
    end

  end
end
