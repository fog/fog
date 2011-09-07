module Fog

  def self.providers
    @providers ||= []
  end

  module Provider

    def self.extended(base)
      Fog.providers << base.to_s.split('::').last
    end

    def service(new_service, path)
      Fog.services[new_service] ||= []
      Fog.services[new_service] << self.to_s.split('::').last.downcase.to_sym
      self.services << new_service
      require File.join('fog', path)
    end

    def services
      @services ||= []
    end

  end
end
