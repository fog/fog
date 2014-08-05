module Fog
  module Compute
    class Ecloud
      class AuthenticationLevel < Fog::Ecloud::Model
        identity :href

        attribute :basic_enabled, :aliases => :BasicEnabled, :type => :boolean
        attribute :sha1_enabled, :aliases => :SHA1Enabled, :type => :boolean
        attribute :Sha256_enabled, :aliases => :SHA256Enabled, :type => :boolean
        attribute :Sha512_enabled, :aliases => :SHA512Enabled, :type => :boolean
        attribute :hmacsha1_enabled, :aliases => :HMACSHA1Enabled, :type => :boolean
        attribute :hmacsha256_enabled, :aliases => :HMACSHA256Enabled, :type => :boolean
        attribute :hmacsha512_enabled, :aliases => :HMACSHA512Enabled, :type => :boolean

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
