require 'fog/credentials'

require 'fog/aws/bin'
require 'fog/local/bin'
require 'fog/new_servers/bin'
require 'fog/rackspace/bin'
require 'fog/slicehost/bin'
require 'fog/terremark/bin'
require 'fog/vcloud/bin'
require 'fog/bluebox/bin'

module Fog
  class << self

    def services
      services = []
      [::AWS, ::Local, ::NewServers, ::Rackspace, ::Slicehost, ::Terremark, ::Vcloud, ::Bluebox].each do |service|
        if service.initialized?
          services << service
        end
      end
      services
    end

    def directories
      directories = {}
      services.each do |service|
        if service.respond_to?(:directories)
          directories[service] = service.directories
        end
      end
      directories
    end

    def flavors
      flavors = {}
      services.each do |service|
        if service.respond_to?(:flavors)
          flavors[service] = service.flavors
        end
      end
      flavors
    end

    def images
      images = {}
      services.each do |service|
        if service.respond_to?(:images)
          images[service] = service.images
        end
      end
      images
    end

    def servers
      servers = {}
      services.each do |service|
        if service.respond_to?(:servers)
          servers[service] = service.servers
        end
      end
      servers
    end

  end
end
