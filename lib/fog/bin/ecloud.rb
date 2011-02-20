class Ecloud < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Ecloud::Compute
      else 
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'Ecloud')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Ecloud.services
    end

  end
end
