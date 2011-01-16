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
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'NewServers')
        when :new_servers
          location = caller.first
          warning = "[yellow][WARN] NewServers[:new_servers] is deprecated, use NewServers[:compute] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
          Fog::Compute.new(:provider => 'NewServers')
        else
          raise ArgumentError, "Unrecognized service: #{service}"
        end
      end
      @@connections[service]
    end

    def services
      [:compute]
    end

  end
end
