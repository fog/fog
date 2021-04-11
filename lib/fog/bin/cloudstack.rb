class Cloudstack < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::Cloudstack
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'Cloudstack')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Cloudstack.services
    end
  end
end
