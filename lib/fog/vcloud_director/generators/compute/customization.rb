# This is the data structure it accepts, this is the output of get_vm_disks
#
# {"type"=>"application/vnd.vmware.vcloud.guestCustomizationSection+xml",
#  "href"=>
#   "https://example.com/api/vApp/vm-2bbbf556-55dc-4974-82e6-aa6e814f0b64/guestCustomizationSection/",
#  "id"=>"vm-2bbbf556-55dc-4974-82e6-aa6e814f0b64",
#  "enabled"=>false,
#  "change_sid"=>false,
#  "virtual_machine_id"=>"2bbbf556-55dc-4974-82e6-aa6e814f0b64",
#  "join_domain_enabled"=>false,
#  "use_org_settings"=>false,
#  "admin_password_enabled"=>false,
#  "admin_password_auto"=>true,
#  "reset_password_required"=>false,
#  "customization_script"=>"hola\nmundo",
#  "has_customization_script"=>true,
#  "computer_name"=>"DEVWEB-001"}
# 
#
# This is what it generates
#
# <vcloud:GuestCustomizationSection
#   xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1"
#   xmlns:vcloud="http://www.vmware.com/vcloud/v1.5"
#   href="https://vcloud.example.com/api/vApp/vm-55cc91f2-7e12-48d4-ad90-6f637a51fd88/guestCustomizationSection/"
#   ovf:required="false"
#   type="application/vnd.vmware.vcloud.guestCustomizationSection+xml">
#   <ovf:Info>Specifies Guest OS Customization Settings</ovf:Info>
#   <vcloud:Enabled>true</vcloud:Enabled>
#   <vcloud:ChangeSid>true</vcloud:ChangeSid>
#   <vcloud:VirtualMachineId>55cc91f2-7e12-48d4-ad90-6f637a51fd88</vcloud:VirtualMachineId>
#   <vcloud:JoinDomainEnabled>false</vcloud:JoinDomainEnabled>
#   <vcloud:UseOrgSettings>false</vcloud:UseOrgSettings>
#   <vcloud:AdminPasswordEnabled>true</vcloud:AdminPasswordEnabled>
#   <vcloud:AdminPasswordAuto>true</vcloud:AdminPasswordAuto>
#   <vcloud:ResetPasswordRequired>false</vcloud:ResetPasswordRequired>
#   <vcloud:ComputerName>DEVWEB-001</vcloud:ComputerName>
# </vcloud:GuestCustomizationSection>
# 
module Fog
  module Generators
    module Compute
      module VcloudDirector

        class Customization
          
          def initialize(attrs={})
            @attrs = attrs
          end
          
          def generate_xml
            output = ""
            output << header
            output << body(@attrs)
            output << tail
            output
          end
          
          def header
              '<GuestCustomizationSection xmlns="http://www.vmware.com/vcloud/v1.5" 
                xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1" 
                type="application/vnd.vmware.vcloud.guestCustomizationSection+xml" 
                ovf:required="false" 
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                xsi:schemaLocation="http://schemas.dmtf.org/ovf/envelope/1 
                  http://schemas.dmtf.org/ovf/envelope/1/dsp8023_1.1.0.xsd 
                  http://www.vmware.com/vcloud/v1.5 
                  http://zone01.bluelock.com/api/v1.5/schema/master.xsd">'
              
          end
          
          # the order maters http://communities.vmware.com/thread/448760?start=0&tstart=0
          
          # http://www.vmware.com/support/vcd/doc/rest-api-doc-1.5-html/types/GuestCustomizationSectionType.html
          # CustomizationScript
          # Script to run on guest customization. You could use xml escape sequence &#13; to make multiple lines script. The script could contain any UNICODE symbol by specifying its number in format &#xxxx; where xxxx is the number. The predefined symbols in the XML are: * & &amp; * < &lt; * > &gt; * " &quot; * ' &apos;
          
          
          def body(opts={})
            body = "
             <ovf:Info>Specifies Guest OS Customization Settings</ovf:Info>
             <Enabled>#{opts[:enabled]}</Enabled>
             <ChangeSid>#{opts[:change_sid]}</ChangeSid>
             <VirtualMachineId>#{opts[:virtual_machine_id]}</VirtualMachineId>
             <JoinDomainEnabled>#{opts[:join_domain_enabled]}</JoinDomainEnabled>
             <UseOrgSettings>#{opts[:use_org_settings]}</UseOrgSettings>
             <AdminPasswordEnabled>#{opts[:admin_password_enabled]}</AdminPasswordEnabled>
             <AdminPasswordAuto>#{opts[:admin_password_auto]}</AdminPasswordAuto>
             <ResetPasswordRequired>#{opts[:reset_password_required]}</ResetPasswordRequired>
             <CustomizationScript>#{CGI::escapeHTML(opts[:customization_script]).gsub(/\r/, "&#13;")}</CustomizationScript>
             <ComputerName>#{opts[:computer_name]}</ComputerName>"
          end
          
          def tail
            '</GuestCustomizationSection>'
          end
          
        end
      end
    end
  end
end