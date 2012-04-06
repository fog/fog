module Fog
  module Compute
    class Vsphere

      module Shared

        # REVISIT:  This is a naive implementation and not very efficient since
        # we find ALL VM's and then iterate over them looking for the managed object
        # reference id...  There should be an easier way to obtain a reference to a
        # VM using only the name or the _ref.  This request is primarily intended to
        # reload the attributes of a cloning VM which does not yet have an instance_uuid
        def find_vm_by_ref(options = {})
          raise ArgumentError, "Must pass a vm_ref option" unless options['vm_ref']

          # This is the inefficient call
          all_vm_attributes = list_virtual_machines['virtual_machines']
          # Find the VM attributes of the reference
          if vm_attributes = all_vm_attributes.find { |vm| vm['mo_ref'] == options['vm_ref'] }
            response = { 'virtual_machine' => vm_attributes }
          else
            raise Fog::Compute::Vsphere::NotFound, "VirtualMachine with Managed Object Reference #{options['vm_ref']} could not be found."
          end
          response
        end

        def get_vm_mob_by_path(options={})
          raise ArgumentError, "Must pass a moid option" unless options['path']
          path_elements = options['path'].split('/').tap { |ary| ary.shift 2 }
          # The DC name itself.
          template_dc = path_elements.shift
          # If the first path element contains "vm" this denotes the vmFolder
          # and needs to be shifted out
          path_elements.shift if path_elements[0] == 'vm'
          # The template name.  The remaining elements are the folders in the
          # datacenter.
          template_name = path_elements.pop
          dc_mob_ref = get_dc_mob_by_path(template_dc)
          vm_mob_ref = dc_mob_ref.find_vm(template_name)
          vm_mob_ref
        end

        def get_vm_mob_by_id(vm_moid)
          raise ArgumentError, "Must pass a vm management object option" unless vm_moid
          vm_mob_ref = RbVmomi::VIM::VirtualMachine.new(@connection,vm_moid)
          vm_mob_ref
        end

        #this is a experimental class and keep for performance checking
        def test_get_vm_mob_by_id()
          array = %w[vm-463 vm-651 vm-490 vm-461 vm-493 vm-477 vm-471 vm-462 vm-499 vm-491 vm-472 vm-500]
          results0 = []
          #puts "type based transfer"

          strTime = Time.now.strftime('%Y%m%d%H%M%S')
          strTv = Time.now.tv_usec
          rand = rand(strTv)
          puts "#{strTime}#{strTv}#{rand}"

          puts "start1"
          t0 = Time.new
          puts t0.to_f
          #puts "#{t.strftime("%Y-%m-%d %H:%M:%S")}:#{t.tv_usec}"
          array.each_index do |i|
            #print "#{array[i]}"
            mob_ref =  RbVmomi::VIM::VirtualMachine.new(@connection,array[i])
            #puts mob_ref
            results0 << mob_ref
          end
          t1 = Time.new
          puts t1.to_f
          puts "end1"

          puts "start2"
          results1 = []
          filterSpec = get_filterSpec_by_type('VirtualMachine')
          #puts filterSpec
          #puts "end1"
          result = @connection.propertyCollector.RetrieveProperties(:specSet => [filterSpec])
          #puts result.to_s
          #puts "end2"
          results = Hash[result.map do |x|
            [x.obj._ref, x.obj]
          end]

          #puts results.to_s
          puts "start2'"
          t2 = Time.new
          puts t2.to_f
          array.each do |i|
            #puts i
            #mob_ref =  results.fetch(i)
            #puts mob_ref
            mob_ref = get_mob_by_id('VirtualMachine',i)
            results1 << mob_ref
          end
          t3 = Time.new
          puts t3.to_f
          puts "end2"
        end

      end # shared

      # The Real and Mock classes share the same method
      # because list_virtual_machines will be properly mocked for us

      class Real
        include Shared
      end

      class Mock
        include Shared
      end

    end
  end
end
