require 'fog/core/model'

module Fog
  module Compute
    class Linode
      class Ip < Fog::Model
        identity :id
        attribute :ip
        attribute :public

        def save
          requires :server
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?

          service.linode_ip_addprivate server.id
          server.ips.all.find { |ip| !ip.public }
        end

        def server
          @server
        end

        private
        def server=(server)
          @server = server
        end
      end
    end
  end
end
