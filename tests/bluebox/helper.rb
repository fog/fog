module Bluebox

  def self.[](service)
    @@connections ||= Hash.new do |hash, key|
      credentials = Fog.credentials.reject do |k,v|
        ![:bluebox_api_key, :bluebox_customer_id].include?(k)
      end
      hash[key] = case key
      when :compute
        Fog::Bluebox::Compute.new(credentials)
      end
    end
    @@connections[service]
  end

  module Compute

    module Formats

      PRODUCT = {
        'cost'        => Float,
        'description' => String,
        'id'          => String
      }

    end

  end

end
