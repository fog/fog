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
      when :metering
        Fog::Metering::OpenStack
      when :orchestration
        Fog::Orchestration::OpenStack
      when :baremetal
        Fog::Baremetal::OpenStack
      when :planning
        Fog::Openstack::Planning
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
        when :metering
          Fog::Logger.warning("OpenStack[:metering] is not recommended, use Metering[:openstack] for portability")
          Fog::Metering.new(:provider => 'OpenStack')
        when :orchestration
          Fog::Logger.warning("OpenStack[:orchestration] is not recommended, use Orchestration[:openstack] for portability")
          Fog::Orchestration.new(:provider => 'OpenStack')
        when :baremetal
          Fog::Logger.warning("OpenStack[:baremetal] is not recommended, use Baremetal[:openstack] for portability")
          Fog::Baremetal.new(:provider => 'OpenStack')
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
