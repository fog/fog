class Rackspace < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :cdn
        Fog::Rackspace::CDN
      when :compute
        Fog::Rackspace::Compute
      when :storage
        Fog::Rackspace::Storage
      else 
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :cdn
          Fog::CDN.new(:provider => 'Rackspace')
        when :compute
          Fog::Compute.new(:provider => 'Rackspace')
        when :dns
          Fog::DNS.new(:provider => 'Rackspace')
        when :storage
          Fog::Storage.new(:provider => 'Rackspace')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Rackspace.services
    end

  end
end
