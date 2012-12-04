class GCE < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::GCE
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("GCE[:compute] is not recommended, use
                              Compute[:google] for portability")
          Fog::Compute.new(:provider => 'GCE')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def account
      @@connections[:compute].account
    end

    def services
      Fog::GCE.services
    end

  end
end
