module Fog

  def self.providers
    @providers ||= {}
  end

  def self.providers=(new_providers)
    @providers = new_providers
  end

  module Provider

    def self.extended(base)
      provider = base.to_s.split('::').last
      Fog.providers[provider.downcase.to_sym] = provider
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
