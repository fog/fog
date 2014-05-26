module Fog
  module Compute
    class Vsphere
      class Real
        # Grabs all sub folders within a given path folder.
        #
        # ==== Parameters
        # * filters<~Hash>:
        #   * :datacenter<~String> - *REQUIRED* Your datacenter where you're
        #     looking for folders. Example: 'my-datacenter-name' (passed if you
        #     are using the models/collections)
        #       eg: vspconn.datacenters.first.vm_folders('mypath')
        #   * :path<~String> - Your path where you're looking for
        #     more folders, if return = none you will get an error. If you don't
        #     define it will look in the main datacenter folder for any folders
        #     in that datacenter.
        #
        # Example Usage Testing Only:
        #  vspconn = Fog::Compute[:vsphere]
        #  mydc = vspconn.datacenters.first
        #  folders = mydc.vm_folders
        #
        def list_folders(filters = { })
          path            = filters[:path] || filters['path'] || ''
          datacenter_name = filters[:datacenter]
          get_raw_vmfolders(path, datacenter_name).map do |folder|
            folder_attributes(folder, datacenter_name)
          end
        end

        protected

        def get_raw_vmfolders(path, datacenter_name)
          folder = get_raw_vmfolder(path, datacenter_name)
          child_folders(folder).flatten.compact
        end

        def child_folders folder
          [folder, folder.childEntity.grep(RbVmomi::VIM::Folder).map(&method(:child_folders)).flatten]
        end
      end
    end
  end
end
