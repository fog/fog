class BareMetalCloud < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::BareMetalCloud
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("BareMetalCloud[:compute] is not recommended, use Compute[:baremetalcloud] for portability")
          Fog::Compute.new(:provider => 'BareMetalCloud')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::BareMetalCloud.services
    end
  end
end
