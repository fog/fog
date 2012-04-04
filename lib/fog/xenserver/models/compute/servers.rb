require 'fog/core/collection'
require 'fog/xenserver/models/compute/server'

module Fog
  module Compute
    class XenServer

      class Servers < Fog::Collection

        model Fog::Compute::XenServer::Server

        def all(options = {})
          data = connection.get_records 'VM'
          # Exclude templates
          data.delete_if { |vm| 
            vm[:is_a_template] and (!options[:include_templates] and !options[:include_custom_templates])
          }
          data.delete_if { |vm| 
            # VM is a custom template
            if vm[:is_a_template] and vm[:allowed_operations].include?("destroy")
              !options[:include_custom_templates]
            end
          }
          data.delete_if { |vm| 
            # VM is a built-in template
            if vm[:is_a_template] and !vm[:allowed_operations].include?("destroy")
              !options[:include_templates]
            end
          }
          data.delete_if { |vm| vm[:is_control_domain] }
          data.delete_if { |vm| vm[:is_a_snapshot] and !options[:include_snapshots] }
          data.delete_if { |vm| options[:name_matches] and (vm[:name_label] !~ /#{Regexp.escape(options[:name_matches])}/i ) }
          data.delete_if { |vm| options[:name_equals] and (vm[:name_label] != options[:name_equals] ) }
          load(data)
        end

        def get_by_name( name )
          all(:name_equals => name).first
        end

        def get( vm_ref )
          if vm_ref && vm = connection.get_record( vm_ref, 'VM' )
            new(vm)
          end
        rescue Fog::XenServer::NotFound
          nil
        end

      end

    end
  end
end
