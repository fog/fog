module Fog
  module Generators
    module Compute
      module VcloudDirector
        # This is the data structure it accepts, this is the output of
        # #get_vm_disks:
        #
        #   {:disks=>
        #    [{:address=>0,
        #      :description=>"SCSI Controller",
        #      :name=>"SCSI Controller 0",
        #      :id=>2,
        #      :resource_sub_type=>"VirtualSCSI",
        #      :resource_type=>6},
        #     {:address_on_parent=>0,
        #      :description=>"Hard disk",
        #      :name=>"Hard disk 1",
        #      :id=>2000,
        #      :parent=>2,
        #      :resource_type=>17,
        #      :capacity=>16384,
        #      :bus_sub_type=>"VirtualSCSI",
        #      :bus_type=>6},
        #     {:address=>0,
        #      :description=>"IDE Controller",
        #      :name=>"IDE Controller 0",
        #      :id=>3,
        #      :resource_type=>5}]}
        #
        # This is what it generates:
        #
        #   <vcloud:RasdItemsList xmlns:vcloud="http://www.vmware.com/vcloud/v1.5"
        #     xmlns:rasd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData"
        #     type="application/vnd.vmware.vcloud.rasdItemsList+xml">
        #     <vcloud:Item>
        #       <rasd:Address>0</rasd:Address>
        #       <rasd:Description>SCSI Controller</rasd:Description>
        #       <rasd:ElementName>SCSI Controller 0</rasd:ElementName>
        #       <rasd:InstanceID>2</rasd:InstanceID>
        #       <rasd:ResourceSubType>VirtualSCSI</rasd:ResourceSubType>
        #       <rasd:ResourceType>6</rasd:ResourceType>
        #     </vcloud:Item>
        #     <vcloud:Item>
        #       <rasd:AddressOnParent>0</rasd:AddressOnParent>
        #       <rasd:Description>Hard disk</rasd:Description>
        #       <rasd:ElementName>Hard disk 1</rasd:ElementName>
        #       <rasd:HostResource vcloud:capacity="16384" vcloud:busSubType="VirtualSCSI" vcloud:busType="6"></rasd:HostResource>
        #       <rasd:InstanceID>2000</rasd:InstanceID>
        #       <rasd:Parent>2</rasd:Parent>
        #       <rasd:ResourceType>17</rasd:ResourceType>
        #     </vcloud:Item>
        #     <vcloud:Item>
        #       <rasd:Address>0</rasd:Address>
        #       <rasd:Description>IDE Controller</rasd:Description>
        #       <rasd:ElementName>IDE Controller 0</rasd:ElementName>
        #       <rasd:InstanceID>3</rasd:InstanceID>
        #       <rasd:ResourceType>5</rasd:ResourceType>
        #     </vcloud:Item>
        #   </vcloud:RasdItemsList>
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/RasdItemsListType.html
        class Disks
          def initialize(items=[])
            @items = items[:disks]
          end

          def modify_hard_disk_size(disk_number, new_size)
            found = false
            @items.each do |item|
              if item[:resource_type] == 17
                if item[:name] == "Hard disk #{disk_number}"
                  found = true
                  raise "Hard disk size can't be reduced" if item[:capacity].to_i > new_size.to_i
                  item[:capacity] = new_size
                end
              end
            end
            raise "Hard disk #{disk_number} not found" unless found
            true
          end

          def add_hard_disk(size)
            new_hard_disk = last_hard_disk.dup
            new_hard_disk[:capacity] = size
            new_hard_disk[:name] = increase_hard_disk_name(new_hard_disk[:name])
            new_hard_disk[:address_on_parent] += 1
            new_hard_disk[:id] += 1
            @items << new_hard_disk
          end

          def delete_hard_disk(disk_number)
            @items.delete_if {|item| item[:resource_type] == 17 && item[:name] =~ /#{disk_number}$/ }
          end

          def disks
            { :disks => @items }
          end

          def generate_xml
            output = ""
            output << header
            @items.each do |item|
              output << case item[:resource_type]
                        when 6
                          scsi_controller(item)
                        when 17
                          hard_disk_item(item)
                        when 5
                          ide_controller_item(item)
                        end
            end
            output << tail
            output
          end

          def header
            <<-END
            <vcloud:RasdItemsList xmlns:vcloud="http://www.vmware.com/vcloud/v1.5"
              xmlns:rasd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData"
              type="application/vnd.vmware.vcloud.rasdItemsList+xml">
            END
          end

          def tail
            <<-END
            </vcloud:RasdItemsList>
            END
          end

          def hard_disk_item(opts={})
            <<-END
            <vcloud:Item>
              <rasd:AddressOnParent>#{opts[:address_on_parent]}</rasd:AddressOnParent>
              <rasd:Description>#{opts[:description]}</rasd:Description>
              <rasd:ElementName>#{opts[:name]}</rasd:ElementName>
              <rasd:HostResource vcloud:capacity=\"#{opts[:capacity]}\" vcloud:busSubType=\"#{opts[:bus_sub_type]}\" vcloud:busType=\"#{opts[:bus_type]}\"></rasd:HostResource>
              <rasd:InstanceID>#{opts[:id]}</rasd:InstanceID>
              <rasd:Parent>#{opts[:parent]}</rasd:Parent>
              <rasd:ResourceType>17</rasd:ResourceType>
            </vcloud:Item>
            END
          end

          def ide_controller_item(opts={})
            <<-END
            <vcloud:Item>
              <rasd:Address>#{opts[:address]}</rasd:Address>
              <rasd:Description>#{opts[:description]}</rasd:Description>
              <rasd:ElementName>#{opts[:name]}</rasd:ElementName>
              <rasd:InstanceID>#{opts[:id]}</rasd:InstanceID>
              <rasd:ResourceType>5</rasd:ResourceType>
            </vcloud:Item>
            END
          end

          def scsi_controller(opts={})
            <<-END
            <vcloud:Item>
              <rasd:Address>#{opts[:address]}</rasd:Address>
              <rasd:Description>#{opts[:description]}</rasd:Description>
              <rasd:ElementName>#{opts[:name]}</rasd:ElementName>
              <rasd:InstanceID>#{opts[:id]}</rasd:InstanceID>
              <rasd:ResourceSubType>#{opts[:resource_sub_type]}</rasd:ResourceSubType>
              <rasd:ResourceType>6</rasd:ResourceType>
            </vcloud:Item>
            END
          end

          # helpers

          def last_hard_disk
             hard_disks = @items.select{|item| item[:resource_type] == 17}
             names = hard_disks.map{|item| item[:name] }
             only_numbers = names.map{|b| b.scan(/\d+/).first.to_i} # extract numbers
             last_number = only_numbers.sort.last # get the last number
             hard_disks.find{|hard_disk| hard_disk[:name] =~ /#{last_number}$/  }
          end

          def increase_hard_disk_name(hard_disk_name)
            hard_disk_name.gsub(/(\d+)$/) { $1.to_i + 1 }
          end
        end
      end
    end
  end
end
