class Slicehost < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::Slicehost
      when :dns
        Fog::DNS::Slicehost
      else 
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Slicehost[:compute] is not recommended, use Compute[:slicehost] for portability")
          Fog::Compute.new(:provider => 'Slicehost')
        when :dns
          Fog::Logger.warning("Slicehost[:dns] is deprecated, use Storage[:slicehost] instead")
          Fog::DNS.new(:provider => 'Slicehost')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Slicehost.services
    end

  end
end
