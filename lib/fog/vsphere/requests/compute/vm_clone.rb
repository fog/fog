module Fog
  module Compute
    class Vsphere
      module Shared
        private
        def vm_clone_check_options(options)
          default_options = {
            'force'        => false,
            'linked_clone' => false,
            'nic_type' => 'VirtualE1000',
          }
          options = default_options.merge(options)
          # Backwards compat for "path" option
          options["template_path"] ||= options["path"]
          options["path"] ||= options["template_path"]
          required_options = %w{ datacenter template_path name }
          required_options.each do |param|
            raise ArgumentError, "#{required_options.join(', ')} are required" unless options.key? param
          end
          raise Fog::Compute::Vsphere::NotFound, "Datacenter #{options["datacenter"]} Doesn't Exist!" unless get_datacenter(options["datacenter"])
          raise Fog::Compute::Vsphere::NotFound, "Template #{options["template_path"]} Doesn't Exist!" unless get_virtual_machine(options["template_path"], options["datacenter"])
          options
        end
      end

      class Real
        include Shared

        # Clones a VM from a template or existing machine on your vSphere
        # Server.
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'datacenter'<~String> - *REQUIRED* Datacenter name your cloning
        #     in. Make sure this datacenter exists, should if you're using
        #     the clone function in server.rb model.
        #   * 'template_path'<~String> - *REQUIRED* The path to the machine you
        #     want to clone FROM. Relative to Datacenter (Example:
        #     "FolderNameHere/VMNameHere")
        #   * 'name'<~String> - *REQUIRED* The VMName of the Destination
        #   * 'dest_folder'<~String> - Destination Folder of where 'name' will
        #     be placed on your cluster. Relative Path to Datacenter E.G.
        #     "FolderPlaceHere/anotherSub Folder/onemore"
        #   * 'power_on'<~Boolean> - Whether to power on machine after clone.
        #     Defaults to true.
        #   * 'wait'<~Boolean> - Whether the method should wait for the virtual
        #     machine to finish cloning before returning information from
        #     vSphere. Broken right now as you cannot return a model of a serer
        #     that isn't finished cloning. Defaults to True
        #   * 'resource_pool'<~Array> - The resource pool on your datacenter
        #     cluster you want to use. Only works with clusters within same
        #     same datacenter as where you're cloning from. Datacenter grabbed
        #     from template_path option.
        #     Example: ['cluster_name_here','resource_pool_name_here']
        #   * 'datastore'<~String> - The datastore you'd like to use.
        #       (datacenterObj.datastoreFolder.find('name') in API)
        #   * 'transform'<~String> - Not documented - see http://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.vm.RelocateSpec.html
        #   * 'numCPUs'<~Integer> - the number of Virtual CPUs of the Destination VM
        #   * 'memoryMB'<~Integer> - the size of memory of the Destination VM in MB
        #   * customization_spec<~Hash>: Options are marked as required if you
        #     use this customization_spec. 
        #     As defined https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.Specification.html
        #     * encryptionKey <~array of bytes> Used to encrypt/decrypt password
        #     * globalIPSettings expects a hash, REQUIRED
        #     * identity expects a hash, REQUIRED - either LinuxPrep, Sysprep or SysprepText
        #     * nicSettingMap expects an array
        #     * options expects a hash
        #     * All options can be parsed using a yaml template with cloudinit_to_customspec.rb
        #      
        #     OLD Values still supported:
        #     This only support cloning and setting DHCP on the first interface
        #     * 'domain'<~String> - *REQUIRED* This is put into
        #       /etc/resolve.conf (we hope)
        #     * 'hostname'<~String> - Hostname of the Guest Os - default is
        #       options['name']
        #     * 'hw_utc_clock'<~Boolean> - *REQUIRED* Is hardware clock UTC?
        #       Default true
        #     * 'time_zone'<~String> - *REQUIRED* Only valid linux options
        #       are valid - example: 'America/Denver'
        #     * 'interfaces' <~Array> - interfaces object to apply to
        #        the template when cloning: overrides the
        #        network_label, network_adapter_device_key and nic_type attributes
        #     * 'volumes' <~Array> - volumes object to apply to
        #        the template when cloning: this allows to resize the
        #        existing disks as well as add or remove them. The
        #        resizing is applied only when the size is bigger then the
        #        in size in the template
        def vm_clone(options = {})
          # Option handling
          options = vm_clone_check_options(options)

          # Added for people still using options['path']
          template_path = options['path'] || options['template_path']

          # Options['template_path']<~String>
          # Added for people still using options['path']
          template_path = options['path'] || options['template_path']
          # Now find the template itself using the efficient find method
          vm_mob_ref = get_vm_ref(template_path, options['datacenter'])

          # Options['dest_folder']<~String>
          # Grab the destination folder object if it exists else use cloned mach
          dest_folder_path = options.fetch('dest_folder','/') # default to root path ({dc_name}/vm/)
          dest_folder = get_raw_vmfolder(dest_folder_path, options['datacenter'])

          # Options['resource_pool']<~Array>
          # Now find _a_ resource pool to use for the clone if one is not specified
          if ( options.key?('resource_pool') && options['resource_pool'].is_a?(Array) && options['resource_pool'].length == 2 )
            cluster_name = options['resource_pool'][0]
            pool_name = options['resource_pool'][1]
            resource_pool = get_raw_resource_pool(pool_name, cluster_name, options['datacenter'])
          elsif ( vm_mob_ref.resourcePool == nil )
            # If the template is really a template then there is no associated resource pool,
            # so we need to find one using the template's parent host or cluster
            esx_host = vm_mob_ref.collect!('runtime.host')['runtime.host']
            # The parent of the ESX host itself is a ComputeResource which has a resourcePool
            resource_pool = esx_host.parent.resourcePool
          end
          # If the vm given did return a valid resource pool, default to using it for the clone.
          # Even if specific pools aren't implemented in this environment, we will still get back
          # at least the cluster or host we can pass on to the clone task
          # This catches if resource_pool option is set but comes back nil and if resourcePool is
          # already set.
          resource_pool ||= vm_mob_ref.resourcePool.nil? ? esx_host.parent.resourcePool : vm_mob_ref.resourcePool

          # Options['datastore']<~String>
          # Grab the datastore object if option is set
          datastore_obj = get_raw_datastore(options['datastore'], options['datacenter']) if options.key?('datastore')
          # confirm nil if nil or option is not set
          datastore_obj ||= nil
          virtual_machine_config_spec = RbVmomi::VIM::VirtualMachineConfigSpec()

          device_change = []
          # fully futured interfaces api: replace the current nics
          # with the new based on the specification
          if (options.key?('interfaces') )
            if options.key?('network_label')
              raise ArgumentError, "interfaces option can't be specified together with network_label"
            end
            device_change.concat(modify_template_nics_specs(template_path, options['interfaces'], options['datacenter']))
          elsif options.key?('network_label')
            device_change << modify_template_nics_simple_spec(options['network_label'], options['nic_type'], options['network_adapter_device_key'], options['datacenter'])
          end
          if disks = options['volumes']
            device_change.concat(modify_template_volumes_specs(vm_mob_ref, options['volumes']))
          end
          virtual_machine_config_spec.deviceChange = device_change if device_change.any?
          # Options['numCPUs'] or Options['memoryMB']
          # Build up the specification for Hardware, for more details see ____________
          # https://github.com/rlane/rbvmomi/blob/master/test/test_serialization.rb
          # http://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.vm.ConfigSpec.html
          # FIXME: pad this out with the rest of the useful things in VirtualMachineConfigSpec
          virtual_machine_config_spec.numCPUs = options['numCPUs'] if  ( options.key?('numCPUs') )
          virtual_machine_config_spec.memoryMB = options['memoryMB'] if ( options.key?('memoryMB') )
          virtual_machine_config_spec.cpuHotAddEnabled = options['cpuHotAddEnabled'] if ( options.key?('cpuHotAddEnabled') )
          virtual_machine_config_spec.memoryHotAddEnabled = options['memoryHotAddEnabled'] if ( options.key?('memoryHotAddEnabled') )
          virtual_machine_config_spec.firmware = options['firmware'] if ( options.key?('firmware') )
          # Options['customization_spec']
          # OLD Options still supported
          # * domain <~String> - *REQUIRED* - Sets the server's domain for customization
          # * dnsSuffixList <~Array> - Optional - Sets the dns search paths in resolv - Example: ["dev.example.com", "example.com"]
          # * time_zone <~String> - Required - Only valid linux options are valid - example: 'America/Denver'
          # * ipsettings <~Hash> - Optional - If not set defaults to dhcp
          #  * ip <~String> - *REQUIRED* Sets the ip address of the VM - Example: 10.0.0.10
          #  * dnsServerList <~Array> - Optional - Sets the nameservers in resolv - Example: ["10.0.0.2", "10.0.0.3"]
          #  * gateway <~Array> - Optional - Sets the gateway for the interface - Example: ["10.0.0.1"]
          #  * subnetMask <~String> - *REQUIRED* - Set the netmask of the interface - Example: "255.255.255.0"
          #    For other ip settings options see http://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.vm.customization.IPSettings.html
          #
          #  Implement complete customization spec as per https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.Specification.html
          #   * encryptionKey <~Array> - Optional, encryption key used to encypt any encrypted passwords
          #   https://pubs.vmware.com/vsphere-51/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.GlobalIPSettings.html
          #   * globalIPSettings <~Hash> - REQUIRED
          #   *   dnsServerList <~Array> - Optional, list of dns servers - Example: ["10.0.0.2", "10.0.0.3"]
          #   *   dnsSuffixList <~Array> - Optional, List of name resolution suffixes - Example: ["dev.example.com", "example.com"]
          #   * identity <~Hash> - REQUIRED, Network identity and settings, similar to Microsoft's Sysprep tool. This is a Sysprep, LinuxPrep, or SysprepText object
          #   *   Sysprep <~Hash> - Optional, representation of a Windows sysprep.inf answer file.
          #   *     guiRunOnce: <~Hash> -Optional, representation of the sysprep GuiRunOnce key
          #   *       commandList: <~Array> - REQUIRED, list of commands to run at first user logon, after guest customization. - Example: ["c:\sysprep\runaftersysprep.cmd", "c:\sysprep\installpuppet.ps1"]
          #   *     guiUnattended: <~Hash> - REQUIRED, representation of the sysprep GuiUnattended key
          #   *       autoLogin: boolean - REQUIRED, Flag to determine whether or not the machine automatically logs on as Administrator.
          #   *       autoLogonCount: int - REQUIRED, specifies the number of times the machine should automatically log on as Administrator
          #   *       password: <~Hash> - REQUIRED, new administrator password for the machine
          #   *         plainText: boolean - REQUIRED, specify whether or not the password is in plain text, rather than encrypted
          #   *         value: <~String> - REQUIRED, password string
          #   *       timeZone: <~int> - REQUIRED, (see here for values https://msdn.microsoft.com/en-us/library/ms912391(v=winembedded.11).aspx)    
          #   *     identification: <~Hash> - REQUIRED, representation of the sysprep Identification key
          #   *       domainAdmin: <~String> - Optional, domain user account used for authentication if the virtual machine is joining a domain
          #   *       domainAdminPassword: <~Hash> - Optional, password for the domain user account used for authentication 
          #   *         plainText: boolean - REQUIRED, specify whether or not the password is in plain text, rather than encrypted
          #   *         value: <~String> - REQUIRED, password string
          #   *       joinDomain: <~String> - Optional, The domain that the virtual machine should join. If this value is supplied, then domainAdmin and domainAdminPassword must also be supplied
          #   *       joinWorkgroup: <~String> - Optional, The workgroup that the virtual machine should join.
          #   *     licenseFilePrintData: <~Hash> - Optional, representation of the sysprep LicenseFilePrintData key
          #   *       autoMode: <~String> - REQUIRED, Server licensing mode. Two strings are supported: 'perSeat' or 'perServer'
          #   *       autoUsers: <~Int> - Optional, This key is valid only if AutoMode = PerServer. The integer value indicates the number of client licenses
          #   *     userData: <~Hash> - REQUIRED, representation of the sysprep UserData key
          #   *       computerName: <~String> - REQUIRED, The computer name of the (Windows) virtual machine. Will be truncates to 15 characters
          #   *       fullName: <~String> - REQUIRED, User's full name
          #   *       orgName: <~String> - REQUIRED, User's organization
          #   *       productId: <~String> - REQUIRED, serial number for os, ignored if using volume licensed instance
          #   *   LinuxPrep: <~Hash> - Optional, contains machine-wide settings (note the uppercase P)
          #   *     domain: <~String> - REQUIRED, The fully qualified domain name.
          #   *     hostName: <~String> - REQUIRED, the network host name
          #   *     hwClockUTC: <~Boolean> - Optional, Specifies whether the hardware clock is in UTC or local time
          #   *     timeZone: <~String> - Optional, Case sensistive timezone, valid values can be found at https://pubs.vmware.com/vsphere-51/topic/com.vmware.wssdk.apiref.doc/timezone.html
          #   *   SysprepText: <~Hash> - Optional, alternate way to specify the sysprep.inf answer file.
          #   *     value: <~String> - REQUIRED, Text for the sysprep.inf answer file. 
          #   * nicSettingMap: <~Array> - Optional, IP settings that are specific to a particular virtual network adapter
          #   *   Each item in array:
          #   *   adapter: <~Hash> - REQUIRED, IP settings for the associated virtual network adapter
          #   *     dnsDomain: <~String> - Optional, DNS domain suffix for adapter
          #   *     dnsServerList: <~Array> - Optional, list of dns server ip addresses - Example: ["10.0.0.2", "10.0.0.3"]
          #   *     gateway: <~Array> - Optional, list of gateways - Example: ["10.0.0.2", "10.0.0.3"]
          #   *     ip: <~String> - Optional, but required if static IP
          #   *     ipV6Spec: <~Hash> - Optional, IPv^ settings
          #   *       ipAddress: <~String> - Optional, but required if setting static IP
          #   *       gateway: <~Array> - Optional, list of ipv6 gateways
          #   *     netBIOS: <~String> - Optional, NetBIOS settings, if supplied must be one of: disableNetBIOS','enableNetBIOS','enableNetBIOSViaDhcp'
          #   *     primaryWINS: <~String> - Optional, IP address of primary WINS server
          #   *     secondaryWINS: <~String> - Optional, IP address of secondary WINS server
          #   *     subnetMask: <~String> - Optional, subnet mask for adapter
          #   *   macAddress: <~String> - Optional, MAC address of adapter being customized. This cannot be set by the client
          #   * options: <~Hash> Optional operations, currently only win options have any value
          #   *   changeSID: <~Boolean> - REQUIRED, The customization process should modify the machine's security identifier
          #   *   deleteAccounts: <~Boolean> - REQUIRED, If deleteAccounts is true, then all user accounts are removed from the system
          #   *   reboot: <~String> - Optional, (defaults to reboot), Action to be taken after running sysprep, must be one of: 'noreboot', 'reboot', 'shutdown'
          #
          if ( options.key?('customization_spec') )
            custom_spec = options['customization_spec']

            # backwards compatablity
            if custom_spec.key?('domain')
              # doing this means the old options quash any new ones passed as well... might not be the best way to do it?
              # any 'old' options overwrite the following:
              #   - custom_spec['identity']['LinuxPrep']
              #   - custom_spec['globalIPSettings['['dnsServerList']
              #   - custom_spec['globalIPSettings']['dnsSuffixList']
              #   - custom_spec['nicSettingMap'][0]['adapter']['ip']
              #   - custom_spec['nicSettingMap'][0]['adapter']['gateway']
              #   - custom_spec['nicSettingMap'][0]['adapter']['subnetMask']
              #   - custom_spec['nicSettingMap'][0]['adapter']['dnsDomain']
              #   - custom_spec['nicSettingMap'][0]['adapter']['dnsServerList']
              #
              # we can assume old parameters being passed
              cust_hostname = custom_spec['hostname'] || options['name']
              custom_spec['identity'] = Hash.new unless custom_spec.key?('identity')
              custom_spec['identity']['LinuxPrep'] = {"domain" => custom_spec['domain'], "hostName" => cust_hostname, "timeZone" => custom_spec['time_zone']}
            
              if custom_spec.key?('ipsettings')
                custom_spec['globalIPSettings']=Hash.new unless custom_spec.key?('globalIPSettings')
                custom_spec['globalIPSettings']['dnsServerList'] = custom_spec['ipsettings']['dnsServerList'] if custom_spec['ipsettings'].key?('dnsServerList')
                custom_spec['globalIPSettings']['dnsSuffixList'] = custom_spec['dnsSuffixList'] || [custom_spec['domain']] if ( custom_spec['dnsSuffixList'] || custom_spec['domain'])
              end
        
              if (custom_spec['ipsettings'].key?('ip') or custom_spec['ipsettings'].key?('gateway') or custom_spec['ipsettings'].key?('subnetMask') or custom_spec['ipsettings'].key?('domain') or custom_spec['ipsettings'].key?('dnsServerList'))
                if custom_spec['ipsettings'].key?('ip') 
                  raise ArgumentError, "subnetMask is required for static ip" unless custom_spec["ipsettings"].key?("subnetMask")
                end
                custom_spec['nicSettingMap']=Array.new unless custom_spec.key?('nicSettingMap')
                custom_spec['nicSettingMap'][0]=Hash.new unless custom_spec['nicSettingMap'].length > 0
                custom_spec['nicSettingMap'][0]['adapter']=Hash.new unless custom_spec['nicSettingMap'][0].key?('adapter')
                custom_spec['nicSettingMap'][0]['adapter']['ip'] = custom_spec['ipsettings']['ip'] if custom_spec['ipsettings'].key?('ip')
                custom_spec['nicSettingMap'][0]['adapter']['gateway'] = custom_spec['ipsettings']['gateway'] if custom_spec['ipsettings'].key?('gateway')
                custom_spec['nicSettingMap'][0]['adapter']['subnetMask'] = custom_spec['ipsettings']['subnetMask'] if custom_spec['ipsettings'].key?('subnetMask')
                custom_spec['nicSettingMap'][0]['adapter']['dnsDomain'] = custom_spec['ipsettings']['domain'] if custom_spec['ipsettings'].key?('domain')
                custom_spec['nicSettingMap'][0]['adapter']['dnsServerList'] = custom_spec['ipsettings']['dnsServerList'] if custom_spec['ipsettings'].key?('dnsServerList')
              end       
            end
            ### End of backwards compatability 

            ## requirements check here ##
            raise ArgumentError, "globalIPSettings are required when using Customization Spec" unless custom_spec.key?('globalIPSettings')
            raise ArgumentError, "identity is required when using Customization Spec" unless custom_spec.key?('identity')
          
            # encryptionKey
            custom_encryptionKey = custom_spec['encryptionKey'] if custom_spec.key?('encryptionKey')
            custom_encryptionKey ||= nil
            
            # globalIPSettings
            # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.GlobalIPSettings.html
            custom_globalIPSettings = RbVmomi::VIM::CustomizationGlobalIPSettings.new()
            custom_globalIPSettings.dnsServerList = custom_spec['globalIPSettings']['dnsServerList'] if custom_spec['globalIPSettings'].key?("dnsServerList")
            custom_globalIPSettings.dnsSuffixList = custom_spec['globalIPSettings']['dnsSuffixList'] if custom_spec['globalIPSettings'].key?("dnsSuffixList")
            
            # identity
            # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.IdentitySettings.html
            # Accepts the 3 supported CustomizationIdentitySettings Types:
            # 1. CustomizationLinuxPrep (LinuxPrep) - note the uppercase P
            # 2. CustomizationSysprep (Sysprep)
            # 3. CustomizationSysprepText (SysprepText)
            # At least one of these is required
            #
            identity = custom_spec['identity']
            if identity.key?("LinuxPrep")
              # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.LinuxPrep.html
              # Fields:
              #   * domain: string **REQUIRED**
              #   * hostName: string (CustomizationName)  **REQUIRED** Will use options['name'] if not provided.
              #   * hwClockUTC: boolean
              #   * timeZone: string (https://pubs.vmware.com/vsphere-55/topic/com.vmware.wssdk.apiref.doc/timezone.html) 
              raise ArgumentError, "domain is required when using LinuxPrep identity" unless identity['LinuxPrep'].key?('domain')
              custom_identity = RbVmomi::VIM::CustomizationLinuxPrep(:domain => identity['LinuxPrep']['domain'])
              cust_hostname = RbVmomi::VIM::CustomizationFixedName(:name => identity['LinuxPrep']['hostName']) if identity['LinuxPrep'].key?('hostName')
              cust_hostname ||= RbVmomi::VIM::CustomizationFixedName(:name => options['name'])
              custom_identity.hostName = cust_hostname
              custom_identity.hwClockUTC = identity['LinuxPrep']['hwClockUTC'] if identity['LinuxPrep'].key?('hwClockUTC')
              custom_identity.timeZone = identity['LinuxPrep']['timeZone'] if identity['LinuxPrep'].key?('timeZone') 
            elsif identity.key?("Sysprep")
              # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.Sysprep.html
              # Fields:
              #   * guiRunOnce: CustomizationGuiRunOnce
              #   * guiUnattended: CustomizationGuiUnattended  **REQUIRED**
              #   * identification: CustomizationIdentification  **REQUIRED**
              #   * licenseFilePrintData: CustomizationLicenseFilePrintData
              #   * userData: CustomizationUserData **REQUIRED**
              # 
              raise ArgumentError, "guiUnattended is required when using Sysprep identity" unless identity['Sysprep'].key?('guiUnattended')
              raise ArgumentError, "identification is required when using Sysprep identity" unless identity['Sysprep'].key?('identification')
              raise ArgumentError, "userData is required when using Sysprep identity" unless identity['Sysprep'].key?('userData')
              if identity['Sysprep']['guiRunOnce']
                # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.GuiRunOnce.html
                # Fields:
                #  * commandList: array of string **REQUIRED***
                #
                raise ArgumentError, "commandList is required when using Sysprep identity and guiRunOnce" unless identity['Sysprep']['guiRunOnce'].key?('commandList')
                cust_guirunonce = RbVmomi::VIM.CustomizationGuiRunOnce( :commandList => identity['Sysprep']['guiRunOnce']['commandList'] )
              end
              # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.GuiUnattended.html
              # Fields:
              #   * autoLogin: boolean **REQUIRED**
              #   * autoLogonCount: int **REQUIRED**
              #   * timeZone: int (see here for values https://msdn.microsoft.com/en-us/library/ms912391(v=winembedded.11).aspx) **REQUIRED**
              #   * password: CustomizationPassword 
              raise ArgumentError, "guiUnattended->autoLogon is required when using Sysprep identity" unless identity['Sysprep']['guiUnattended'].key?('autoLogon')
              raise ArgumentError, "guiUnattended->autoLogonCount is required when using Sysprep identity" unless identity['Sysprep']['guiUnattended'].key?('autoLogonCount')
              raise ArgumentError, "guiUnattended->timeZone is required when using Sysprep identity" unless identity['Sysprep']['guiUnattended'].key?('timeZone')
              custom_guiUnattended = RbVmomi::VIM.CustomizationGuiUnattended(
                :autoLogon => identity['Sysprep']['guiUnattended']['autoLogon'],
                :autoLogonCount => identity['Sysprep']['guiUnattended']['autoLogonCount'],
                :timeZone => identity['Sysprep']['guiUnattended']['timeZone']
              )
              if identity['Sysprep']['guiUnattended']['password']
                # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.Password.html
                # Fields:
                #   * plainText: boolean  **REQUIRED**
                #   * value: string  **REQUIRED**
                raise ArgumentError, "guiUnattended->password->plainText is required when using Sysprep identity and guiUnattended -> password" unless identity['Sysprep']['guiUnattended']['password'].key?('plainText')
                raise ArgumentError, "guiUnattended->password->value is required when using Sysprep identity and guiUnattended -> password" unless identity['Sysprep']['guiUnattended']['password'].key?('value')
                custom_guiUnattended.password = RbVmomi::VIM.CustomizationPassword(
                  :plainText => identity['Sysprep']['guiUnattended']['password']['plainText'],
                  :value => identity['Sysprep']['guiUnattended']['password']['value']
                )
              end
              # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.Identification.html
              # Fields:
              #   * domainAdmin: string
              #   * domainAdminPassword: CustomizationPassword
              #   * joinDomain: string *If supplied domainAdmin and domainAdminPassword must be set
              #   * joinWorkgroup: string *If supplied, joinDomain, domainAdmin and domainAdminPassword will be ignored
              custom_identification = RbVmomi::VIM.CustomizationIdentification()
              if identity['Sysprep']['identification'].key?('joinWorkgroup')
                custom_identification.joinWorkgroup = identity['Sysprep']['identification']['joinWorkgroup']
              elsif identity['Sysprep']['identification'].key?('joinDomain')
                raise ArgumentError, "identification->domainAdmin is required when using Sysprep identity and identification -> joinDomain" unless identity['Sysprep']['identification'].key?('domainAdmin')
                raise ArgumentError, "identification->domainAdminPassword is required when using Sysprep identity and identification -> joinDomain" unless identity['Sysprep']['identification'].key?('domainAdmin')
                raise ArgumentError, "identification->domainAdminPassword->plainText is required when using Sysprep identity and identification -> joinDomain" unless identity['Sysprep']['identification']['domainAdminPassword'].key?('plainText')
                raise ArgumentError, "identification->domainAdminPassword->value is required when using Sysprep identity and identification -> joinDomain" unless identity['Sysprep']['identification']['domainAdminPassword'].key?('value')
                custom_identification.joinDomain = identity['Sysprep']['identification']['joinDomain']
                custom_identification.domainAdmin = identity['Sysprep']['identification']['domainAdmin']
                # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.Password.html
                # Fields:
                #   * plainText: boolean **REQUIRED**
                #   * value: string **REQUIRED**
                custom_identification.domainAdminPassword = RbVmomi::VIM.CustomizationPassword( 
                  :plainText => identity['Sysprep']['identification']['domainAdminPassword']['plainText'],
                  :value => identity['Sysprep']['identification']['domainAdminPassword']['value']
                )
              else
                raise ArgumentError, "No valid Indentification found, valid values are 'joinWorkgroup' and 'joinDomain'"
              end
              if identity['Sysprep'].key?('licenseFilePrintData')
                # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.LicenseFilePrintData.html
                # Fields:
                #   * autoMode: string (CustomizationLicenseDataMode) ** REQUIRED **, valid strings are: 'perSeat' or 'perServer'
                #   * autoUsers: int (valid only if AutoMode = PerServer)
                raise ArgumentError, "licenseFilePrintData->autoMode is required when using Sysprep identity and licenseFilePrintData" unless identity['Sysprep']['licenseFilePrintData'].key?('autoMode')
                raise ArgumentError, "Unsupported autoMode, supported modes are : 'perSeat' or 'perServer'" unless ['perSeat', 'perServer'].include? identity['Sysprep']['licenseFilePrintData']['autoMode']
                custom_licenseFilePrintData = RbVmomi::VIM.CustomizationLicenseFilePrintData(
                  :autoMode => RbVmomi::VIM.CustomizationLicenseDataMode(identity['Sysprep']['licenseFilePrintData']['autoMode'])
                )
                if identity['Sysprep']['licenseFilePrintData'].key?('autoUsers')
                  custom_licenseFilePrintData.autoUsers = identity['Sysprep']['licenseFilePrintData']['autoUsers'] if identity['Sysprep']['licenseFilePrintData']['autoMode'] == "PerServer"
                end
              end
              # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.UserData.html
              # Fields:
              #   * computerName: string (CustomizationFixedName)  **REQUIRED**
              #   * fullName: string **REQUIRED**
              #   * orgName: string **REQUIRED**
              #   * productID: string **REQUIRED**
              raise ArgumentError, "userData->computerName is required when using Sysprep identity" unless identity['Sysprep']['userData'].key?('computerName')
              raise ArgumentError, "userData->fullName is required when using Sysprep identity" unless identity['Sysprep']['userData'].key?('fullName')
              raise ArgumentError, "userData->orgName is required when using Sysprep identity" unless identity['Sysprep']['userData'].key?('orgName')
              raise ArgumentError, "userData->productId is required when using Sysprep identity" unless identity['Sysprep']['userData'].key?('productId')
              custom_userData = RbVmomi::VIM.CustomizationUserData(
                :fullName => identity['Sysprep']['userData']['fullName'],
                :orgName => identity['Sysprep']['userData']['orgName'],
                :productId => identity['Sysprep']['userData']['productId'],
                :computerName => RbVmomi::VIM.CustomizationFixedName(:name => identity['Sysprep']['userData']['computerName'])
              )

              custom_identity = RbVmomi::VIM::CustomizationSysprep(          
                :guiUnattended => custom_guiUnattended,
                :identification => custom_identification,
                :userData => custom_userData
              )
              custom_identity.guiRunOnce = cust_guirunonce if defined?(cust_guirunonce)
              custom_identity.licenseFilePrintData = custom_licenseFilePrintData if defined?(custom_licenseFilePrintData)
            elsif identity.key?("SysprepText")
              # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.SysprepText.html
              # Fields:
              #   * value: string **REQUIRED**
              raise ArgumentError, "SysprepText -> value is required when using SysprepText identity" unless identity['SysprepText'].key?('value')
              custom_identity = RbVmomi::VIM::CustomizationSysprepText(:value => identity['SysprepText']['value'])
            else
              raise ArgumentError, "At least one of the following valid identities must be supplied: LinuxPrep, Sysprep, SysprepText"
            end

            if custom_spec.key?("nicSettingMap")
              # custom_spec['nicSettingMap'] is an array of adapater mappings:
              # custom_spec['nicSettingMap'][0]['macAddress']
              # custom_spec['nicSettingMap'][0]['adapter']['ip']
              #https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.AdapterMapping.html
              # Fields:
              #   * adapter: CustomizationIPSettings **REQUIRED**
              #   * macAddress: string
              raise ArgumentError, "At least one nicSettingMap is required when using nicSettingMap" unless custom_spec['nicSettingMap'].length > 0
              raise ArgumentError, "Adapter is required when using nicSettingMap" unless custom_spec['nicSettingMap'][0].key?('adapter')
              
              custom_nicSettingMap = [] 
              # need to go through array here for each apapter
              custom_spec['nicSettingMap'].each do | nic |
                # https://pubs.vmware.com/vsphere-55/index.jsp?topic=%2Fcom.vmware.wssdk.apiref.doc%2Fvim.vm.customization.IPSettings.html
                # Fields:
                #   * dnsDomain: string
                #   * gateway: array of string
                #   * ip: CustomizationIpGenerator (string) **REQUIRED IF Assigning Static IP***
                #   * ipV6Spec: CustomizationIPSettingsIpV6AddressSpec
                #   * netBIOS: CustomizationNetBIOSMode (string)
                #   * primaryWINS: string
                #   * secondaryWINS: string
                #   * subnetMask: string - Required if assigning static IP
                if nic['adapter'].key?('ip')
                  raise ArgumentError, "SubnetMask is required when assigning static IP when using nicSettingMap -> Adapter" unless nic['adapter'].key?('subnetMask')
                  custom_ip = RbVmomi::VIM.CustomizationFixedIp(:ipAddress => nic['adapter']['ip'])
                else
                  custom_ip = RbVmomi::VIM::CustomizationDhcpIpGenerator.new()
                end
                custom_adapter = RbVmomi::VIM.CustomizationIPSettings(:ip => custom_ip)
                custom_adapter.dnsDomain = nic['adapter']['dnsDomain'] if nic['adapter'].key?('dnsDomain')
                custom_adapter.dnsServerList = nic['adapter']['dnsServerList'] if nic['adapter'].key?('dnsServerList')
                custom_adapter.gateway = nic['adapter']['gateway'] if nic['adapter'].key?('gateway')
                if nic['adapter'].key?('ipV6Spec')
                  # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.IPSettings.IpV6AddressSpec.html
                  # Fields:
                  #   * gateway: array of string
                  #   * ip: CustomizationIpV6Generator[] **Required if setting static IP **
                  if nic['adapter']['ipV6Spec'].key?('ipAddress')
                    raise ArgumentError, "SubnetMask is required when assigning static IPv6 when using nicSettingMap -> Adapter -> ipV6Spec" unless nic['adapter']['ipV6Spec'].key?('subnetMask')
                    # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.FixedIpV6.html
                    #   * ipAddress: string **REQUIRED**
                    #   * subnetMask: int **REQUIRED**
                    custom_ipv6 = RbVmomi::VIM.CustomizationFixedIpV6(
                      :ipAddress => nic['adapter']['ipV6Spec']['ipAddress'],
                      :subnetMask => nic['adapter']['ipV6Spec']['subnetMask']
                    )
                  else
                    custom_ipv6 = RbVmomi::VIM::CustomizationDhcpIpV6Generator.new()
                  end
                  custom_ipv6Spec = RbVmomi::VIM.CustomizationIPSettingsIpV6AddressSpec(:ip => custom_ipv6)
                  custom_ipv6Spec.gateway = nic['adapter']['ipV6Spec']['gateway'] if nic['adapter']['ipV6Spec'].key?('gateway')
                  custom_adapter.ipV6Spec = custom_ipv6Spec
                end
                if nic['adapter'].key?('netBIOS')
                  # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.IPSettings.NetBIOSMode.html
                  # Fields:
                  #   netBIOS: string matching: 'disableNetBIOS','enableNetBIOS' or 'enableNetBIOSViaDhcp' ** REQUIRED **
                  #
                  raise ArgumentError, "Unsupported NetBIOSMode, supported modes are : 'disableNetBIOS','enableNetBIOS' or 'enableNetBIOSViaDhcp'" unless ['disableNetBIOS','enableNetBIOS','enableNetBIOSViaDhcp'].include? nic['adapter']['netBIOS']
                  custom_adapter.netBIOS = RbVmomi::VIM.CustomizationNetBIOSMode(nic['adapter']['netBIOS'])
                end
                custom_adapter.primaryWINS = nic['adapter']['primaryWINS'] if nic['adapter'].key?('primaryWINS')
                custom_adapter.secondaryWINS = nic['adapter']['secondaryWINS'] if nic['adapter'].key?('secondaryWINS')
                custom_adapter.subnetMask = nic['adapter']['subnetMask'] if nic['adapter'].key?('subnetMask')
                
                custom_adapter_mapping = RbVmomi::VIM::CustomizationAdapterMapping(:adapter => custom_adapter)
                custom_adapter_mapping.macAddress = nic['macAddress'] if nic.key?('macAddress')
                
                # build the adapters array, creates it if not already created, otherwise appends to it
                custom_nicSettingMap << custom_adapter_mapping 
              end
            end  
            custom_nicSettingMap = nil if custom_nicSettingMap.length < 1
                      
            if custom_spec.key?("options") 
              # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.Options.html
              # this currently doesn't have any Linux options, just windows
              # Fields:
              #   * changeSID: boolean **REQUIRED**
              #   * deleteAccounts: boolean **REQUIRED** **note deleteAccounts is deprecated as of VI API 2.5 so can be ignored
              #   * reboot: CustomizationSysprepRebootOption: (string) one of following 'noreboot', reboot' or 'shutdown' (defaults to reboot)
              raise ArgumentError, "changeSID id required when using Windows Options" unless custom_spec['options'].key?('changeSID')
              raise ArgumentError, "deleteAccounts id required when using Windows Options" unless custom_spec['options'].key?('deleteAccounts')
              custom_options = RbVmomi::VIM::CustomizationWinOptions(
                :changeSID => custom_spec['options']['changeSID'],
                :deleteAccounts => custom_spec['options']['deleteAccounts']
              )
              if custom_spec['options'].key?('reboot')
                raise ArgumentError, "Unsupported reboot option, supported options are : 'noreboot', 'reboot' or 'shutdown'" unless ['noreboot','reboot','shutdown'].include? custom_spec['options']['reboot']
                custom_options.reboot = RBVmomi::VIM.CustomizationSysprepRebootOption(custom_spec['options']['reboot'])
              end
            end
            custom_options ||=nil  
            
            # https://pubs.vmware.com/vsphere-55/index.jsp#com.vmware.wssdk.apiref.doc/vim.vm.customization.Specification.html
            customization_spec = RbVmomi::VIM::CustomizationSpec(
              :globalIPSettings => custom_globalIPSettings,
              :identity         => custom_identity
            )
            customization_spec.encryptionKey = custom_encryptionKey if defined?(custom_encryptionKey)
            customization_spec.nicSettingMap = custom_nicSettingMap if defined?(custom_nicSettingMap)
            customization_spec.options = custom_options if defined?(custom_options)

          end
          customization_spec ||= nil

          relocation_spec=nil
          if ( options['linked_clone'] )
            # cribbed heavily from the rbvmomi clone_vm.rb
            # this chunk of code reconfigures the disk of the clone source to be read only,
            # and then creates a delta disk on top of that, this is required by the API in order to create
            # linked clondes
            disks = vm_mob_ref.config.hardware.device.select do |vm_device|
              vm_device.class == RbVmomi::VIM::VirtualDisk
            end
            disks.select{|vm_device| vm_device.backing.parent == nil}.each do |disk|
              disk_spec = {
                :deviceChange => [
                  {
                    :operation => :remove,
                    :device => disk
                  },
                  {
                    :operation => :add,
                    :fileOperation => :create,
                    :device => disk.dup.tap{|disk_backing|
                      disk_backing.backing = disk_backing.backing.dup;
                      disk_backing.backing.fileName = "[#{disk.backing.datastore.name}]";
                      disk_backing.backing.parent = disk.backing
                    }
                  }
                ]
              }
              vm_mob_ref.ReconfigVM_Task(:spec => disk_spec).wait_for_completion
            end
            # Next, create a Relocation Spec instance
            relocation_spec = RbVmomi::VIM.VirtualMachineRelocateSpec(:datastore => datastore_obj,
                                                                      :pool => resource_pool,
                                                                      :diskMoveType => :moveChildMostDiskBacking)
          else
            relocation_spec = RbVmomi::VIM.VirtualMachineRelocateSpec(:datastore => datastore_obj,
                                                                      :pool => resource_pool,
                                                                      :transform => options['transform'] || 'sparse')
          end
          # And the clone specification
          clone_spec = RbVmomi::VIM.VirtualMachineCloneSpec(:location => relocation_spec,
                                                            :config => virtual_machine_config_spec,
                                                            :customization => customization_spec,
                                                            :powerOn  => options.key?('power_on') ? options['power_on'] : true,
                                                            :template => false)

          # Perform the actual Clone Task
          task = vm_mob_ref.CloneVM_Task(:folder => dest_folder,
                                         :name => options['name'],
                                         :spec => clone_spec)
          # Waiting for the VM to complete allows us to get the VirtulMachine
          # object of the new machine when it's done.  It is HIGHLY recommended
          # to set 'wait' => true if your app wants to wait.  Otherwise, you're
          # going to have to reload the server model over and over which
          # generates a lot of time consuming API calls to vmware.
          if options.fetch('wait', true) then
            # REVISIT: It would be awesome to call a block passed to this
            # request to notify the application how far along in the process we
            # are.  I'm thinking of updating a progress bar, etc...
            new_vm = task.wait_for_completion
          else
            tries = 0
            new_vm = begin
              # Try and find the new VM (folder.find is quite efficient)
              dest_folder.find(options['name'], RbVmomi::VIM::VirtualMachine) or raise Fog::Vsphere::Errors::NotFound
            rescue Fog::Vsphere::Errors::NotFound
              tries += 1
              if tries <= 10 then
                sleep 15
                retry
              end
              nil
            end
          end

          # Return hash
          {
            'vm_ref'        => new_vm ? new_vm._ref : nil,
            'new_vm'        => new_vm ? convert_vm_mob_ref_to_attr_hash(new_vm) : nil,
            'task_ref'      => task._ref
          }
        end

        # Build up the network config spec for simple case:
        # simple case: apply just the network_label, nic_type and network_adapter_device_key
        def modify_template_nics_simple_spec(network_label, nic_type, network_adapter_device_key, datacenter)
            config_spec_operation = RbVmomi::VIM::VirtualDeviceConfigSpecOperation('edit')
            # Get the portgroup and handle it from there.
            network = get_raw_network(network_label, datacenter)
            if ( network.kind_of? RbVmomi::VIM::DistributedVirtualPortgroup)
                # Create the NIC backing for the distributed virtual portgroup
                nic_backing_info = RbVmomi::VIM::VirtualEthernetCardDistributedVirtualPortBackingInfo(
                    :port => RbVmomi::VIM::DistributedVirtualSwitchPortConnection( 
                                                                                  :portgroupKey => network.key,
                                                                                  :switchUuid => network.config.distributedVirtualSwitch.uuid
                                                                                 ) 
                )
            else
                # Otherwise it's a non distributed port group
                nic_backing_info = RbVmomi::VIM::VirtualEthernetCardNetworkBackingInfo(:deviceName => network_label)
            end
            connectable = RbVmomi::VIM::VirtualDeviceConnectInfo(
              :allowGuestControl => true,
              :connected => true,
              :startConnected => true)
            device = RbVmomi::VIM.public_send "#{nic_type}",
              :backing => nic_backing_info,
              :deviceInfo => RbVmomi::VIM::Description(:label => "Network adapter 1", :summary => network_label),
              :key => network_adapter_device_key,
              :connectable => connectable
            device_spec = RbVmomi::VIM::VirtualDeviceConfigSpec(
              :operation => config_spec_operation,
              :device => device)
            return device_spec
        end


        def modify_template_nics_specs(template_path, new_nics, datacenter)
          #new_spec_operation = RbVmomi::VIM::VirtualDeviceConfigSpecOperation('new')
          #remove_spec_operation = RbVmomi::VIM::VirtualDeviceConfigSpecOperation('remove')

          template_nics = list_vm_interfaces(template_path, datacenter).map do |old_attributes|
            Fog::Compute::Vsphere::Interface.new(old_attributes)
          end
          specs = []

          template_nics.each do |interface|
            specs << create_interface(interface, interface.key, :remove)
          end

          new_nics.each do |interface|
            specs << create_interface(interface, 0, :add)
          end

          return specs
        end

        def modify_template_volumes_specs(vm_mob_ref, volumes)
          template_volumes = vm_mob_ref.config.hardware.device.grep(RbVmomi::VIM::VirtualDisk)
          modified_volumes = volumes.take(template_volumes.size)
          new_volumes      = volumes.drop(template_volumes.size)

          specs = []
          template_volumes.zip(modified_volumes).each do |template_volume, new_volume|
            if new_volume
              # updated the attribtues on the existing volume
              # it's not allowed to reduce the size of the volume when cloning
              if new_volume.size > template_volume.capacityInKB
                template_volume.capacityInKB = new_volume.size
              end
              template_volume.backing.diskMode = new_volume.mode
              template_volume.backing.thinProvisioned = new_volume.thin
              specs << { :operation => :edit, :device  => template_volume }
            else
              specs << { :operation => :remove,
                         :fileOperation => :destroy,
                         :device  => template_volume }
            end
          end
          specs.concat(new_volumes.map { |volume| create_disk(volume, volumes.index(volume)) })
          return specs
        end
      end

      class Mock
        include Shared
        def vm_clone(options = {})
          # Option handling TODO Needs better method of checking
          options = vm_clone_check_options(options)
          notfound = lambda { raise Fog::Compute::Vsphere::NotFound, "Could not find VM template" }
          template = list_virtual_machines.find(notfound) do |vm|
            vm['name'] == options['template_path'].split("/")[-1]
          end

          # generate a random id
          id = [8,4,4,4,12].map{|i| Fog::Mock.random_hex(i)}.join("-")
          new_vm = template.clone.merge({
            "name" => options['name'],
            "id" => id,
            "instance_uuid" => id,
            "path" => "/Datacenters/#{options['datacenter']}/#{options['dest_folder'] ? options['dest_folder']+"/" : ""}#{options['name']}"
          })
          self.data[:servers][id] = new_vm

          {
            'vm_ref'   => "vm-#{Fog::Mock.random_numbers(3)}",
            'new_vm'   => new_vm,
            'task_ref' => "task-#{Fog::Mock.random_numbers(4)}",
          }
        end
      end
    end
  end
end
