module Rackspace

  def self.[](service)
    @@connections ||= Hash.new do |hash, key|
      credentials = Fog.credentials.reject do |k, v|
        ![:rackspace_api_key, :rackspace_username].include?(k)
      end
      hash[key] = case key
      when :files
        Fog::Rackspace::Files.new(credentials)
      when :servers
        Fog::Rackspace::Servers.new(credentials)
      end
    end
    @@connections[service]
  end

  module Files

    module Formats

    end

  end

  module Servers

    module Formats

      IMAGE = {
        'created'   => String,
        'id'        => Integer,
        'name'      => String,
        'progress'  => Integer,
        'serverId'  => Integer,
        'status'    => String,
        'updated'   => String
      }

      SUMMARY = {
        'id'    => Integer,
        'name'  => String
      }

    end

  end

end
