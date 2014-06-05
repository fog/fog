class Ecloud < Fog::Bin
  class << self
    def available?
      Fog::Ecloud::ECLOUD_OPTIONS.all? {|requirement| Fog.credentials.include?(requirement)}
    end

    def class_for(key)
      case key
      when :compute
        Fog::Compute::Ecloud
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Ecloud[:compute] is not recommended, use Compute[:ecloud] for portability")
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
