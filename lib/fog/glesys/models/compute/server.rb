require 'fog/compute/models/server'

module Fog
  module Compute
    class Glesys
      class Server < Fog::Compute::Server
        extend Fog::Deprecation

        identity :serverid

        attribute :hostname
        attribute :datacenter
        attribute :cpucores
        attribute :memorysize
        attribute :disksize
        attribute :transfer
        attribute :bandwidth
        attribute :uptime
        attribute :templatename
        attribute :managedhosting
        attribute :platform
        attribute :cost
        attribute :rootpassword
        attribute :state
        attribute :iplist
        attribute :description
        attribute :usage
        attribute :glera_enabled, :aliases => "gleraenabled"
        attribute :supported_features, :aliases => "supportedfeatures"

        def ready?
          state == 'running'
        end

        def start
          requires :identity
          service.start(:serverid => identity)
        end

        def stop
          requires :identity
          service.stop(:serverid => identity)
        end

        def reboot
          requires :identity
          service.reboot(:serverid => identity)
        end

        def destroy(options = {})
          requires :identity
          service.destroy(options.merge!({:serverid => identity}))
        end

        def save
          if self.identity
            options = {
              :serverid => self.identity,
              :disksize => disksize,
              :memorysize => memorysize,
              :cpucores => cpucores,
              :hostname => hostname,
              :bandwidth => bandwidth
            }
            data = service.edit(options)
          else
            requires :hostname, :rootpassword

            options = {
              :datacenter     => datacenter   || "Falkenberg",
              :platform       => platform     || "OpenVz",
              :hostname       => hostname,
              :templatename   => templatename || "Debian 7.0 64-bit",
              :disksize       => disksize     || "10",
              :memorysize     => memorysize   || "512",
              :cpucores       => cpucores     || "1",
              :rootpassword   => rootpassword
            }

            # optional options when creating a server:
            [:description, :ip, :ipv6, :transfer, :bandwidth, :campaigncode, :sshkeyids, :sshkey].each do |k|
              options[k] = attributes[k] if attributes[k]
            end

            data = service.create(options)
          end
          merge_attributes(data.body['response']['server'])
          data.status == 200 ? true : false
        end

        def setup(credentials = {})
          requires :ssh_ip_address, :username

          attrs = attributes.dup
          attrs.delete(:rootpassword)

          commands = [
            %{mkdir -p .ssh},
            %{echo "#{Fog::JSON.encode(Fog::JSON.sanitize(attrs))}" >> ~/attributes.json}
          ]
          if public_key
            commands << %{echo "#{public_key}" >> ~/.ssh/authorized_keys}
          end

          if credentials[:password].nil? && !rootpassword.nil?
            credentials[:password] = rootpassword
          end

          # wait for glesys to be ready
          wait_for { sshable?(credentials) }

          Fog::SSH.new(ssh_ip_address, username, credentials).run(commands)
        end

        def ssh(command, options={}, &block)
          if options[:password].nil? && !rootpassword.nil?
            options[:password] = rootpassword
          end
          super(command, options, &block)
        end

        def ips
          Fog::Compute::Glesys::Ips.new(:serverid => identity, :server => self, :service => service).all
        end

        def ip(ip)
          Fog::Compute::Glesys::Ips.new(:serverid => identity, :server => self, :service => service).get(ip)
        end

        def public_ip_address(options = {})
          return nil if iplist.nil?

          type = options[:type] || nil

          ips = case type
            when :ipv4 then iplist.select { |ip| ip["version"] == 4 }
            when :ipv6 then iplist.select { |ip| ip["version"] == 6 }
            else iplist.sort_by { |ip| ip["version"] }
          end

          if ips.empty?
            nil
          else
            ips.first["ipaddress"]
          end
        end
      end
    end
  end
end
