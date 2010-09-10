module Slicehost

  def self.[](service)
    @@connections ||= Hash.new do |hash, key|
      credentials = Fog.credentials.reject do |k, v|
        ![:slicehost_password].include?(k)
      end
      hash[key] = case key
      when :compute
        Fog::Slicehost::Compute.new(credentials)
      end
    end
    @@connections[service]
  end

end
