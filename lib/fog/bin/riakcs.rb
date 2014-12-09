class RiakCS < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :provisioning
        Fog::RiakCS::Provisioning
      when :usage
        Fog::RiakCS::Usage
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = class_for(key)
      end
      @@connections[service]
    end

    def services
      Fog::RiakCS.services
    end
  end
end
