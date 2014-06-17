require 'fog/core/model'

module Fog
  module Compute
    class OpenNebula
      class Flavor < Fog::Model
        identity :id
        attribute :name
        attribute :content
        attribute :cpu
        attribute :vcpu
        attribute :memory
        attribute :sched_requirements
        attribute :sched_rank
        attribute :sched_ds_requirements
        attribute :sched_ds_rank
        attribute :disk
        attribute :nic
        attribute :os
        attribute :graphics
        attribute :raw


        def to_label
          "#{name} -- #{vcpu} VCPU - #{memory}MB Mem"
        end

        def to_s
          "" + get_cpu \
            + get_vcpu \
            + get_memory \
            + get_disk \
            + get_nic \
            + get_os \
            + get_graphics \
            + get_raw \
            + get_sched_requirements \
            + get_sched_ds_requirements \
            + get_sched_rank \
            + get_sched_ds_rank
        end

        def get_cpu
          "CPU=#{vcpu.to_f/10}\n"
        end  

        def get_vcpu
          vcpu = 1 unless vcpu
          "VCPU=#{vcpu}\n"
        end  

        def get_memory
          memory = 128 unless memory
          "MEMORY=#{memory}\n"
        end  

        def get_raw
          return "" unless raw
          "RAW=#{raw}\n"
        end

        def get_disk
          return "" unless disk
          ret = ""
          if disk.is_a? Array
            disk.each do |d|
              ret += "DISK=#{d}\n"
            end
          else
            ret = "DISK=#{disk}\n"
          end
          ret.gsub!(/\{/, '[')
          ret.gsub!(/\}/, ']')
          ret.gsub!(/>/,'')
          ret 
        end

        def get_os
          return "" unless os
          ret = "OS=#{os}\n"
          ret.gsub!(/\{/, '[')
          ret.gsub!(/\}/, ']')
          ret.gsub!(/>/,'')
          ret 
        end

        def get_graphics
          return "" unless graphics 
          ret = "GRAPHICS=#{graphics}\n"
          ret.gsub!(/\{/, '[')
          ret.gsub!(/\}/, ']')
          ret.gsub!(/>/,'')
          ret 
        end

        def get_nic
          # NIC=[MODEL="virtio",NETWORK="vlan17",NETWORK_UNAME="oneadmin"]
          return "" if( nic.nil? || !(nic.is_a? Array))
          ret = ""

          nic.each do |n|
            ret += %Q|NIC=[MODEL="#{n.model}",NETWORK_ID="#{n.vnet.id}"]\n|
          end
          #ret.gsub!(/\{/, '[')
          #ret.gsub!(/\}/, ']')
          #ret.gsub!(/>/,'')
          ret 
        end

        def get_sched_ds_requirements
          return "" unless sched_ds_requirements 
          %Q|SCHED_DS_REQUIREMENTS="#{sched_ds_requirements}"\n|
        end

        def get_sched_ds_rank
          return "" unless sched_ds_rank 
          %Q|SCHED_DS_RANK="#{sched_ds_rank}"\n|
        end

        def get_sched_requirements
          return "" unless sched_requirements 
          %Q|SCHED_REQUIREMENTS="#{sched_requirements}"\n|
        end

        def get_sched_rank
          return "" unless sched_rank 
          %Q|SCHED_RANK="#{sched_rank}"\n|
        end

      end
    end
  end
end
