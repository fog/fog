class DigitalOcean < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::DigitalOceanV2
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("DigitalOcean[:compute] is not recommended, use Compute[:digitalocean] for portability")
          Fog::Compute.new(:provider => 'DigitalOcean')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::DigitalOcean.services
    end
  end
end
