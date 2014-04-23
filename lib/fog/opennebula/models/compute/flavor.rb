require 'fog/core/model'

module Fog
  module Compute
    class OpenNebula

      class Flavor < Fog::Model

        identity :id

        #attribute :disk
        attribute :name
        attribute :content
        attribute :CPU
        attribute :VCPU
        attribute :MEMORY
        attribute :SCHED_REQUIREMENTS
        attribute :SCHED_RANK
        attribute :SCHED_DS_REQUIREMENTS
        attribute :SCHED_DS_RANK
        attribute :DISK
        attribute :NIC
        attribute :OS
        attribute :GRAPHICS
        attribute :RAW


	def to_label
	  "#{name} -- #{self.VCPU} VCPU - #{self.MEMORY}MB Mem"
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
	  "CPU=" + (self.VCPU.to_f/10).to_s + "\n"
        end  

        def get_vcpu
	  self.VCPU = 1 if self.VCPU.nil? 
	  "VCPU=" + self.VCPU.to_s + "\n"
        end  

        def get_memory
	  self.MEMORY = 128 if self.MEMORY.nil? 
	  "MEMORY=" + self.MEMORY.to_s + "\n"
        end  

        def get_raw
          return "" if self.RAW.nil? 
          "RAW=" + self.RAW + "\n"
        end

        def get_disk
          return "" if self.DISK.nil? 
          ret = ""
          if self.DISK.is_a? Array
            self.DISK.each do |d|
              ret += "DISK=" + d.to_s + "\n"
            end
          else
            ret = "DISK=" + self.DISK.to_s + "\n"
          end
	  ret.gsub!(/\{/, '[')
	  ret.gsub!(/\}/, ']')
	  ret.gsub!(/>/,'')
          ret 
        end

        def get_os
          return "" if self.OS.nil? 
          ret = "OS=" + self.OS.to_s + "\n"
	  ret.gsub!(/\{/, '[')
	  ret.gsub!(/\}/, ']')
          ret.gsub!(/>/,'')
          ret 
        end

        def get_graphics
          return "" if self.GRAPHICS.nil? 
          ret = "GRAPHICS=" + self.GRAPHICS.to_s + "\n"
	  ret.gsub!(/\{/, '[')
	  ret.gsub!(/\}/, ']')
          ret.gsub!(/>/,'')
          ret 
        end

        def get_nic
	  # NIC=[MODEL="virtio",NETWORK="vlan17",NETWORK_UNAME="oneadmin"]
	  return "" if( self.NIC.nil? || !(self.NIC.is_a? Array))
          ret = ""
          
	  self.NIC.each do |n|
		  ret += %Q|NIC=[MODEL="#{n.model}",NETWORK_ID="#{n.vnet.id}"]\n|
	  end
	  #ret.gsub!(/\{/, '[')
	  #ret.gsub!(/\}/, ']')
	  #ret.gsub!(/>/,'')
          ret 
        end

        def get_sched_ds_requirements
          return "" if self.SCHED_DS_REQUIREMENTS.nil? 
	  %Q|SCHED_DS_REQUIREMENTS="#{self.SCHED_DS_REQUIREMENTS}"\n|
        end

        def get_sched_ds_rank
          return "" if self.SCHED_DS_RANK.nil? 
	  %Q|SCHED_DS_RANK="#{self.SCHED_DS_RANK}"\n|
        end

        def get_sched_requirements
          return "" if self.SCHED_REQUIREMENTS.nil? 
	  %Q|SCHED_REQUIREMENTS="#{self.SCHED_REQUIREMENTS}"\n|
        end

        def get_sched_rank
          return "" if self.SCHED_RANK.nil? 
	  %Q|SCHED_RANK="#{self.SCHED_RANK}"\n|
        end

      end

    end
  end
end
