class Google < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::Google
      when :storage
        Fog::Storage::Google
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :storage
          Fog::Logger.warning("Google[:storage] is not recommended, use Storage[:google] for portability")
          Fog::Storage.new(:provider => 'Google')
        when :compute
          Fog::Logger.warning("Google[:compute] is not recommended, use Compute[:google] for portability")
          Fog::Compute.new(:provider => 'Google')
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
      Fog::Google.services
    end

  end
end
