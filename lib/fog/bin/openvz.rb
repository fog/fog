class Openvz < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::Openvz
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Openvz[:compute] is not recommended, use Compute[:openvz] for portability")
          Fog::Compute.new(:provider => 'Openvz')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Openvz.services
    end
  end
end
