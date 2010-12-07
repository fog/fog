class Linode < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute, :linode
        Fog::Linode::Compute
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        if key == :linode
          location = caller.first
          warning = "[yellow][WARN] Linode[:linode] is deprecated, use Linode[:compute] instead[/]"
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
