require 'fog/core'

module Fog
  module Cloudstack

    extend Fog::Provider

    service(:compute, 'compute/cloudstack')
    
    DIGEST  = OpenSSL::Digest::Digest.new('sha1')
        
    def self.escape(string)
      CGI::escape(string)
    end
    
    def self.signed_params(key,params)
      query = params.to_a.sort.collect{|c| "#{c[0]}=#{escape(c[1])}"}.join('&').downcase
      
      signed_string = Base64.encode64(OpenSSL::HMAC.digest(DIGEST,key,query)).strip
      
      signed_string
    end
  end
end

