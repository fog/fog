class Local < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :files, :storage
        Fog::Local::Storage
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        if key == :files
          location = caller.first
          warning = "[yellow][WARN] Local[:files] is deprecated, use Local[:storage] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
        end
        hash[key] = class_for(key).new
      end
      @@connections[service]
    end

    def services
      [:storage]
    end

  end
end
