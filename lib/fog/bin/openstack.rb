class OpenStack < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::OpenStack
      when :identity
        Fog::Identity::OpenStack
      when :image
        Fog::Image::OpenStack
      when :network
        Fog::Network::OpenStack
      when :storage
        Fog::Storage::OpenStack
      when :volume
        Fog::Volume::OpenStack
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
          Fog::Logger.warning("OpenStack[:identity] is not recommended, use Identity[:openstack] for portability")
          Fog::Identity.new(:provider => 'OpenStack')
        when :image
          Fog::Logger.warning("OpenStack[:image] is not recommended, use Image[:openstack] for portability")
          Fog::Image.new(:provider => 'OpenStack')
        when :network
          Fog::Logger.warning("OpenStack[:network] is not recommended, use Network[:openstack] for portability")
          Fog::Network.new(:provider => 'OpenStack')
        when :storage
          Fog::Logger.warning("OpenStack[:storage] is not recommended, use Storage[:openstack] for portability")
          Fog::Storage.new(:provider => 'OpenStack')
        when :volume
          Fog::Logger.warning("OpenStack[:volume] is not recommended, use Volume[:openstack] for portability")
          Fog::Volume.new(:provider => 'OpenStack')
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
