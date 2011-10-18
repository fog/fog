require 'fog/core/model'

module Fog
  module Compute
    class VirtualBox

      class Server < Fog::Model

        identity :id

        attribute :description
        attribute :memory_size
        attribute :name
        attribute :os,          :aliases => :os_type_id
        attribute :rtc_use_utc
        attribute :session_state
        attribute :status,      :aliases => :state
        attribute :vram_size

        # property :accelerate_2d_video_enabled, T_BOOL
        # property :accelerate_3d_enabled, T_BOOL
        # property :access_error, :VirtualBoxErrorInfo, :readonly => true
        # property :accessible, T_BOOL, :readonly => true
        # property :audio_adapter, :AudioAdapter, :readonly => true
        # property :bandwidth_control, :BandwidthControl, :readonly => true
        # property :bios_settings, :BIOSSettings, :readonly => true
        # property :chipset_type, :ChipsetType
        # property :clipboard_mode, :ClipboardMode
        # property :cpu_count, T_UINT32
        # property :cpu_execution_cap, T_UINT64
        # property :cpu_hot_plug_enabled, T_BOOL
        # property :current_snapshot, :Snapshot, :readonly => true
        # property :current_state_modified, T_BOOL, :readonly => true
        # property :fault_tolerance_address, WSTRING
        # property :fault_tolerance_password, WSTRING
        # property :fault_tolerance_port, T_UINT64
        # property :fault_tolerance_state, :FaultToleranceState
        # property :fault_tolerance_sync_interval, T_UINT64
        # property :firmware_type, :FirmwareType
        # property :guest_property_notification_patterns, WSTRING
        # property :hardware_uuid, WSTRING
        # property :hardware_version, WSTRING
        # property :hpet_enabled, T_BOOL
        # property :io_cache_enabled, T_BOOL
        # property :io_cache_size, T_UINT32
        # property :keyboard_hid_type, T_UINT32
        # property :last_state_change, T_INT64, :readonly => true
        # property :log_folder, WSTRING, :readonly => true
        # property :medium_attachments, [:MediumAttachment], :readonly => true
        # property :memory_balloon_size, T_UINT64
        # property :monitor_count, T_UINT64
        # property :page_fusion_enabled, T_BOOL
        # property :parent, :VirtualBox, :readonly => true
        # property :pci_device_assignments, [:PciDeviceAttachment], :readonly => true
        # property :pointing_hid_type, T_UINT32
        # property :session_pid, T_UINT64, :readonly => true
        # property :session_type, WSTRING, :readonly => true
        # property :settings_file_path, WSTRING, :readonly => true
        # property :settings_modified, T_BOOL, :readonly => true
        # property :shared_folders, [:SharedFolder], :readonly => true
        # property :snapshot_count, T_UINT32, :readonly => true
        # property :snapshot_folder, WSTRING
        # property :state_file_path, WSTRING, :readonly => true
        # property :storage_controllers, [:StorageController], :readonly => true
        # property :teleporter_address, WSTRING
        # property :teleporter_enabled, T_BOOL
        # property :teleporter_password, WSTRING
        # property :teleporter_port, T_UINT32
        # property :usb_controller, :USBController, :readonly => true
        # property :vrde_server, :VRDEServer, :readonly => true

        attr_writer :private_key, :private_key_path, :public_key, :public_key_path, :username

        def initialize(attributes={})
          self.memory_size = 256
          self.rtc_use_utc = true
          self.vram_size   = 8
          super
        end

        def destroy
          requires :name, :raw
          unless raw.state == :powered_off
            stop
            wait_for { raw.session_state == :closed }
          end
          raw.unregister(:full)
          config_file = connection.compose_machine_filename(name)
          config_directory = config_file.split(File::SEPARATOR)[0...-1].join(File::SEPARATOR)
          FileUtils.rm_rf(config_directory)
          true
        end

        def network_adapters
          Fog::Compute::VirtualBox::NetworkAdapters.new(
            :connection => connection,
            :machine => self
          )
        end

        def private_ip_address
          nil
        end

        def private_key_path
          @private_key_path ||= Fog.credentials[:private_key_path]
          @private_key_path &&= File.expand_path(@private_key_path)
        end

        def private_key
          @private_key ||= private_key_path && File.read(private_key_path)
        end

        def public_ip_address
          nil
        end

        def public_key_path
          @public_key_path ||= Fog.credentials[:public_key_path]
          @public_key_path &&= File.expand_path(@public_key_path)
        end

        def public_key
          @public_key ||= public_key_path && File.read(public_key_path)
        end

        def ready?
          status == :running
        end

        def reboot
          requires :raw
          session.console.reset
          true
        end

        def save
          unless identity
            requires :name, :os
            self.raw = connection.create_machine(nil, name, os)
            connection.register_machine(raw)
            with_session do |session|
              for attribute in [:description, :memory_size, :rtc_use_utc, :vram_size]
                session.machine.send(:"#{attribute}=", attributes[attribute])
              end
              session.machine.save_settings
            end
            true
          else
            raise Fog::Errors::Error.new('Updating an existing server is not yet implemented. Contributions welcome!')
          end
        end

        def scp(local_path, remote_path, upload_options = {})
          raise 'Not Implemented'
          # requires :addresses, :username
          #
          # options = {}
          # options[:key_data] = [private_key] if private_key
          # Fog::SCP.new(addresses['public'].first, username, options).upload(local_path, remote_path, scp_options)
        end

        def setup(credentials = {})
          raise 'Not Implemented'
        #   requires :addresses, :identity, :public_key, :username
        #   Fog::SSH.new(addresses['public'].first, username, credentials).run([
        #     %{mkdir .ssh},
        #     %{echo "#{public_key}" >> ~/.ssh/authorized_keys},
        #     %{passwd -l #{username}},
        #     %{echo "#{MultiJson.encode(attributes)}" >> ~/attributes.json},
        #     %{echo "#{MultiJson.encode(metadata)}" >> ~/metadata.json}
        #   ])
        # rescue Errno::ECONNREFUSED
        #   sleep(1)
        #   retry
        end

        def ssh(commands)
          raise 'Not Implemented'
          # requires :addresses, :identity, :username
          #
          # options = {}
          # options[:key_data] = [private_key] if private_key
          # Fog::SSH.new(addresses['public'].first, username, options).run(commands)
        end

        def start(type = 'headless')
          requires :raw
          # session, type in ['gui', 'headless'], key[=value]\n env variables
          raw.launch_vm_process(session, type, '').wait
          true
        end

        def stop
          requires :raw
          session.console.power_down.wait
          true
        end

        def storage_controllers
          Fog::Compute::VirtualBox::StorageControllers.new(
            :connection => connection,
            :machine    => self
          )
        end

        def username
          @username ||= 'root'
        end

        private

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw
          raw_attributes = {}
          for key in [:id, :description, :memory_size, :name, :os_type_id, :state]
            raw_attributes[key] = @raw.send(key)
          end
          merge_attributes(raw_attributes)
        end

        def session
          ::VirtualBox::Lib.lib.session
        end

        def with_session
          raw.lock_machine(session, :write)
          yield session
          session.unlock_machine
        end

      end

    end
  end

end
