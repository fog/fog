require 'fog/core/credentials'

module Fog
  class << self

    def available_providers
      @available_providers ||= @providers.select {|provider| Kernel.const_get(provider).available?}.sort
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

require 'fog/bin/aws'
require 'fog/bin/bluebox'
require 'fog/bin/brightbox'
require 'fog/bin/dnsimple'
require 'fog/bin/dnsmadeeasy'
require 'fog/bin/dynect'
require 'fog/bin/ecloud'
require 'fog/bin/glesys'
require 'fog/bin/go_grid'
require 'fog/bin/google'
require 'fog/bin/libvirt'
require 'fog/bin/linode'
require 'fog/bin/local'
require 'fog/bin/new_servers'
require 'fog/bin/ninefold'
require 'fog/bin/rackspace'
require 'fog/bin/slicehost'
require 'fog/bin/stormondemand'
require 'fog/bin/terremark'
require 'fog/bin/vcloud'
require 'fog/bin/virtual_box'
require 'fog/bin/vmfusion'
require 'fog/bin/vsphere'
require 'fog/bin/voxel'
require 'fog/bin/zerigo'
