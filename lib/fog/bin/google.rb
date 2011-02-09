class Google < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :storage
        Fog::Google::Storage
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :storage
          Fog::Storage.new(:provider => 'Google')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Google.services
    end

  end
end
