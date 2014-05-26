class Dreamhost < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :dns
        Fog::DNS::Dreamhost
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :dns
          Fog::Logger.warning("Dreamhost[:dns] is not recommended, use DNS[:dreamhost] for portability")
          Fog::DNS.new(:provider => 'Dreamhost')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Dreamhost.services
    end
  end
end
