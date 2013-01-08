module Fog
  module Compute
    class Vsphere
      class Real
        def create_folder(datacenter, path, name)
          #Path cannot be nil but it can be an empty string
          raise ArgumentError, "Path cannot be nil" if path.nil?

          parent_folder = get_raw_vmfolder(path, datacenter)
          begin
            new_folder = parent_folder.CreateFolder(:name => name)
            # output is cleaned up to return the new path
            # new path will be path/name, example: "Production/Pool1"
            new_folder.path.reject { |a| a.first.class == "Folder" }.collect { |a| a.first.name }.join("/").sub(/^\/?Datacenters\/#{datacenter}\/vm\/?/, '')
          rescue => e
            raise e, "failed to create folder: #{e}"
          end
        end
      end
    end
  end
end
