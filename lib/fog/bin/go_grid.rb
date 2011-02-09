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
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'GoGrid')
        when :servers
          location = caller.first
          warning = "[yellow][WARN] GoGrid[:servers] is deprecated, use GoGrid[:compute] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
          Fog::Compute.new(:provider => 'GoGrid')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::GoGrid.services
    end

  end
end
