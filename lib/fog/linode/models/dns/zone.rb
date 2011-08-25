require 'fog/core/model'
require 'fog/linode/models/dns/records'

module Fog
  module DNS
    class Linode

      class Zone < Fog::Model

        identity :id,           :aliases => ['DomainID', 'DOMAINID', 'ResourceID']

        attribute :description, :aliases => 'DESCRIPTION'
        attribute :domain,      :aliases => 'DOMAIN'
        attribute :email,       :aliases => 'SOA_EMAIL'
        attribute :ttl,         :aliases => 'TTL_SEC'
        attribute :type,        :aliases => 'TYPE'

        # "STATUS":1,
        # "RETRY_SEC":0,
        # "MASTER_IPS":"",
        # "EXPIRE_SEC":0,
        # "REFRESH_SEC":0,
        # "TTL_SEC":0

        def initialize(attributes={})
          self.type ||= 'master'
          self.ttl  ||= 3600
          super
        end

        def destroy
          requires :identity
          connection.domain_delete(identity)
          true
        end

        def records
          @records ||= begin
            Fog::DNS::Linode::Records.new(
              :zone       => self,
              :connection => connection
            )
          end
        end

        def nameservers
          [
            'ns1.linode.com',
            'ns2.linode.com',
            'ns3.linode.com',
            'ns4.linode.com',
            'ns5.linode.com'
          ]
        end

        def save
          requires :domain, :type
          requires :email if type == 'master'
          options = {}
          # * options<~Hash>
          #   * refresh_sec<~Integer> numeric, default: '0'
          #   * retry_sec<~Integer> numeric, default: '0'
          #   * expire_sec<~Integer> numeric, default: '0'
          #   * status<~Integer> 0, 1, or 2 (disabled, active, edit mode), default: 1 
          #   * master_ips<~String> When type=slave, the zone's master DNS servers list, semicolon separated
          options[:description] = description if description
          options[:soa_email]   = email if email
          options[:ttl_sec]     = ttl if ttl
          response = unless identity
            connection.domain_create(domain, type, options)
          else
            options[:domain]  = domain if domain
            options[:type]    = type if type
            connection.domain_update(identity, options)
          end
          merge_attributes(response.body['DATA'])
          true
        end

      end

    end
  end
end
