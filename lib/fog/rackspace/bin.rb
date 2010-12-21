class Rackspace < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :cdn
        Fog::Rackspace::CDN
      when :compute, :servers
        Fog::Rackspace::Compute
      when :files, :storage
        Fog::Rackspace::Storage
      else 
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        klazz = class_for(key)
        hash[key] = case key
        when :files
          location = caller.first
          warning = "[yellow][WARN] Rackspace[:files] is deprecated, use Rackspace[:storage] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
          klazz.new
        when :servers
          location = caller.first
          warning = "[yellow][WARN] Rackspace[:servers] is deprecated, use Rackspace[:compute] instead[/]"
          warning << " [light_black](" << location << ")[/] "
          Formatador.display_line(warning)
          klazz.new
        else
          klazz.new
        end
      end
      @@connections[service]
    end

    def services
      [:cdn, :compute, :storage]
    end

  end
end
