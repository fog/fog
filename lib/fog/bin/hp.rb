class HP < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :cdn
        Fog::HP::CDN
      when :compute
        Fog::HP::Compute
      when :storage
        Fog::HP::Storage
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
        when :dns
          Fog::DNS.new(:provider => 'HP')
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
