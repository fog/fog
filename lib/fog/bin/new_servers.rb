class NewServers < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::NewServers
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("NewServers[:compute] is not recommended, use Compute[:newservers] for portability")
          Fog::Compute.new(:provider => 'NewServers')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::NewServers.services
    end

  end
end
