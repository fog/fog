class Radosgw < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :provisioning
        Fog::Radosgw::Provisioning
      when :usage
        Fog::Radosgw::Usage
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
      Fog::Radosgw.services
    end
  end
end
