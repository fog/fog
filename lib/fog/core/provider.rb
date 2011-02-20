module Fog
  module Provider

    def self.extended(base)
      Fog.providers << base.to_s.split('::').last
    end

    def service(new_service, path)
      services << new_service
      require File.join('fog', path)
    end

    def services
      @services ||= []
    end

  end
end
