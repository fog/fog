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
        hash[key] = class_for(key).new
      end
      @@connections[service]
    end

    def services
      [:storage]
    end

  end
end
