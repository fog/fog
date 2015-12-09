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
        attribute :context
        attribute :user_variables


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
            + get_sched_ds_rank \
            + get_context \
            + get_user_variables
        end

        def get_cpu
          return "CPU=#{vcpu.to_f/10}\n" unless cpu
          return "CPU=#{vcpu}\n" if cpu.to_i > vcpu.to_i
          "CPU=#{cpu}\n"
        end

        def get_vcpu
          self.vcpu = 1 unless vcpu
          "VCPU=#{vcpu}\n"
        end

        def get_memory
          self.memory = 128 unless memory
          "MEMORY=#{memory}\n"
        end

        def get_raw
          return "" unless raw
          ret = "RAW=#{raw}\n"
          ret.gsub!(/\{/, '[')
          ret.gsub!(/\}/, ']')
          ret.gsub!(/=>/,'=')
          ret
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
          return "" if nic.nil?
          ret = ""
          if nic.is_a? Array
            nic.each do |n|
              ret += %Q|NIC=[MODEL="#{n.model}",NETWORK_ID="#{n.vnet.id}"]\n| unless n.vnet.nil?
            end
          end
          #ret.gsub!(/\{/, '[')
          #ret.gsub!(/\}/, ']')
          #ret.gsub!(/>/,'')
          ret
        end

        def get_sched_ds_requirements
          return "" unless sched_ds_requirements
          %Q|SCHED_DS_REQUIREMENTS="#{sched_ds_requirements.gsub(/"/){ %q(\") }}"\n|
        end

        def get_sched_ds_rank
          return "" unless sched_ds_rank
          %Q|SCHED_DS_RANK="#{sched_ds_rank.gsub(/"/){ %q(\") }}"\n|
        end

        def get_sched_requirements
          return "" unless sched_requirements
          %Q|SCHED_REQUIREMENTS="#{sched_requirements.gsub(/"/){ %q(\") }}"\n|
        end

        def get_sched_rank
          return "" unless sched_rank
          %Q|SCHED_RANK="#{sched_rank.gsub(/"/){ %q(\") }}"\n|
        end

        def get_context
          return "" unless context
          if context.is_a? String
            return %Q|CONTEXT= [ #{context} ]\n|
          elsif context.is_a? Hash
            ret = ""
            context.each do |key, value|
              ret << %Q|"#{key}"="#{value}",|
            end
            ret.chop! if ret.end_with?(',')
            return %Q|CONTEXT=[ #{ret} ]\n|
          else
            return ""
          end
        end

        def get_user_variables
          return "" unless user_variables
          if user_variables.is_a? String
            return %Q|#{user_variables}\n|
          elsif user_variables.is_a? Hash
            ret = ""
            user_variables.each do |key, value|
              ret << %Q|#{key}="#{value}"\n|
            end
            return ret
          else
            return ""
          end
        end

      end
    end
  end
end
