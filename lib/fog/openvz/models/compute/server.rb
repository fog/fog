require 'fog/compute/models/server'

module Fog
  module Compute
    class Openvz
      class Server < Fog::Compute::Server
        identity  :ctid
        attribute :ostemplate
        attribute :config
        attribute :layout
        attribute :hostname
        attribute :name
        attribute :ipadd
        attribute :diskspace
        attribute :private
        attribute :root
        attribute :local_uid
        attribute :local_gid

        attribute :veid
        attribute :vpsid
        attribute :private
        attribute :mount_opts
        attribute :origin_sample
        attribute :smart_name
        attribute :description
        attribute :nameserver
        attribute :searchdomain
        attribute :status
        attribute :simfs
        attribute :cpus
        attribute :vswap
        attribute :disabled
        attribute :ip

        # vzctl create <ctid> [--ostemplate <name>] [--config <name>]
        #    [--layout ploop|simfs] [--hostname <name>] [--name <name>] [--ipadd <addr>]
        #    [--diskspace <kbytes>] [--private <path>] [--root <path>]
        #    [--local_uid <UID>] [--local_gid <GID>]
        def save
          requires :ctid
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          meta_hash = {}
          create_options = {
            'ctid' => ctid,
            'ostemplate' => ostemplate,
            'layout' => layout ,
            'hostname' => hostname,
            'name' => name,
            'ipadd' => ipadd,
            'diskspace' => diskspace,
            'private' => private,
            'root' => root,
            'local_uid' => local_uid,
            'local_gid' => local_gid
          }
          data = service.create_server(create_options)
          reload
        end

        def persisted?
          ctid.nil?
        end

        def public_ip_addresses
          return ip
        end

        def public_ip_address
          if ip.nil?
            return nil
          else
            return ip.first
          end
        end

        def start
          data = service.start_server(ctid)
        end

        def destroy(options = {})
          data = service.destroy_server(ctid, options)
        end

        def mount(options = {})
          data = service.mount_server(ctid, options)
        end

        def umount(options = {})
          data = service.umount_server(ctid, options)
        end

        def stop(options = {})
          data = service.stop_server(ctid, options)
        end

        def reboot(options = {})
          data = service.restart_server(ctid, options)
        end

        alias_method :restart, :reboot

        def convert(options = {})
          data = service.convert_server(ctid, options)
        end

        def compact(options = {})
          data = service.compact_server(ctid, options)
        end

        def snapshot(options = {})
          data = service.snapshot_server(ctid, options)
        end

        def snapshot_switch(options = {})
          data = service.snapshot_switch_server(ctid, options)
        end

        def snapshot_delete(options = {})
          data = service.snapshot_delete_server(ctid, options)
        end

        def snapshot_mount(options = {})
          data = service.snapshot_mount_server(ctid, options)
        end

        def snapshot_umount(options = {})
          data = service.snapshot_umount_server(ctid, options)
        end

        def snapshot_list(options = {})
          data = service.snapshot_list_server(ctid, options)
        end

        def quotaon(options = {})
          data = service.quotaon_server(ctid, options)
        end

        def quotaoff(options = {})
          data = service.quotaoff_server(ctid, options)
        end

        def quotainit(options = {})
          data = service.quotainit_server(ctid, options)
        end

        def exec(args)
          if args.is_a?(String)
            data = service.exec_server(ctid,[ args ])
          else
            data = service.exec_server(ctid,args)
          end
        end

        def exec2(args)
          if args.is_a?(String)
            data = service.exec2_server(ctid,[ args ])
          else
            data = service.exec2_server(ctid,args)
          end
        end

        def runscript(args)
          if args.is_a?(String)
            data = service.runscript_server(ctid,[ args ])
          else
            data = service.runscript_server(ctid,args)
          end
        end

        def suspend(options = {})
          data = service.suspend_server(ctid, options)
        end

        def resume(options = {})
          data = service.resume_server(ctid, options)
        end

        def set(options)
          data = service.set_server(ctid,options)
        end

        def ready?
          status == 'running'
        end
      end
    end
  end
end
