require 'fog/core'
require 'fog/json'
require 'uri'

module Fog
  module Cloudstack
    extend Fog::Provider

    service(:compute, 'Compute')

    @@digest  = OpenSSL::Digest.new('sha1')

    def self.escape(string)
      string = CGI::escape(string)
      string = string.gsub("+","%20")
      # Escaped asterisk will cause malformed request
      string = string.gsub("%2A","*")
      string
    end

    def self.signed_params(key,params)
      query = params.map{|k,v| [k.to_s, v]}.sort.map{|c| "#{c[0]}=#{escape(c[1].to_s)}"}.join('&').downcase

      signed_string = Base64.encode64(OpenSSL::HMAC.digest(@@digest,key,query)).strip

      signed_string
    end

    def self.uuid
      [8,4,4,4,12].map{|i| Fog::Mock.random_hex(i)}.join("-")
    end

    def self.ip_address
      4.times.map{ Fog::Mock.random_numbers(3) }.join(".")
    end

    def self.mac_address
      6.times.map{ Fog::Mock.random_numbers(2) }.join(":")
    end
  end
end
