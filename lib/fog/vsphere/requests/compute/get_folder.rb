module Fog
  module Compute
    class Vsphere
      class Real
        def get_folder(path, datacenter_name, type = nil)
          type ||= 'vm'

          # Cycle through all types of folders.
          case type
            when 'vm', :vm
              # if you're a vm then grab the VM.
              folder = get_raw_vmfolder(path, datacenter_name)
              raise(Fog::Compute::Vsphere::NotFound) unless folder
              folder_attributes(folder, datacenter_name)
            when 'network', :network
              raise "not implemented"
            when 'datastore', :datastore
              raise "not implemented"
            else
              raise ArgumentError, "#{type} is unknown"
          end
        end

        protected

        def get_raw_vmfolder(path, datacenter_name)
          # The required path syntax - 'topfolder/subfolder

          # Clean up path to be relative since we're providing datacenter name
          dc             = find_raw_datacenter(datacenter_name)
          dc_root_folder = dc.vmFolder
          # Filter the root path for this datacenter not to be used."
          dc_root_folder_path=dc_root_folder.path.map { | id, name | name }.join("/")
          paths          = path.sub(/^\/?#{Regex.quote(dc_root_folder_path)}\/?/, '').split('/')

          return dc_root_folder if paths.empty?
          # Walk the tree resetting the folder pointer as we go
          paths.inject(dc_root_folder) do |last_returned_folder, sub_folder|
            # JJM VIM::Folder#find appears to be quite efficient as it uses the
            # searchIndex It certainly appears to be faster than
            # VIM::Folder#inventory since that returns _all_ managed objects of
            # a certain type _and_ their properties.
            sub = last_returned_folder.find(sub_folder, RbVmomi::VIM::Folder)
            raise ArgumentError, "Could not descend into #{sub_folder}.  Please check your path. #{path}" unless sub
            sub
          end
        end

        def folder_attributes(folder, datacenter_name)
          {
            :id         => managed_obj_id(folder),
            :name       => folder.name,
            :parent     => folder.parent.name,
            :datacenter => datacenter_name,
            :type       => folder_type(folder),
            :path       => "/"+folder.path.map(&:last).join('/'),
          }
        end

        def folder_type(folder)
          types = folder.childType
          return :vm        if types.include?('VirtualMachine')
          return :network   if types.include?('Network')
          return :datastore if types.include?('Datastore')
        end
      end

      class Mock
        def get_folder(path, filters = { })
        end
      end

    end
  end
end
