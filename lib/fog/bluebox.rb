module Fog
  module Bluebox

    extend Fog::Provider

    service_path 'fog/bluebox'
    service :blocks

    def self.new(attributes = {})
      location = caller.first
      warning = "[yellow][WARN] Fog::Bluebox#new is deprecated, use Fog::Bluebox::Blocks#new instead[/]"
      warning << " [light_black](" << location << ")[/] "
      Formatador.display_line(warning)
      Fog::Bluebox::Blocks.new(attributes)
    end

  end
end
