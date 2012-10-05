class OpenStack < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::OpenStack
      when :identity
        Fog::Identity::OpenStack
      when :network
        Fog::Network::OpenStack
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("OpenStack[:compute] is not recommended, use Compute[:openstack] for portability")
          Fog::Compute.new(:provider => 'OpenStack')
        when :identity
          Fog::Logger.warning("OpenStack[:identity] is not recommended, use Compute[:openstack] for portability")
          Fog::Compute.new(:provider => 'OpenStack')
        when :network
          Fog::Logger.warning("OpenStack[:network] is not recommended, use Network[:openstack] for portability")
          Fog::Network.new(:provider => 'OpenStack')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::OpenStack.services
    end

  end
end
