module Rackspace

  def self.[](service)
    @@connections ||= Hash.new do |hash, key|
      credentials = Fog.credentials.reject do |k, v|
        ![:rackspace_api_key, :rackspace_username].include?(k)
      end
      hash[key] = case key
      when :compute
        Fog::Rackspace::Compute.new(credentials)
      when :storage
        Fog::Rackspace::Storage.new(credentials)
      end
    end
    @@connections[service]
  end

  module Compute

    module Formats

      SUMMARY = {
        'id'    => Integer,
        'name'  => String
      }

    end

  end

end
