class XenServer < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::XenServer
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("XenServer[:compute] is not recommended, use Compute[:xenserver] for portability")
          Fog::Compute.new(:provider => 'XenServer')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::XenServer.services
    end

  end
end
