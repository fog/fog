require 'fog/compute/models/server'
require 'net/ssh/proxy/command'
require 'tempfile'

module Fog
  module Compute
    class Azure

      class Server < Fog::Compute::Server
        # attr names are from azure
        identity :vm_name
        attribute :ipaddress
        attribute :deployment_status
        attribute :status
        attribute :hostname
        attribute :cloud_service_name
        attribute :deployment_name
        attribute :tcp_endpoints
        attribute :udp_endpoints
        attribute :virtual_network_name
        attribute :availability_set_name
        attribute :os_type
        attribute :disk_name
        attribute :image
        attribute :vm_user
        attribute :location
        attribute :private_key_file
        attribute :vm_size, :aliases => 'role_size'
        attribute :storage_account_name, :type => :string
        attribute :password
        attribute :winrm_transport
        attribute :deployment_name
        attribute :tcp_endpoints
        attribute :ssh_port
        attribute :affinity_group_name
        attribute :virtual_network_name
        attribute :subnet_name
        attribute :availability_set_name
        attribute :certificate_file

        #helper functions for more common fog names
        def external_ip
          ipaddress
        end

        def public_ip_address
          ipaddress
        end

        def name
          vm_name
        end

        def state
          deployment_status
        end

        def username
          vm_user
        end

        def machine_type
          vm_size
        end

        def ready?
          state == 'Running'
        end


        def destroy
          requires :vm_name
          requires :cloud_service_name

          service.delete_virtual_machine(vm_name, cloud_service_name)
        end

        def reboot
          requires :vm_name
          requires :cloud_service_name

          service.reboot_server(vm_name, cloud_service_name)
        end

        def save
          requires :vm_name
          requires :vm_user
          requires :image
          requires_one :location, :affinity_group_name
          requires :vm_size

          if ! private_key_file.nil? && certificate_file.nil?
            key = OpenSSL::PKey.read File.read(private_key_file)
            cert = OpenSSL::X509::Certificate.new
            cert.version = 2 # cf. RFC 5280 - to make it a "v3" certificate
            cert.serial = 1
            cert.subject = OpenSSL::X509::Name.parse "/CN=Fog"
            cert.issuer = cert.subject # root CA's are "self-signed"
            cert.public_key = key.public_key
            cert.not_before = Time.now
            cert.not_after = cert.not_before + 2 * 365 * 24 * 60 * 60 # 2 years validity
            ef = OpenSSL::X509::ExtensionFactory.new
            ef.subject_certificate = cert
            ef.issuer_certificate = cert
            cert.add_extension(ef.create_extension("basicConstraints","CA:TRUE",true))
            cert.add_extension(ef.create_extension("keyUsage","keyCertSign, cRLSign", true))
            cert.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
            cert.add_extension(ef.create_extension("authorityKeyIdentifier","keyid:always",false))
            cert.sign(key, OpenSSL::Digest::SHA256.new)

            cert_file = Tempfile.new(['cert', '.pem'])
            cert_file.chmod(0600)
            cert_file.write(cert.to_pem)
            cert_file.close
            self.certificate_file = cert_file.path
          end

          if storage_account_name.nil?
            service.storage_accounts.each do |sa|
              if sa.location == location
                self.storage_account_name = sa.name
                break
              end
            end
          end

          if cloud_service_name.nil?
            self.cloud_service_name = vm_name
          end

          #API to start deployment
          params = {
            :vm_name => vm_name,
            :vm_user => vm_user,
            :image => image,
            :password => password,
            :location => location,
          }
          options = {
            :storage_account_name => storage_account_name,
            :winrm_transport => winrm_transport,
            :cloud_service_name => cloud_service_name,
            :deployment_name => deployment_name,
            :tcp_endpoints => tcp_endpoints,
            :private_key_file => private_key_file,
            :certificate_file => certificate_file,
            :ssh_port => ssh_port,
            :vm_size => vm_size,
            :affinity_group_name => affinity_group_name,
            :virtual_network_name => virtual_network_name,
            :subnet_name => subnet_name,
            :availability_set_name => availability_set_name,
          }
          service.create_virtual_machine(params, options)
          cert_file.unlink unless cert_file.nil?
        end

      end
    end
  end
end
