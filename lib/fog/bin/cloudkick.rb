class Cloudkick < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :monitoring
        Fog::Cloudkick::Monitoring
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :monitoring
          Fog::Cloudkick::Monitoring.new
        else
          raise ArgumentError, "Unrecognized service: #{service}"
        end
      end
      @@connections[service]
    end

    def services
      [:monitoring]
    end

    def account
      @@connections[:monitoring].account
    end

  end
end
