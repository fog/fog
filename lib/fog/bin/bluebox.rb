class Bluebox < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :blocks, :compute
        Fog::Bluebox::Compute
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :blocks
          location = caller.first
          warning = "[yellow][WARN] Bluebox[:blocks] is deprecated, use Bluebox[:compute] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
          Fog::Compute.new(:provider => 'Brightbox')
        when :compute
          Fog::Compute.new(:provider => 'Brightbox')
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
