require File.join(File.dirname(__FILE__), 'credentials')

module Fog
  class << self

    def services
      services = []
      [::AWS, ::Rackspace, ::Slicehost, ::Terremark].each do |service|
        if service.initialized?
          services << service
        end
      end
      services
    end

    def flavors
      flavors = {}
      services.each do |service|
        flavors[service] = service.flavors
      end
      flavors
    end

    def images
      images = {}
      services.each do |service|
        images[service] = service.images
      end
      images
    end

    def servers
      servers = {}
      services.each do |service|
        servers[service] = service.servers
      end
      servers
    end

  end
end
