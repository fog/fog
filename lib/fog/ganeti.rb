module Fog
  module Ganeti

    extend Fog::Provider

    service_path 'fog/ganeti'
    service 'compute'

    def self.new(attributes = {})
      location = caller.first
      warning = "[yellow][WARN] Fog::Ganeti#new is deprecated, use Fog::Ganeti::Compute#new instead[/]"
      warning << " [light_black](" << location << ")[/] "
      Formatador.display_line(warning)
      Fog::Ganeti::Compute.new(attributes)
    end

  end
end

