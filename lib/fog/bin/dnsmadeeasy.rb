class DNSMadeEasy < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :dns
        Fog::DNS::DNSMadeEasy
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :dns
          Fog::Logger.warning("DNSMadeEasy[:dns] is not recommended, use DNS[:dnsmadeeasy] for portability")
          Fog::DNS.new(:provider => 'DNSMadeEasy')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::DNSMadeEasy.services
    end
  end
end
