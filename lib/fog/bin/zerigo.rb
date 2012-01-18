class Zerigo < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :dns
        Fog::DNS::Zerigo
      else 
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :dns
          Fog::Logger.warning("Zerigo[:dns] is not recommended, use DNS[:zerigo] for portability")
          Fog::DNS.new(:provider => 'Zerigo')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Zerigo.services
    end

  end
end
