class NewServers < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute, :new_servers
        Fog::NewServers::Compute
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        if key == :new_servers
          location = caller.first
          warning = "[yellow][WARN] NewServers[:servers] is deprecated, use NewServers[:compute] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
        end
        hash[key] = class_for(key).new
      end
      @@connections[service]
    end

    def services
      [:compute]
    end

  end
end
