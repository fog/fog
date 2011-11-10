require 'fog/core'
require 'uri'

module Fog
  module Cloudstack

    extend Fog::Provider

    service(:compute, 'cloudstack/compute','Compute')
    
    DIGEST  = OpenSSL::Digest::Digest.new('sha1')
        
    def self.escape(string)
      string = CGI::escape(string)
      string = string.gsub("+","%20")
      string
    end
    
    def self.signed_params(key,params)
      query = params.to_a.sort.collect{|c| "#{c[0]}=#{escape(c[1].to_s)}"}.join('&').downcase
      
      signed_string = Base64.encode64(OpenSSL::HMAC.digest(DIGEST,key,query)).strip
      
      signed_string
    end
  end
end

