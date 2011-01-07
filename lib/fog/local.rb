require File.join(File.dirname(__FILE__), 'core')

module Fog
  module Local

    extend Fog::Provider

    service(:storage, 'storage/local')

    def self.new(attributes = {})
      location = caller.first
      warning = "[yellow][WARN] Fog::Local#new is deprecated, use Fog::Local::Storage#new instead[/]"
      warning << " [light_black](" << location << ")[/] "
      Formatador.display_line(warning)
      Fog::Local::Storage.new(attributes)
    end

  end
end
