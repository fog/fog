require 'fog/core/collection'
require 'fog/xenserver/models/compute/server'

module Fog
  module Compute
    class XenServer

      class Servers < Fog::Collection

        model Fog::Compute::XenServer::Server

        def templates
          data = service.get_records 'VM'
          data.delete_if do |vm|
            !vm[:is_a_template]
          end
          load(data)
        end

        def custom_templates
          data = service.get_records 'VM'
          data.delete_if do |vm|
            !vm[:is_a_template] or !vm[:other_config]['default_template'].nil?
          end
          load(data)
        end

        def builtin_templates
          data = service.get_records 'VM'
          data.delete_if do |vm|
            !vm[:is_a_template] or vm[:other_config]['default_template'].nil?
          end
          load(data)
        end

        def all(options = {})
          data = service.get_records 'VM'
          # Exclude templates
          data.delete_if { |vm| vm[:is_control_domain] or vm[:is_a_template] }
          data.delete_if { |vm| vm[:is_a_snapshot] and !options[:include_snapshots] }
          data.delete_if { |vm| options[:name_matches] and (vm[:name_label] !~ /#{Regexp.escape(options[:name_matches])}/i ) }
          data.delete_if { |vm| options[:name_equals] and (vm[:name_label] != options[:name_equals] ) }
          load(data)
        end

        def get_by_name( name )
          ref = service.get_vm_by_name( name )
          get ref
        end

        def get_by_uuid( uuid )
          ref = service.get_vm_by_uuid( uuid )
          get ref
        end

        def get( vm_ref )
          if vm_ref && vm = service.get_record( vm_ref, 'VM' )
            new(vm)
          end
        rescue Fog::XenServer::NotFound
          nil
        end

      end

    end
  end
end
