class Slicehost < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute, :slices
        Fog::Slicehost::Compute
      when :dns
        Fog::Slicehost::DNS
      else 
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        if key == :slices
          location = caller.first
          warning = "[yellow][WARN] Slicehost[:blocks] is deprecated, use Bluebox[:compute] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
        end
        hash[key] = case key
        when :compute, :slices
          Fog::Compute.new(:provider => 'Slicehost')
        when :dns
          Fog::DNS.new(:provider => 'Slicehost')
        else
          raise ArgumentError, "Unrecognized service: #{service}"
        end
      end
      @@connections[service]
    end

    def services
      [:compute, :dns]
    end

  end
end
