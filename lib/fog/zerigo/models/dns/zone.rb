require 'fog/core/model'
require 'fog/zerigo/models/dns/records'

module Fog
  module DNS
    class Zerigo
      class Zone < Fog::Model
        identity :id

        attribute :created_at,  :aliases => 'created-at'
        attribute :domain
        attribute :ttl,         :aliases => 'default-ttl'
        attribute :type,        :aliases => 'ns-type'
        attribute :updated_at,  :aliases => 'updated-at'

        # <custom-nameservers>ns1.example.com,ns2.example.com</custom-nameservers>
        # <custom-ns type="boolean">true</custom-ns>
        # <hostmaster>dnsadmin@example.com</hostmaster>
        # <notes nil="true"/>
        # <ns1 nil="true"/>
        # <nx-ttl nil="true"></nx-ttl>
        # <slave-nameservers nil="true"/>
        # <tag-list>one two</tag-list>
        # <hosts-count>1</hosts-count>

        def initialize(attributes={})
          self.type ||= 'pri_sec'
          super
        end

        def destroy
          requires :identity
          service.delete_zone(identity)
          true
        end

        def records
          @records ||= begin
            Fog::DNS::Zerigo::Records.new(
              :zone       => self,
              :service => service
            )
          end
        end

        def nameservers
          [
            'a.ns.zerigo.net',
            'b.ns.zerigo.net',
            'c.ns.zerigo.net',
            'd.ns.zerigo.net',
            'e.ns.zerigo.net'
          ]
        end

        def save
          self.ttl ||= 3600
          requires :domain, :type, :ttl
          options = {}
          # * options<~Hash> - optional paramaters
          #   * ns1<~String> - required if ns_type == sec
          #   * nx_ttl<~Integer> -
          #   * slave_nameservers<~String> - required if ns_type == pri
          #   * axfr_ips<~String> - comma-separated list of IPs or IP blocks allowed to perform AXFRs
          #   * custom_nameservers<~String> - comma-separated list of custom nameservers
          #   * custom_ns<~String> - indicates if vanity (custom) nameservers are enabled for this domain
          #   * hostmaster<~String> - email of the DNS administrator or hostmaster
          #   * notes<~String> - notes about the domain
          #   * restrict_axfr<~String> - indicates if AXFR transfers should be restricted to IPs in axfr-ips
          #   * tag_list<~String> - List of all tags associated with this domain
          data = unless identity
            service.create_zone(domain, ttl, type, options)
          else
            options[:default_ttl] = ttl
            options[:ns_type]     = type
            service.update_zone(identity, options)
          end
          merge_attributes(data.body)
          true
        end
      end
    end
  end
end
