require 'fog/compute/models/server'
require 'net/ssh/proxy/command'
require 'tempfile'

module Fog
  module Compute
    class Azure

      class Server < Fog::Compute::Server

        identity :name, :aliases => 'vm_name'
        attribute :external_ip, :aliases => 'ipaddress'
        attribute :machine_type, :aliases => 'role_size'
        attribute :state, :aliases => 'deployment_status'
        attribute :status
        attribute :vm_name
        attribute :vm_user
        attribute :image
        attribute :location
        attribute :private_key_file
        attribute :public_key_file
        attribute :vm_size

        # attribute :image_name, :aliases => 'image'
        # attribute :network_interfaces, :aliases => 'networkInterfaces'
        # attribute :network, :aliases => 'network'
        # attribute :zone_name, :aliases => 'zone'
        # attribute :disks, :aliases => 'disks'
        # attribute :kernel, :aliases => 'kernel'
        # attribute :tags, :squash => 'items'

        # def flavor_id
        #   machine_type
        # end

        # def flavor_id=(flavor_id)
        #   machine_type=flavor_id
        # end

        # def destroy
        #   requires :name, :zone
        #   operation = service.delete_server(name, zone)
        #   # wait until "RUNNING" or "DONE" to ensure the operation doesn't fail, raises exception on error
        #   Fog.wait_for do
        #     operation = service.get_zone_operation(zone_name, operation.body["name"])
        #     operation.body["status"] != "PENDING"
        #   end
        #   operation
        # end

        # def image
        #   service.get_image(self.image_name.split('/')[-1])
        # end

        def public_ip_address
          external_ip
        end

        # def private_ip_address
        #   ip = nil
        #   if self.network_interfaces.respond_to? :first
        #     ip = self.network_interfaces.first['networkIP']
        #   end
        #   ip
        # end

        def ready?
          self.state == 'Running'
        end

        # def zone
        #   if self.zone_name.is_a? String
        #     service.get_zone(self.zone_name.split('/')[-1]).body["name"]
        #   elsif zone_name.is_a? Excon::Response
        #     service.get_zone(zone_name.body["name"]).body["name"]
        #   else
        #     self.zone_name
        #   end
        # end



        # def reload
        #   data = service.get_server(self.name, self.zone).body
        #   self.merge_attributes(data)
        # end

        def save
          requires :vm_name
          requires :vm_user
          requires :image
          requires :location
          requires :private_key_file
          requires :public_key_file
          requires :vm_size

          key = OpenSSL::PKey.read File.read(private_key_file)
          #public_key = OpenSSL::PKey.read File.read(public_key_file)
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

          # data = service.backoff_if_unfound {service.get_server(self.name, self.zone_name).body}
          # service.servers.merge_attributes(data)
        end

      end
    end
  end
end
