class Rage4 < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :dns
        Fog::DNS::Rage4
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :dns
          Fog::Logger.warning("Rage4[:dns] is not recommended, use DNS[:rage4] for portability")
          Fog::DNS.new(:provider => 'Rage4')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Rage4.services
    end
  end
end
