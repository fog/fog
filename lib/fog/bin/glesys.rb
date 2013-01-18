class Glesys < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::Glesys
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Glesys[:compute] is not recommended, use Compute[:glesys] for portability")
          Fog::Compute.new(:provider => 'Glesys')
        else
          raise ArgumentError, "Unrecognized service: #{service}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Glesys.services
    end

  end
end
