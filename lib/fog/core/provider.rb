module Fog

  def self.providers
    @providers ||= []
  end

  module Provider

    def self.extended(base)
      Fog.providers << base.to_s.split('::').last
    end

    def [](service_key)
      eval(@services_registry[service_key]).new
    end

    def service(new_service, path, constant_string)
      Fog.services[new_service] ||= []
      Fog.services[new_service] |= [self.to_s.split('::').last.downcase.to_sym]
      @services_registry ||= {}
      @services_registry[new_service] = [self.to_s, constant_string].join('::')
      require File.join('fog', path)
    end

    def services
      @services_registry.keys
    end

  end
end
