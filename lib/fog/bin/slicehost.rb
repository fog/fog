class Slicehost < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Slicehost::Compute
      when :dns
        Fog::Slicehost::DNS
      else 
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'Slicehost')
        when :dns
          Fog::DNS.new(:provider => 'Slicehost')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Slicehost.services
    end

  end
end
