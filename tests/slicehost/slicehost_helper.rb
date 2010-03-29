module Slicehost

  def self.[](service)
    @@connections ||= Hash.new do |hash, key|
      credentials = Fog.credentials.reject do |k, v|
        ![:slicehost_password].include?(k)
      end
      hash[key] = case key
      when :slices
        Fog::Slicehost.new(credentials)
      end
    end
    @@connections[service]
  end

  module Formats

    BACKUP = {
      'date'      => String,
      'id'        => Integer,
      'name'      => String,
      'slice-id'  => Integer
    }

    FLAVOR = {
      'id'    => Integer,
      'name'  => String,
      'price' => Integer,
      'ram'   => Integer
    }

    IMAGE = {
      'id'    => Integer,
      'name'  => String
    }

    SLICE = {
      'addresses'     => [String],
      'bw-in'         => Float,
      'bw-out'        => Float,
      'flavor-id'     => Integer,
      'id'            => Integer,
      'image-id'      => Integer,
      'name'          => String,
      'progress'      => Integer,
      'status'        => String
    }

  end

end