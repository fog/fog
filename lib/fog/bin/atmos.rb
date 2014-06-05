class Atmos < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :storage
        Fog::Storage::Atmos
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :storage
          Fog::Logger.warning("Atmos[:storage] is not recommended, use Storage[:atmos] for portability")
          Fog::Storage.new(:provider => 'Atmos')
        else
          raise ArgumentError, "Unrecognized service: #{service}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Atmos.services
    end
  end
end
