require 'fog/compute/models/server'
require 'fog/libvirt/models/compute/util/util'
require 'net/ssh/proxy/command'

module Fog
  module Compute
    class Libvirt

      class Server < Fog::Compute::Server

        include Fog::Compute::LibvirtUtil
        attr_reader :xml

        identity :id, :aliases => 'uuid'

        attribute :cpus
        attribute :cputime
        attribute :os_type
        attribute :memory_size
        attribute :max_memory_size
        attribute :name
        attribute :arch
        attribute :persistent
        attribute :domain_type
        attribute :uuid
        attribute :autostart
        attribute :nics
        attribute :volumes
        attribute :active
        attribute :boot_order
        attribute :display

        attribute :state

        # The following attributes are only needed when creating a new vm
        #TODO: Add depreciation warning
        attr_accessor :iso_dir, :iso_file
        attr_accessor :network_interface_type ,:network_nat_network, :network_bridge_name
        attr_accessor :volume_format_type, :volume_allocation,:volume_capacity, :volume_name, :volume_pool_name, :volume_template_name, :volume_path
        attr_accessor :password
        attr_writer   :private_key, :private_key_path, :public_key, :public_key_path, :username

        # Can be created by passing in :xml => "<xml to create domain/server>"
        # or by providing :template_options => {
        #                :name => "", :cpus => 1, :memory_size => 256 , :volume_template
        #   }

        def initialize(attributes={} )
          @xml = attributes.delete(:xml)
          verify_boot_order(attributes[:boot_order])
          super defaults.merge(attributes)
          initialize_nics
          initialize_volumes
        end

        def new?
          uuid.nil?
        end

        def save
          raise Fog::Errors::Error.new('Saving an existing server may create a duplicate') unless new?
          create_or_clone_volume unless xml or @volumes
          @xml ||= to_xml
          self.id = (persistent ? connection.define_domain(xml) : connection.create_domain(xml)).uuid
          reload
        rescue => e
          raise Fog::Errors::Error.new("Error saving the server: #{e}")
        end

        def username
          @username ||= 'root'
        end

        def start
          return true if active?
          connection.vm_action(uuid, :create)
          reload
          true
        end

        def mac
          nics.first.mac if nics && nics.first
        end

        def disk_path
          volumes.first.path if volumes and volumes.first
        end

        def destroy(options={ :destroy_volumes => false})
          poweroff unless stopped?
          connection.vm_action(uuid, :undefine)
          volumes.each { |vol| vol.destroy } if options[:destroy_volumes]
          true
        end

        def reboot
          connection.vm_action(uuid, :reboot)
        end

        def poweroff
          connection.vm_action(uuid, :destroy)
        end

        def shutdown
          connection.vm_action(uuid, :shutdown)
        end

        def resume
          connection.vm_action(uuid, :resume)
        end

        def suspend
          connection.vm_action(uuid, :suspend)
        end

        def stopped?
          state == "shutoff"
        end

        def ready?
          state == "running"
        end

        #alias methods
        alias :halt    :poweroff
        alias :stop    :shutdown
        alias :active? :active

        def volumes
          # lazy loading of volumes
          @volumes ||= (@volumes_path || []).map{|path| connection.volumes.all(:path => path).first }
        end

        def private_ip_address
          ip_address(:private)
        end

        def public_ip_address
          ip_address(:public)
        end

        def private_key_path
          @private_key_path ||= Fog.credentials[:private_key_path]
          @private_key_path &&= File.expand_path(@private_key_path)
        end

        def private_key
          @private_key ||= private_key_path && File.read(private_key_path)
        end

        def public_key_path
          @public_key_path ||= Fog.credentials[:public_key_path]
          @public_key_path &&= File.expand_path(@public_key_path)
        end

        def public_key
          @public_key ||= public_key_path && File.read(public_key_path)
        end

        def ssh(commands)
          requires :public_ip_address, :username

          #requires :password, :private_key
          ssh_options={}
          ssh_options[:password] = password unless password.nil?
          ssh_options[:key_data] = [private_key] if private_key
          ssh_options[:proxy]= ssh_proxy unless ssh_proxy.nil?

          Fog::SSH.new(public_ip_address, @username, ssh_options).run(commands)

        end

        def ssh_proxy
          # if this is a direct connection, we don't need a proxy to be set.
          return nil unless @connection.uri.ssh_enabled?
          user_string= connection.uri.user ? "-l #{connection.uri.user}" : ""
          Net::SSH::Proxy::Command.new("ssh #{user_string} #{connection.uri.host} nc %h %p")
        end

        # Transfers a file
        def scp(local_path, remote_path, upload_options = {})
          requires :public_ip_address, :username

          scp_options = {}
          scp_options[:password] = password unless self.password.nil?
          scp_options[:key_data] = [private_key] if self.private_key
          scp_options[:proxy]= ssh_proxy unless self.ssh_proxy.nil?

          Fog::SCP.new(public_ip_address, username, scp_options).upload(local_path, remote_path, upload_options)
        end

        # Sets up a new key
        def setup(credentials = {})
          requires :public_key, :public_ip_address, :username

          credentials[:proxy]= ssh_proxy unless ssh_proxy.nil?
          credentials[:password] = password unless self.password.nil?
          credentails[:key_data] = [private_key] if self.private_key

          commands = [
            %{mkdir .ssh},
            #              %{passwd -l #{username}}, #Not sure if we need this here
            #              %{echo "#{Fog::JSON.encode(attributes)}" >> ~/attributes.json}
          ]
          if public_key
            commands << %{echo "#{public_key}" >> ~/.ssh/authorized_keys}
          end

          # wait for domain to be ready
          Timeout::timeout(360) do
            begin
              Timeout::timeout(8) do
                Fog::SSH.new(public_ip_address, username, credentials.merge(:timeout => 4)).run('pwd')
              end
            rescue Errno::ECONNREFUSED
              sleep(2)
              retry
            rescue Net::SSH::AuthenticationFailed, Timeout::Error
              retry
            end
          end
          Fog::SSH.new(public_ip_address, username, credentials).run(commands)
        end

        def update_display attrs = {}
          connection.update_display attrs.merge(:uuid => uuid)
          reload
        end

        # can't use deprecate method, as the value is part of the display hash
        def vnc_port
          Fog::Logger.deprecation("#{self.class} => #vnc_port is deprecated, use #display[:port] instead [light_black](#{caller.first})[/]")
          display[:port]
        end

        private
        attr_accessor :volumes_path

        # This retrieves the ip address of the mac address
        # It returns an array of public and private ip addresses
        # Currently only one ip address is returned, but in the future this could be multiple
        # if the server has multiple network interface
        def addresses(connection=connection, options={})
          mac=self.mac

          # Aug 24 17:34:41 juno arpwatch: new station 10.247.4.137 52:54:00:88:5a:0a eth0.4
          # Aug 24 17:37:19 juno arpwatch: changed ethernet address 10.247.4.137 52:54:00:27:33:00 (52:54:00:88:5a:0a) eth0.4
          # Check if another ip_command string was provided
          ip_command_global=connection.ip_command.nil? ? 'grep $mac /var/log/arpwatch.log|sed -e "s/new station//"|sed -e "s/changed ethernet address//g" |sed -e "s/reused old ethernet //" |tail -1 |cut -d ":" -f 4-| cut -d " " -f 3' : connection.ip_command
          ip_command_local=options[:ip_command].nil? ? ip_command_global : options[:ip_command]

          ip_command="mac=#{mac}; server_name=#{name}; "+ip_command_local

          ip_address=nil

          if connection.uri.ssh_enabled?

            # Retrieve the parts we need from the connection to setup our ssh options
            user=connection.uri.user #could be nil
            host=connection.uri.host
            keyfile=connection.uri.keyfile
            port=connection.uri.port

            # Setup the options
            ssh_options={}
            ssh_options[:keys]=[ keyfile ] unless keyfile.nil?
            ssh_options[:port]=port unless keyfile.nil?
            ssh_options[:paranoid]=true if connection.uri.no_verify?


            begin
              result=Fog::SSH.new(host, user, ssh_options).run(ip_command)
            rescue Errno::ECONNREFUSED
              raise Fog::Errors::Error.new("Connection was refused to host #{host} to retrieve the ip_address for #{mac}")
            rescue Net::SSH::AuthenticationFailed
              raise Fog::Errors::Error.new("Error authenticating over ssh to host #{host} and user #{user}")
            end


            # Check for a clean exit code
            if result.first.status == 0
              ip_address=result.first.stdout.strip
            else
              # We got a failure executing the command
              raise Fog::Errors::Error.new("The command #{ip_command} failed to execute with a clean exit code")
            end

          else
            # It's not ssh enabled, so we assume it is
            if connection.uri.transport=="tls"
              raise Fog::Errors::Error.new("TlS remote transport is not currently supported, only ssh")
            end

            # Execute the ip_command locally
            # Initialize empty ip_address string
            ip_address=""

            IO.popen("#{ip_command}") do |p|
              p.each_line do |l|
                ip_address+=l
              end
              status=Process.waitpid2(p.pid)[1].exitstatus
              if status!=0
                raise Fog::Errors::Error.new("The command #{ip_command} failed to execute with a clean exit code")
              end
            end

            #Strip any new lines from the string
            ip_address=ip_address.chomp
          end


          # The Ip-address command has been run either local or remote now

          if ip_address==""
            #The grep didn't find an ip address result"
            ip_address=nil
          else
            # To be sure that the command didn't return another random string
            # We check if the result is an actual ip-address
            # otherwise we return nil
            unless ip_address=~/^(\d{1,3}\.){3}\d{1,3}$/
              raise Fog::Errors::Error.new(
                        "The result of #{ip_command} does not have valid ip-address format\n"+
                            "Result was: #{ip_address}\n"
                    )
            end
          end

          return { :public => [ip_address], :private => [ip_address]}
        end

        def ip_address(key)
          addresses[key].nil? ? nil : addresses[key].first
        end

        def initialize_nics
          if nics
            nics.map! { |nic| nic.is_a?(Hash) ? connection.nics.new(nic) : nic }
          else
            self.nics = [connection.nics.new({:type => network_interface_type, :bridge => network_bridge_name, :network => network_nat_network})]
          end
        end

        def initialize_volumes
          if attributes[:volumes] && !attributes[:volumes].empty?
            @volumes = attributes[:volumes].map { |vol| vol.is_a?(Hash) ? connection.volumes.new(vol) : vol }
          end
        end

        def create_or_clone_volume
          options = {:name => volume_name || default_volume_name}
          # Check if a disk template was specified
          if volume_template_name
            template_volume = connection.volumes.all(:name => volume_template_name).first
            raise Fog::Errors::Error.new("Template #{volume_template_name} not found") unless template_volume
            begin
              volume = template_volume.clone("#{options[:name]}")
            rescue => e
              raise Fog::Errors::Error.new("Error creating the volume : #{e}")
            end
          else
            # If no template volume was given, let's create our own volume
            options[:format_type] = volume_format_type if volume_format_type
            options[:capacity]    = volume_capacity    if volume_capacity
            options[:allocation]  = volume_allocation  if volume_allocation

            begin
              volume = connection.volumes.create(options)
            rescue => e
              raise Fog::Errors::Error.new("Error creating the volume : #{e}")
            end
          end
          @volumes.nil? ? @volumes = [volume] : @volumes << volume
        end

        def default_iso_dir
          "/var/lib/libvirt/images"
        end

        def default_volume_name
          "#{name}.#{volume_format_type || 'img'}"
        end

        def defaults
          {
            :persistent             => true,
            :cpus                   => 1,
            :memory_size            => 256 *1024,
            :name                   => randomized_name,
            :os_type                => "hvm",
            :arch                   => "x86_64",
            :domain_type            => "kvm",
            :iso_dir                => default_iso_dir,
            :network_interface_type => "network",
            :network_nat_network    => "default",
            :network_bridge_name    => "br0",
            :boot_order             => default_boot_order,
            :display                => default_display
          }
        end

        def default_boot_order
          %w[hd cdrom network]
        end

        def verify_boot_order order = []
          if order
            order.each do |b|
              raise "invalid boot order, possible values are: hd, network and/or cdrom" unless default_boot_order.include?(b)
            end
          end
        end

        def default_display
          {:port => '-1', :listen => '127.0.0.1', :type => 'vnc', :password => '' }
        end

      end

    end
  end

end
