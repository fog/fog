module Linode

  def self.[](service)
    @@connections ||= Hash.new do |hash, key|
      credentials = Fog.credentials.reject do |k,v|
        ![:linode_api_key].include?(k)
      end
      hash[key] = case key
      when :linode
        Fog::Linode.new(credentials)
      end
    end
    @@connections[service]
  end

  module Formats

    BASIC = {
      'ERRORARRAY'  => [],
      'ACTION'      => String
    }

  end

end