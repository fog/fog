class Linode < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::Linode
      when :dns
        Fog::DNS::Linode
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Linode[:compute] is deprecated, use Compute[:linode] instead")
          Fog::Compute.new(:provider => 'Linode')
        when :dns
          Fog::Logger.warning("Linode[:storage] is deprecated, use Storage[:linode] instead")
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
