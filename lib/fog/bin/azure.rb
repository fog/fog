class Azure < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::Azure
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Azure[:compute] is not recommended, use Compute[:azure] for portability")
          Fog::Compute.new(:provider => 'Azure')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Azure.services
    end
  end
end
