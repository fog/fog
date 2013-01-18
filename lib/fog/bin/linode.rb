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
          Fog::Logger.warning("Linode[:compute] is not recommended, use Compute[:linode] for portability")
          Fog::Compute.new(:provider => 'Linode')
        when :dns
          Fog::Logger.warning("Linode[:dns] is not recommended, use DNS[:linode] for portability")
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
