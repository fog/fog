require 'fog/vsphere/core'
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
      model :servertype
      collection :servertypes
      model :datacenter
      collection :datacenters
      model :interface
      collection :interfaces
      model :interfacetype
      collection :interfacetypes
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
      model :customvalue
      collection :customvalues
      model :customfield
      collection :customfields
      model :scsicontroller

      request_path 'fog/vsphere/requests/compute'
      request :current_time
      request :cloudinit_to_customspec
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
      request :list_compute_resources
      request :get_compute_resource
      request :list_templates
      request :get_template
      request :get_folder
      request :list_folders
      request :create_vm
      request :list_vm_interfaces
      request :modify_vm_interface
      request :modify_vm_volume
      request :list_vm_volumes
      request :get_virtual_machine
      request :vm_reconfig_hardware
      request :vm_reconfig_memory
      request :vm_reconfig_cpus
      request :vm_config_vnc
      request :create_folder
      request :list_server_types
      request :get_server_type
      request :list_interface_types
      request :get_interface_type
      request :list_vm_customvalues
      request :list_customfields
      request :get_vm_first_scsi_controller
      request :set_vm_customvalue

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
          :template => 'config.template',
          :parent => 'parent',
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
          :corespersocket   => 'config.hardware.numCoresPerSocket',
          :overall_status => 'overallStatus',
          :guest_id => 'config.guestId',
          :hardware_version => 'config.version',
        }

        def convert_vm_view_to_attr_hash(vms)
          vms = @connection.serviceContent.propertyCollector.collectMultiple(vms,*ATTR_TO_PROP.values.uniq)
          vms.map { |vm| props_to_attr_hash(*vm) }
        end

        # Utility method to convert a VMware managed object into an attribute hash.
        # This should only really be necessary for the real class.
        # This method is expected to be called by the request methods
        # in order to massage VMware Managed Object References into Attribute Hashes.
        def convert_vm_mob_ref_to_attr_hash(vm_mob_ref)
          return nil unless vm_mob_ref

          props = vm_mob_ref.collect!(*ATTR_TO_PROP.values.uniq)
          props_to_attr_hash vm_mob_ref, props
        end

        def props_to_attr_hash vm_mob_ref, props
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
              host = attrs['hypervisor']
              attrs['datacenter'] = Proc.new { parent_attribute(host.path, :datacenter)[1] rescue nil }
              attrs['cluster']    = Proc.new { parent_attribute(host.path, :cluster)[1] rescue nil }
              attrs['hypervisor'] = Proc.new { host.name rescue nil }
              attrs['resource_pool'] = Proc.new {(vm_mob_ref.resourcePool || host.resourcePool).name rescue nil}
            end
            # This inline rescue catches any standard error.  While a VM is
            # cloning, a call to the macs method will throw and NoMethodError
            attrs['mac_addresses'] = Proc.new {vm_mob_ref.macs rescue nil}
            # Rescue nil to catch testing while vm_mob_ref isn't reaL??
            attrs['path'] = "/"+attrs['parent'].path.map(&:last).join('/') rescue nil
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
          obj.to_s.match(/\("([^"]+)"\)/)[1]
        end

        def is_uuid?(id)
          !(id =~ /[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}/).nil?
        end
      end

      class Mock
        include Shared

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :servers => {
                "5032c8a5-9c5e-ba7a-3804-832a03e16381" => {
                 "resource_pool"    => "Resources",
                 "memory_mb"        => 2196,
                 "mac_addresses"    => { "Network adapter 1" => "00:50:56:a9:00:28" },
                 "power_state"      => "poweredOn",
                 "cpus"             => 1,
                 "hostname"         => "dhcp75-197.virt.bos.redhat.com",
                 "mo_ref"           => "vm-562",
                 "connection_state" => "connected",
                 "overall_status"   => "green",
                 "datacenter"       => "Solutions",
                 "volumes"          =>
                    [{
                      "id"        => "6000C29c-a47d-4cd9-5249-c371de775f06",
                      "datastore" => "Storage1",
                      "mode"      => "persistent",
                      "size"      => 8388608,
                      "thin"      => true,
                      "name"      => "Hard disk 1",
                      "filename"  => "[Storage1] rhel6-mfojtik/rhel6-mfojtik.vmdk",
                      "size_gb"   => 8
                     }],
                 "interfaces"       =>
                    [{"mac"     => "00:50:56:a9:00:28",
                      "network" => "VM Network",
                      "name"    => "Network adapter 1",
                      "status"  => "ok",
                      "summary" => "VM Network",
                     }],
                 "hypervisor"       => "gunab.puppetlabs.lan",
                 "guest_id"         => "rhel6_64Guest",
                 "tools_state"      => "toolsOk",
                 "cluster"          => "Solutionscluster",
                 "name"             => "rhel64",
                 "operatingsystem"  => "Red Hat Enterprise Linux 6 (64-bit)",
                 "path"             => "/Datacenters/Solutions/vm",
                 "uuid"             => "4229f0e9-bfdc-d9a7-7bac-12070772e6dc",
                 "instance_uuid"    => "5032c8a5-9c5e-ba7a-3804-832a03e16381",
                 "id"               => "5032c8a5-9c5e-ba7a-3804-832a03e16381",
                 "tools_version"    => "guestToolsUnmanaged",
                 "ipaddress"        => "192.168.100.184",
                 "template"         => false
                },
                "502916a3-b42e-17c7-43ce-b3206e9524dc" => {
                 "resource_pool"    => "Resources",
                 "memory_mb"        => 512,
                 "power_state"      => "poweredOn",
                 "mac_addresses"    => { "Network adapter 1" => "00:50:56:a9:00:00" },
                 "hostname"         => nil,
                 "cpus"             => 1,
                 "connection_state" => "connected",
                 "mo_ref"           => "vm-621",
                 "overall_status"   => "green",
                 "datacenter"       => "Solutions",
                 "volumes"          =>
                    [{"thin"      => false,
                      "size_gb"   => 10,
                      "datastore" => "datastore1",
                      "filename"  => "[datastore1] i-1342439683/i-1342439683.vmdk",
                      "size"      => 10485762,
                      "name"      => "Hard disk 1",
                      "mode"      => "persistent",
                      "id"        => "6000C29b-f364-d073-8316-8e98ac0a0eae" }],
                 "interfaces"       =>
                    [{ "summary" => "VM Network",
                      "mac"     => "00:50:56:a9:00:00",
                      "status"  => "ok",
                      "network" => "VM Network",
                      "name"    => "Network adapter 1" }],
                 "hypervisor"       => "gunab.puppetlabs.lan",
                 "guest_id"         => nil,
                 "cluster"          => "Solutionscluster",
                 "tools_state"      => "toolsNotInstalled",
                 "name"             => "i-1342439683",
                 "operatingsystem"  => nil,
                 "path"             => "/",
                 "tools_version"    => "guestToolsNotInstalled",
                 "uuid"             => "4229e0de-30cb-ceb2-21f9-4d8d8beabb52",
                 "instance_uuid"    => "502916a3-b42e-17c7-43ce-b3206e9524dc",
                 "id"               => "502916a3-b42e-17c7-43ce-b3206e9524dc",
                 "ipaddress"        => nil,
                 "template"         => false
                },
                "5029c440-85ee-c2a1-e9dd-b63e39364603" => {
                 "resource_pool"    => "Resources",
                 "memory_mb"        => 2196,
                 "power_state"      => "poweredOn",
                 "mac_addresses"    => { "Network adapter 1" => "00:50:56:b2:00:af" },
                 "hostname"         => "centos56gm.localdomain",
                 "cpus"             => 1,
                 "connection_state" => "connected",
                 "mo_ref"           => "vm-715",
                 "overall_status"   => "green",
                 "datacenter"       => "Solutions",
                 "hypervisor"       => "gunab.puppetlabs.lan",
                 "guest_id"         => "rhel6_64Guest",
                 "cluster"          => "Solutionscluster",
                 "tools_state"      => "toolsOk",
                 "name"             => "jefftest",
                 "operatingsystem"  => "Red Hat Enterprise Linux 6 (64-bit)",
                 "path"             => "/",
                 "tools_version"    => "guestToolsUnmanaged",
                 "ipaddress"        => "192.168.100.187",
                 "uuid"             => "42329da7-e8ab-29ec-1892-d6a4a964912a",
                 "instance_uuid"    => "5029c440-85ee-c2a1-e9dd-b63e39364603",
                 "id"               => "5029c440-85ee-c2a1-e9dd-b63e39364603",
                 "template"         => false
                }
              },
              :datacenters => {
                "Solutions" => {:name => "Solutions", :status => "grey"}
              },
              :clusters =>
                [{:id => "1d4d9a3f-e4e8-4c40-b7fc-263850068fa4",
                  :name => "Solutionscluster",
                  :num_host => "4",
                  :num_cpu_cores => "16",
                  :overall_status => "green",
                  :datacenter => "Solutions",
                  :klass => "RbVmomi::VIM::ComputeResource"
                 },
                 {:id => "e4195973-102b-4096-bbd6-5429ff0b35c9",
                  :name => "Problemscluster",
                  :num_host => "4",
                  :num_cpu_cores => "32",
                  :overall_status => "green",
                  :datacenter => "Solutions",
                  :klass => "RbVmomi::VIM::ComputeResource"
                 },
                 {
                   :klass => "RbVmomi::VIM::Folder",
                   :clusters => [{:id => "03616b8d-b707-41fd-b3b5-The first",
                                  :name => "Problemscluster",
                                  :num_host => "4",
                                  :num_cpu_cores => "32",
                                  :overall_status => "green",
                                  :datacenter => "Solutions",
                                  :klass => "RbVmomi::VIM::ComputeResource"
                                 },
                                 {:id => "03616b8d-b707-41fd-b3b5-the Second",
                                  :name => "Lastcluster",
                                  :num_host => "8",
                                  :num_cpu_cores => "32",
                                  :overall_status => "green",
                                  :datacenter => "Solutions",
                                  :klass => "RbVmomi::VIM::ComputeResource"}
                   ]
                 }
                ]
            }
          end
        end

        def initialize(options={})
          require 'rbvmomi'
          @vsphere_username = options[:vsphere_username]
          @vsphere_password = 'REDACTED'
          @vsphere_server   = options[:vsphere_server]
          @vsphere_expected_pubkey_hash = options[:vsphere_expected_pubkey_hash]
          @vsphere_is_vcenter = true
          @vsphere_rev = '4.0'
        end

        def data
          self.class.data[@vsphere_username]
        end

        def reset_data
          self.class.data.delete(@vsphere_username)
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
          @vsphere_is_vcenter = nil
          @connection = nil
          connect
          negotiate_revision(options[:vsphere_rev])
          authenticate
        end

        def reload
          connect
          # Check if the negotiation was ever run
          if @vsphere_is_vcenter.nil?
            negotiate
          end
          authenticate
        end

        private
        def negotiate_revision(revision = nil)
          # Negotiate the API revision
          if not revision
            rev = @connection.serviceContent.about.apiVersion
            @connection.rev = [ rev, ENV['FOG_VSPHERE_REV'] || '4.1' ].min
          end

          @vsphere_is_vcenter = @connection.serviceContent.about.apiType == "VirtualCenter"
          @vsphere_rev = @connection.rev
        end

        def connect
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
        end

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
