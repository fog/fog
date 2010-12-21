class GoGrid < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute, :servers
        Fog::GoGrid::Compute
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        if key == :servers
          location = caller.first
          warning = "[yellow][WARN] GoGrid[:servers] is deprecated, use GoGrid[:compute] instead[/]"
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
