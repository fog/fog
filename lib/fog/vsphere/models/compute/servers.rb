# Copyright (c) 2012 VMware, Inc. All Rights Reserved.
#
#      Licensed under the Apache License, Version 2.0 (the "License");
#
#   you may not use this file except in compliance with the License.
#
#   You may obtain a copy of the License at
#
#
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#
#
#
#   Unless required by applicable law or agreed to in writing, software
#
#   distributed under the License is distributed on an "AS IS" BASIS,
#
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
#   See the License for the specific language governing permissions and
#
#   limitations under the License.


require 'fog/core/collection'
require 'fog/vsphere/models/compute/server'

module Fog
  module Compute
    class Vsphere

      class Servers < Fog::Collection

        model Fog::Compute::Vsphere::Server

        # Public: list all vms in the given folder
        # folder - 'folder_path' will work as a filter.
        # if empty arguments then simply listing everything.
        #
        # Returns the vm array
        def all(filters = {})
          # REVISIT: I'm not sure if this is the best way to implement search
          # filters on a collection but it does work.  I need to study the AWS
          # code more to make sure this matches up.
          filters['folder'] ||= attributes['folder']
          response = connection.list_virtual_machines(filters)
          load(response['virtual_machines'])
        end

        # Public: get vm with given id
        # id - can be vm management object id or instance_uuid
        #
        # Returns the server object with given id
        def get(id)
          # Is the id a managed_object_reference?  This may be the case if we're reloading
          # a model of a VM in the process of being cloned, since it
          # will not have a instance_uuid yet.
          if id =~ /^vm-/
            response = connection.find_vm_by_ref('vm_ref' => id)
            server_attributes = response['virtual_machine']
          else
            response = connection.list_virtual_machines('instance_uuid' => id)
            server_attributes = response['virtual_machines'].first
          end
          new(server_attributes)
        rescue Fog::Compute::Vsphere::NotFound
          nil
        end

      end

    end
  end
end
