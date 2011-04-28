class Stormondemand < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Stormondemand::Compute
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'Stormondemand')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Stormondemand.services
    end

  end
end