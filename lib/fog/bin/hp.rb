class HP < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :cdn
        Fog::CDN::HP
      when :compute
        Fog::Compute::HP
      when :storage
        Fog::Storage::HP
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :cdn
          Fog::CDN.new(:provider => 'HP')
        when :compute
          Fog::Compute.new(:provider => 'HP')
        when :storage
          Fog::Storage.new(:provider => 'HP')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::HP.services
    end

  end
end
