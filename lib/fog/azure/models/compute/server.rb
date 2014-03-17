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
        attribute :public_key_file
        attribute :vm_size, :aliases => 'role_size'

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

        def save
          requires :vm_name
          requires :vm_user
          requires :image
          requires :location
          requires :private_key_file
          requires :vm_size

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



          #API to start deployment
          params = {
            :vm_name => vm_name,
            :vm_user => vm_user,
            :image => image,
            #  :password => 'Password',
            :location => location,
          }
          options = {
            #  :storage_account_name => 'storage_suse',

            #  :winrm_transport => ['https','http'],
            #Currently http is supported. To enable https, set the
            #transport protocol to https, simply rdp to the VM once VM
            #is in ready state, export the certificate ( CN name would
            #be the deployment name) from the certstore of the VM and
            #install to your local machine and communicate WinRM via
            #https.
            #  :cloud_service_name => 'cloud_service_name',
            #  :deployment_name =>'vm_name',
            #  :tcp_endpoints => '80,3389:3390',
            :private_key_file => private_key_file,
            :certificate_file => cert_file.path,
            #  :certificate_file => 'c:/certificate.pem',
            #required for ssh or winrm(https) certificate.
            #  :ssh_port => 2222,
            :vm_size => vm_size
            # :affinity_group_name => 'affinity1',
            # :virtual_network_name => 'xplattestvnet',
            # :subnet_name => 'subnet1',
            # :availability_set_name => 'availabiltyset1'
          }


          service.create_virtual_machine(params, options)
          cert_file.unlink
        end

      end
    end
  end
end
