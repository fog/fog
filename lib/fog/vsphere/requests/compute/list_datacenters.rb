module Fog
  module Compute
    class Vsphere
      class Real
        def list_datacenters filters = {}
          raw_datacenters.map do |dc|
            {
              :id => managed_obj_id(dc),
              :name => dc.name,
              :path => raw_getpathmo(dc),
              :status => dc.overallStatus
            }
          end
        end

        protected

        def raw_getpathmo mo
          if mo.parent == nil or mo.parent.name == @connection.rootFolder.name then
            [ mo.name ]
          else
            [ raw_getpathmo(mo.parent), mo.name ].flatten
          end
        end

        def raw_datacenters folder=nil
          folder ||= @connection.rootFolder
          @raw_datacenters ||= get_raw_datacenters_from_folder folder
        end

        def get_raw_datacenters_from_folder folder=nil
          folder.childEntity.map do | childE |
            if childE.is_a? RbVmomi::VIM::Datacenter
               childE
            elsif childE.is_a? RbVmomi::VIM::Folder
               get_raw_datacenters_from_folder childE
            end
          end.flatten
        end

        def find_datacenters name=nil
          name ? [find_raw_datacenter(name)] : raw_datacenters
        end
      end

      class Mock
        def list_datacenters filters = {}
          [ {:name => "Solutions", :status => "grey"}, {:name => "Solutions2", :status => "green" }]
        end
      end
    end
  end
end
