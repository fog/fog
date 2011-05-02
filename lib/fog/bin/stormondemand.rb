class StormOnDemand < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::StormOnDemand::Compute
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'StormOnDemand')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::StormOnDemand.services
    end

  end
end