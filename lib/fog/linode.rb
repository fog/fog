require File.join(File.dirname(__FILE__), 'core')

module Fog
  module Linode

    extend Fog::Provider

    service(:compute, 'linode/compute')
    service(:dns,     'linode/dns')

    def self.new(attributes = {})
      location = caller.first
      warning = "[yellow][WARN] Fog::Linode#new is deprecated, use Fog::Linode::Compute#new instead[/]"
      warning << " [light_black](" << location << ")[/] "
      Formatador.display_line(warning)
      Fog::Linode::Compute.new(attributes)
    end

  end
end

