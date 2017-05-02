class CloudAtCost < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::CloudAtCost
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'CloudAtCost')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::CloudAtCost.services
    end
  end
end
