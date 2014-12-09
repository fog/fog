class Joyent < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::Joyent
      when :analytics
        Fog::Joyent::Analytics
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Joyent[:compute] is not recommended, use Compute[:joyent] for portability")
          Fog::Compute.new(:provider => 'Joyent')
        when :analytics
          Fog::Joyent::Analytics.new
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Joyent.services
    end
  end
end
