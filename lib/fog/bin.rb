require File.join(File.dirname(__FILE__), 'credentials')

module Fog
  class << self

    def services
      services = []
      [::AWS, ::Local, ::Rackspace, ::Slicehost, ::Terremark].each do |service|
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
