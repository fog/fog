require 'digest/sha2'

module Fog
  module Compute
    class Vsphere < Fog::Service

      requires :vsphere_username, :vsphere_password, :vsphere_server
      recognizes :vsphere_port, :vsphere_path, :vsphere_ns
      recognizes :vsphere_rev, :vsphere_ssl, :vsphere_expected_pubkey_hash

      model_path 'fog/vsphere/models/compute'
      model :server
      collection :servers
      model :datacenter
      collection :datacenters
      model :interface
      collection :interfaces
      model :volume
      collection :volumes
      model :template
      collection :templates
      model :cluster
      collection :clusters
      model :resource_pool
      collection :resource_pools
      model :network
      collection :networks
      model :datastore
      collection :datastores
      model :folder
      collection :folders

      request_path 'fog/vsphere/requests/compute'
      request :current_time
      request :list_virtual_machines
      request :vm_power_off
      request :vm_power_on
      request :vm_reboot
      request :vm_clone
      request :vm_destroy
      request :vm_migrate
      request :list_datacenters
      request :get_datacenter
      request :list_clusters
      request :get_cluster
      request :list_resource_pools
      request :get_resource_pool
      request :list_networks
      request :get_network
      request :list_datastores
      request :get_datastore
      request :get_folder
      request :list_folders
      request :create_vm
      request :list_vm_interfaces
      request :list_vm_volumes
      request :get_virtual_machine
      request :vm_reconfig_hardware
      request :vm_reconfig_memory
      request :vm_reconfig_cpus
      request :vm_config_vnc

      module Shared

        attr_reader :vsphere_is_vcenter
        attr_reader :vsphere_rev
        attr_reader :vsphere_server
        attr_reader :vsphere_username

        protected

        ATTR_TO_PROP = {
          :id => 'config.instanceUuid',
          :name => 'name',
          :uuid => 'config.uuid',
          :hostname => 'summary.guest.hostName',
          :operatingsystem => 'summary.guest.guestFullName',
          :ipaddress => 'guest.ipAddress',
          :power_state => 'runtime.powerState',
          :connection_state => 'runtime.connectionState',
          :hypervisor => 'runtime.host',
          :tools_state => 'guest.toolsStatus',
          :tools_version => 'guest.toolsVersionStatus',
          :memory_mb => 'config.hardware.memoryMB',
          :cpus   => 'config.hardware.numCPU',
          :overall_status => 'overallStatus',
          :guest_id => 'summary.guest.guestId',
        }

        # Utility method to convert a VMware managed object into an attribute hash.
        # This should only really be necessary for the real class.
        # This method is expected to be called by the request methods
        # in order to massage VMware Managed Object References into Attribute Hashes.
        def convert_vm_mob_ref_to_attr_hash(vm_mob_ref)
          return nil unless vm_mob_ref

          props = vm_mob_ref.collect!(*ATTR_TO_PROP.values.uniq)
          # NOTE: Object.tap is in 1.8.7 and later.
          # Here we create the hash object that this method returns, but first we need
          # to add a few more attributes that require additional calls to the vSphere
          # API. The hypervisor name and mac_addresses attributes may not be available
          # so we need catch any exceptions thrown during lookup and set them to nil.
          #
          # The use of the "tap" method here is a convenience, it allows us to update the
          # hash object without explicitly returning the hash at the end of the method.
          Hash[ATTR_TO_PROP.map { |k,v| [k.to_s, props[v]] }].tap do |attrs|
            attrs['id'] ||= vm_mob_ref._ref
            attrs['mo_ref'] = vm_mob_ref._ref
            # The name method "magically" appears after a VM is ready and
            # finished cloning.
            if attrs['hypervisor'].kind_of?(RbVmomi::VIM::HostSystem)
              begin
                host = attrs['hypervisor']
                attrs['datacenter'] = parent_attribute(host.path, :datacenter)[1]
                attrs['cluster']    = parent_attribute(host.path, :cluster)[1]
                attrs['hypervisor'] = host.name
                attrs['resource_pool'] = (vm_mob_ref.resourcePool || host.resourcePool).name rescue nil
              rescue
                # If it's not ready, set the hypervisor to nil
                attrs['hypervisor'] = nil
              end
            end
            # This inline rescue catches any standard error.  While a VM is
            # cloning, a call to the macs method will throw and NoMethodError
            attrs['mac_addresses'] = vm_mob_ref.macs rescue nil
            attrs['path'] = get_folder_path(vm_mob_ref.parent)
          end
        end

        # returns the parent object based on a type
        # provides both real RbVmomi object and its name.
        # e.g.
        #[Datacenter("datacenter-2"), "dc-name"]
        def parent_attribute path, type
          element = case type
                      when :datacenter
                        RbVmomi::VIM::Datacenter
                      when :cluster
                        RbVmomi::VIM::ClusterComputeResource
                      when :host
                        RbVmomi::VIM::HostSystem
                      else
                        raise "Unknown type"
                    end
          path.select {|x| x[0].is_a? element}.flatten
        rescue
          nil
        end

        # returns vmware managed obj id string
        def managed_obj_id obj
          obj.to_s.match(/\("(\S+)"\)/)[1]
        end

      end

      class Mock

        include Shared

        def initialize(options={})
          require 'rbvmomi'
          @vsphere_username = options[:vsphere_username]
          @vsphere_password = 'REDACTED'
          @vsphere_server   = options[:vsphere_server]
          @vsphere_expected_pubkey_hash = options[:vsphere_expected_pubkey_hash]
          @vsphere_is_vcenter = true
          @vsphere_rev = '4.0'
        end

      end

      class Real

        include Shared

        def initialize(options={})
          require 'rbvmomi'
          @vsphere_username = options[:vsphere_username]
          @vsphere_password = options[:vsphere_password]
          @vsphere_server   = options[:vsphere_server]
          @vsphere_port     = options[:vsphere_port] || 443
          @vsphere_path     = options[:vsphere_path] || '/sdk'
          @vsphere_ns       = options[:vsphere_ns] || 'urn:vim25'
          @vsphere_rev      = options[:vsphere_rev] || '4.0'
          @vsphere_ssl      = options[:vsphere_ssl] || true
          @vsphere_expected_pubkey_hash = options[:vsphere_expected_pubkey_hash]
          @vsphere_must_reauthenticate = false

          @connection = nil
          # This is a state variable to allow digest validation of the SSL cert
          bad_cert = false
          loop do
            begin
              @connection = RbVmomi::VIM.new :host => @vsphere_server,
                                             :port => @vsphere_port,
                                             :path => @vsphere_path,
                                             :ns   => @vsphere_ns,
                                             :rev  => @vsphere_rev,
                                             :ssl  => @vsphere_ssl,
                                             :insecure => bad_cert
              break
            rescue OpenSSL::SSL::SSLError
              raise if bad_cert
              bad_cert = true
            end
          end

          if bad_cert then
            validate_ssl_connection
          end

          # Negotiate the API revision
          if not options[:vsphere_rev]
            rev = @connection.serviceContent.about.apiVersion
            @connection.rev = [ rev, ENV['FOG_VSPHERE_REV'] || '4.1' ].min
          end

          @vsphere_is_vcenter = @connection.serviceContent.about.apiType == "VirtualCenter"
          @vsphere_rev = @connection.rev

          authenticate
        end

        private

        def authenticate
          begin
            @connection.serviceContent.sessionManager.Login :userName => @vsphere_username,
                                                            :password => @vsphere_password
          rescue RbVmomi::VIM::InvalidLogin => e
            raise Fog::Vsphere::Errors::ServiceError, e.message
          end
        end

        # Verify a SSL certificate based on the hashed public key
        def validate_ssl_connection
          pubkey = @connection.http.peer_cert.public_key
          pubkey_hash = Digest::SHA2.hexdigest(pubkey.to_s)
          expected_pubkey_hash = @vsphere_expected_pubkey_hash
          if pubkey_hash != expected_pubkey_hash then
            raise Fog::Vsphere::Errors::SecurityError, "The remote system presented a public key with hash #{pubkey_hash} but we're expecting a hash of #{expected_pubkey_hash || '<unset>'}.  If you are sure the remote system is authentic set vsphere_expected_pubkey_hash: <the hash printed in this message> in ~/.fog"
          end
        end

      end

    end
  end
end
