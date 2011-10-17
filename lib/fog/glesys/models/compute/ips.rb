require 'fog/core/collection'
require 'fog/glesys/models/compute/ip'

module Fog
  module Compute
    class Glesys

      class Ips < Fog::Collection

        model Fog::Glesys::Compute::Ip

        attribute :serverid

        def all
          data = connection.ip_list_own.body['response']['iplist']
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          
          self.new( :serverid => identifier )          

          data  = connection.ip_list_own(:serverid => identifier).body['response']
          if data['iplist'].empty?
            nil 
          else
            new(data['iplist'].first)
          end 
        end 

        def new(attributes = {})
          super({ :serverid => serverid }.merge!(attributes))
        end

      end
    end
  end
end
