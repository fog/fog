class Serverlove < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::Serverlove
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Serverlove[:compute] is not recommended, use Compute[:serverlove] for portability")
          Fog::Compute.new(:provider => 'Serverlove')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Serverlove.services
    end
  end
end
