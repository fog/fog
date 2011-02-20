class Linode < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Linode::Compute
      when :dns
        Fog::Linode::DNS
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Compute.new(:provider => 'Linode')
        when :dns
          Fog::DNS.new(:provider => 'Linode')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Linode.services
    end

  end
end
