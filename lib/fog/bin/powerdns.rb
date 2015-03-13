class PowerDNS < Fog::Bin
  class << self
    def class_for(key)
      case key

        when :dns
          Fog::DNS::PowerDNS
        else
          raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end
    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :dns
          Fog::Logger.warning("PowerDNS[:dns] is not recommended, use DNS[:powerdns] for portability")
          Fog::DNS.new(:provider => :powerdns)
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end
    def services
      Fog::PowerDNS.services
    end
  end
end