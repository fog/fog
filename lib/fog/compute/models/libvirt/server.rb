require 'fog/core/model'
require 'fog/compute/models/libvirt/util'

module Fog
  module Compute
    class Libvirt

      class Server < Fog::Model

        include Fog::Compute::LibvirtUtil

        identity :id , :aliases => 'uuid'

        attribute :memory_size
        attribute :name
        attribute :os,          :aliases => :os_type_id
        attribute :xml_desc
        attribute :cpus
        attribute :arch
        attribute :bridge_name
 
        attr_writer :private_key, :private_key_path, :public_key, :public_key_path, :username
        attr_reader :bridge_name,:arch, :cpus,:bridge_name, :name,:template_path,:memory_size,:os,:volume_path

        def initialize(attributes = {})
                   super
        end
                  
        def create(attributes = {})
          @name = attributes[:name] || raise("we need a name")
          @bridge_name  = attributes[:bridge_name]  || "br0"
          @cpus  = attributes[:cpus]  || 1
          @memory_size = attributes[:memory_size] || 256
          @username = attributes[:username] || "mccloud"
          @os  = attributes[:os]  || "hvm"
          @arch = attributes[:arch] || "x86_64"
          @template_path  = attributes[:template_path]  || "guest.xml.erb"
          #          super
          volume=connection.volumes.get("ubuntu-10_10_amd64.qcow2").clone("#{name}.qcow2")
          @volume_path=volume.path
          connection.define_domain_xml(template_xml)
          
        end
        
        def start
          requires :raw

          unless @raw.active?
            begin
              @raw.create
            rescue 
              print "An error occured :",$!,"\n"
            end
          end
        end        

        
        def destroy(options={ :destroy_volumes => false})
          
          #connection.volumes(name).destroy
          requires :raw
          if @raw.active?
             @raw.destroy
          end          
          @raw.undefine
        end

        
        def ready?
          
          status == :running
        end

        def reboot
          requires :raw
                    
          @raw.reboot
        end


        def halt
          requires :raw
                    
          @raw.shutdown
        end
        
        def resume
          requires :raw
                    
          @raw.resume
        end
        
        def suspend
          requires :raw
                    
          @raw.suspend
        end
        
        def status
          state=case @raw.info.state
            when 0 then :nostate
            when 1 then :running
            when 2 then :paused
            when 3 then :shuttingdown
            when 4 then :shutoff
            when 5 then :crashed
          end
          return state
        end
        
        def save()
  
            raise Fog::Errors::Error.new('Updating an existing server is not yet implemented. Contributions welcome!')
        end

        def scp(local_path, remote_path, upload_options = {})
          raise 'Not Implemented'
           requires :addresses, :username
          
           scp_options = {}
           scp_options[:key_data] = [private_key] if private_key           
           Fog::SCP.new(addresses['public'].first, username, options).upload(local_path, remote_path, scp_options)
        end

        def setup(credentials = {})
           requires :addresses, :identity, :public_key, :username
           Fog::SSH.new(addresses['public'].first, username, credentials).run([
             %{mkdir .ssh},
             %{echo "#{public_key}" >> ~/.ssh/authorized_keys},
             %{echo "#{attributes.to_json}" >> ~/attributes.json},
             %{echo "#{metadata.to_json}" >> ~/metadata.json}
           ])
         rescue Errno::ECONNREFUSED
           sleep(1)
           retry
        end
        
        
        ##Note this requires arpwatch to be running
        ##and chmod o+x /var/lib/arpwatch
        
        def addresses
          mac=self.mac
          options={}
          ipaddress=nil
          if connected_by_ssh?
           #command="arp -an|grep #{mac}|cut -d ' ' -f 2| cut -d '(' -f 2| cut -d ')' -f 1"
           #command="grep #{mac} /var/log/daemon.log |sed -e 's/^.*address //'|cut -d ' ' -f 1"
           command="grep #{mac} /var/lib/arpwatch/arp.dat|cut -f 2"
           result=Fog::SSH.new(connection.hostname, "patrick.debois", options).run(command)
            if result.first.status == 0
              ipaddress=result.first.stdout.strip
              #TODO check for valid IP
              #TODO check time validity
            else
              #cat /var/log/daemon.log|grep "52:54:00:52:f6:22"|
            end
          else
            #local execute arp -an to get the ip
          end
          return { 'public' => [ipaddress], 'private' => [ipaddress]}
        end


        def ssh(commands)
           requires :addresses, :identity, :username

           options = {}
           #options[:key_data] = [private_key] if private_key
           
           require 'net/ssh/proxy/command'
           options={ :password => "mccloud"}
           if connected_by_ssh?
             relay=connection.hostname
             proxy = Net::SSH::Proxy::Command.new('ssh -l patrick.debois '+relay+' nc %h %p')
             options[:proxy]= proxy
           end
           #Fog::SSH.new("192.168.122.48", "vagrant", options).run(commands)
           Fog::SSH.new(addresses['public'].first, "mccloud", options).run(commands)           
           
        end

        def stop
          requires :raw

          @raw.shutdown
        end

        def username
          @username ||= 'root'
        end
        
        def mac
          require "rexml/document"
          require 'erb'
          
            mac = document("domain/devices/interface/mac", "address")
            return mac
        end

        private

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw

          raw_attributes = { 
            :id => new_raw.uuid,
            :memory_size => new_raw.info.max_mem ,
            :name => new_raw.name,
            :cpus => new_raw.info.nr_virt_cpu,
            :os_type_id => new_raw.os_type,
            :xml_desc => new_raw.xml_desc,
     
          }          
                    
          merge_attributes(raw_attributes)
        end
        
        # finds a value from xml
        def document path, attribute=nil
          xml = REXML::Document.new(xml_desc)
          attribute.nil? ? xml.elements[path].text : xml.elements[path].attributes[attribute]
        end
        
        def connected_by_ssh?
          return connection.uri.include?("+ssh")
        end
      end

    end
  end

end
