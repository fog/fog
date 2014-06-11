class SakuraCloud < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::SakuraCloud
      when :volume
        Fog::Volume::SakuraCloud
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("SakuraCloud[:compute] is not recommended, use Compute[:sakuracloud] for portability")
          Fog::Compute.new(:provider => 'SakuraCloud')
        when :volume
          Fog::Logger.warning("SakuraCloud[:compute] is not recommended, use Compute[:SakuraCloud] for portability")
          Fog::Compute.new(:provider => 'SakuraCloud')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::SakuraCloud.services
    end
  end
end
