module Fog
  class HMAC

    def initialize(type, key)
      @digest = case type
      when 'sha1'
        OpenSSL::Digest::Digest.new('sha1')
      when 'sha256'
        OpenSSL::Digest::Digest.new('sha256')
      end
      @key = key
    end

    def sign(data)
      OpenSSL::HMAC.digest(@digest, @key, data)
    end

  end
end