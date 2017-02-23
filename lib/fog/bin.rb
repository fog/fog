require 'fog/core/credentials'

module Fog
  class << self
    def available_providers
      @available_providers ||= Fog.providers.values.select {|provider| Kernel.const_get(provider).available?}.sort
    end

    def registered_providers
      @registered_providers ||= Fog.providers.values.sort
    end
  end

  class Bin
    class << self
      def available?
        availability = true
        for service in services
          begin
            service = self.class_for(service)
            availability &&= service.requirements.all? { |requirement| Fog.credentials.include?(requirement) }
          rescue ArgumentError => e
            Fog::Logger.warning(e.message)
            availability = false
          rescue => e
            availability = false
          end
        end

        if availability
          for service in services
            for collection in self.class_for(service).collections
              unless self.respond_to?(collection)
                self.class_eval <<-EOS, __FILE__, __LINE__
                  def self.#{collection}
                    self[:#{service}].#{collection}
                  end
                EOS
              end
            end
          end
        end

        availability
      end

      def collections
        services.map {|service| self[service].collections}.flatten.sort_by {|service| service.to_s}
      end
    end
  end
end

require 'fog/bin/atmos'
require 'fog/bin/aws'
require 'fog/bin/bluebox'
require 'fog/bin/brightbox'
require 'fog/bin/cloudstack'
require 'fog/bin/clodo'
require 'fog/bin/digitalocean'
require 'fog/bin/dnsimple'
require 'fog/bin/dnsmadeeasy'
require 'fog/bin/fogdocker'
require 'fog/bin/dreamhost'
require 'fog/bin/dynect'
require 'fog/bin/ecloud'
require 'fog/bin/glesys'
require 'fog/bin/go_grid'
require 'fog/bin/google'
require 'fog/bin/ibm'
require 'fog/bin/internet_archive'
require 'fog/bin/joyent'
require 'fog/bin/linode'
require 'fog/bin/local'
require 'fog/bin/bare_metal_cloud'
require 'fog/bin/rackspace'
require 'fog/bin/rage4'
require 'fog/bin/riakcs'
require 'fog/bin/openstack'
require 'fog/bin/ovirt'
require 'fog/bin/powerdns'
require 'fog/bin/profitbricks'
require 'fog/bin/sakuracloud'
require 'fog/bin/serverlove'
require 'fog/bin/softlayer'
require 'fog/bin/storm_on_demand'
require 'fog/bin/terremark'
require 'fog/bin/vcloud'
require 'fog/bin/vcloud_director'
require 'fog/bin/vmfusion'
require 'fog/bin/vsphere'
require 'fog/bin/voxel'
require 'fog/bin/xenserver'
require 'fog/bin/zerigo'
require 'fog/bin/cloudsigma'
require 'fog/bin/openvz'
require 'fog/bin/opennebula'
require 'fog/bin/aliyun'
