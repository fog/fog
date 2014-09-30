class VcloudDirector
  module Compute
    module Schema
      # Mapping of a content media type to a xsd complex type.
      MEDIA_TYPE_MAPPING_TYPE = {
        :MediaType => String,
        :ComplexTypeName => String,
        :SchemaLocation => String
      }

      # Information for one version of the API.
      VERSION_INFO_TYPE = {
        :Version => String,
        :LoginUrl => String,
        :MediaTypeMapping => [MEDIA_TYPE_MAPPING_TYPE]
      }

      # List all supported versions.
      SUPPORTED_VERSIONS_TYPE = {
        :VersionInfo => [VERSION_INFO_TYPE]
      }

      # The standard error message type used in the vCloud REST API.
      ERROR_TYPE = {
        :majorErrorCode => String,
        :message => String,
        :minorErrorCode => String,
        :stackTrace => Fog::Nullable::String,
        :vendorSpecificErrorCode => Fog::Nullable::String
      }

      # The base type for all objects in the vCloud model. Has an optional list
      # of links and href and type attributes.
      REFERENCE_TYPE = {
        :href => String,
        :id => Fog::Nullable::String,
        :name => Fog::Nullable::String,
        :type => Fog::Nullable::String
      }

      # Extends reference type by adding relation attribute. Defines a
      # hyper-link with a relationship, hyper-link reference, and an optional
      # MIME type.
      LINK_TYPE = REFERENCE_TYPE.merge({
        :rel => String
      })

      # Represents a reference to a resource. Contains an href attribute, a
      # resource status attribute, and optional name and type attributes.
      RESOURCE_REFERENCE_TYPE = REFERENCE_TYPE.merge({
        :status => Fog::Nullable::String
      })

      # The base type for all objects in the vCloud model. Has an optional list
      # of links and href and type attributes.
      RESOURCE_TYPE = {
        :href => Fog::Nullable::String,
        :type => Fog::Nullable::String,
      # :Link => [LINK_TYPE] -- FIXME: not required
      }

      # The base type for all resource types which contain an id attribute.
      IDENTIFIABLE_RESOURCE_TYPE = RESOURCE_TYPE.merge({
        :id => Fog::Nullable::String,
        :operationKey => Fog::Nullable::String,
      })

      # Basic entity type in the vCloud object model. Includes a name, an
      # optional description, and an optional list of links.
      ENTITY_TYPE = IDENTIFIABLE_RESOURCE_TYPE.merge({
        :name => String
      })

      # Represents a file to be transferred (uploaded or downloaded).
      FILE_TYPE = ENTITY_TYPE.merge({
        :bytesTransfered => Fog::Nullable::String,
        :checksum => Fog::Nullable::String, # normalizedString
        :size => Fog::Nullable::String
      })

      # Represents a list of files to be transferred (uploaded or downloaded).
      FILES_LIST_TYPE = {
        :File => [FILE_TYPE]
      }

      # Container for query result sets.
      CONTAINER_TYPE = RESOURCE_TYPE.merge({
        :name => String,
        :page => String,
        :pageSize => String,
        :total => String
      })

      # Represents an asynchronous operation in vCloud Director.
      TASK_TYPE = ENTITY_TYPE.merge({
        :cancelRequested => Fog::Nullable::String,
        :endTime => Fog::Nullable::String,
        :expiryTime => String,
        :operation => Fog::Nullable::String,
        :operationName => Fog::Nullable::String,
        :serviceNamespace => Fog::Nullable::String,
        :startTime => Fog::Nullable::String,
        :status => String,
      # :Tasks => TASKS_IN_PROGRESS_TYPE, # not happening!
        :Owner => REFERENCE_TYPE,
      # :Error => ERROR_TYPE,
        :User => REFERENCE_TYPE,
        :Organization => REFERENCE_TYPE,
        :Progress => Fog::Nullable::String,
      # :Params => anyType,
        :Details => Fog::Nullable::String
      })

      # A list of queued, running, or recently completed tasks.
      TASKS_IN_PROGRESS_TYPE = {
        :Task => [TASK_TYPE]
      }

      # Base type that represents a resource entity such as a vApp template or
      # virtual media.
      RESOURCE_ENTITY_TYPE = ENTITY_TYPE.merge({
        :status => Fog::Nullable::String,
        :Description => Fog::Nullable::String,
      # :Tasks => TASKS_IN_PROGRESS_TYPE,
      #  :Files => FILES_LIST_TYPE
      })

      # Container for references to ResourceEntity objects in this vDC.
      RESOURCE_ENTITIES_TYPE = {
        :ResourceEntity => [RESOURCE_REFERENCE_TYPE]
      }

      # Represents a supported virtual hardware version.
      SUPPORTED_HARDWARE_VERSION_TYPE = String

      # Contains a list of VMware virtual hardware versions supported in this
      # vDC.
      SUPPORTED_HARDWARE_VERSIONS_TYPE = {
        :SupportedHardwareVersion => SUPPORTED_HARDWARE_VERSION_TYPE
      }

      # Represents a base type for VAppType and VmType.
      ABSTRACT_VAPP_TYPE = RESOURCE_ENTITY_TYPE.merge({
        :deployed => String,
        :DateCreated => String
      })

      VAPP_CHILDREN_TYPE = {
        #:VApp => ABSTRACT_VAPP_TYPE,
        :Vm => [ABSTRACT_VAPP_TYPE]
      }

      # Controls access to the resource.
      ACCESS_SETTING_TYPE = {
        :Subject => REFERENCE_TYPE,
        :AccessLevel => String
      }

      # A list of access settings for a resource.
      ACCESS_SETTINGS_TYPE = {
        :AccessSettingType => [ACCESS_SETTING_TYPE]
      }

      # Container for references to available organization vDC networks.
      AVAILABLE_NETWORKS_TYPE = {
        :Network => [REFERENCE_TYPE]
      }

      # Collection of supported hardware capabilities.
      CAPABILITIES_TYPE = {
        :SupportedHardwareVersions => SUPPORTED_HARDWARE_VERSIONS_TYPE
      }

      # Represents the capacity of a given resource.
      CAPACITY_TYPE = {
        :Units => String,
        :Allocated => Fog::Nullable::String,
        :Limit => String
      }

      # Represents a capacity and usage of a given resource.
      CAPACITY_WITH_USAGE_TYPE = CAPACITY_TYPE.merge({
        :Reserved => String,
        :Used => Fog::Nullable::String,
        :Overhead => Fog::Nullable::String
      })

      # Represents vDC compute capacity.
      COMPUTE_CAPACITY_TYPE = {
        :Cpu => CAPACITY_WITH_USAGE_TYPE,
        :Memory => CAPACITY_WITH_USAGE_TYPE
      }

      # Represents a guest customization settings.
      GUEST_CUSTOMIZATION_SECTION_TYPE = { # TODO: extends Section_Type
        :Enabled => Fog::Nullable::String,
        :ChangeSid => Fog::Nullable::String,
        :VirtualMachineId => Fog::Nullable::String,
        :JoinDomainEnabled => Fog::Nullable::String,
        :UseOrgSettings => Fog::Nullable::String,
        :DomainName => Fog::Nullable::String,
        :DomainUserName => Fog::Nullable::String,
        :DomainUserPassword => Fog::Nullable::String,
        :MachineObjectOU => Fog::Nullable::String,
        :AdminPasswordEnabled => Fog::Nullable::String,
        :AdminPasswordAuto => Fog::Nullable::String,
        :AdminPassword => Fog::Nullable::String,
        :ResetPasswordRequired => Fog::Nullable::String,
        :CustomizationScript => Fog::Nullable::String,
        :ComputerName => String,
        :Link => LINK_TYPE
      }

      # Represents the owner of this entity.
      OWNER_TYPE = RESOURCE_TYPE.merge({
        :User => REFERENCE_TYPE
      })

      # VMware Tools and other runtime information for this virtual machine.
      RUNTIME_INFO_SECTION_TYPE = { # TODO: extends Section_Type
        :VMWareTools => {
          :version => Fog::Nullable::String
        }
      }

      # Container for references to storage profiles associated with a vDC.
      VDC_STORAGE_PROFILES_TYPE = {
        :VdcStorageProfile => [REFERENCE_TYPE]
      }

      # Allows you to specify certain capabilities of this virtual machine.
      VM_CAPABILITIES_TYPE = RESOURCE_TYPE.merge({
        :MemoryHotAddEnabled => String,
        :CpuHotAddEnabled => String
      })

      # Represents the user view of a Catalog object.
      CATALOG_TYPE = ENTITY_TYPE.merge({
        #:Owner => OWNER_TYPE,
        #:CatalogItems => CATALOG_ITEMS_TYPE,
        :IsPublished => String,
        :DateCreated => String
      })

      # Specifies access controls for a resource.
      CONTROL_ACCESS_PARAMS_TYPE = {
        :IsSharedToEveryone => String,
        :EveryoneAccessLevel => Fog::Nullable::String,
      # :AccessSettings => ACCESS_SETTINGS_TYPE
      }

      # Represents a Media object.
      MEDIA_TYPE = RESOURCE_ENTITY_TYPE.merge({
        :imageType => String,
        :size => String,
        :Owner => OWNER_TYPE,
        :VdcStorageProfile => REFERENCE_TYPE
      })

      METADATA_TYPE = RESOURCE_TYPE.merge({
        #:MetadataEntry => METADATA_ENTRY_TYPE
      })

      # Represents a list of organizations.
      ORG_LIST_TYPE = RESOURCE_TYPE.merge({
        :Org => [REFERENCE_TYPE]
      })

      # Represents the user view of a vCloud Director organization.
      ORG_TYPE = ENTITY_TYPE.merge({
        :Description => Fog::Nullable::String,
        :Tasks => TASKS_IN_PROGRESS_TYPE,
        :FullName => String,
        :IsEnabled => Fog::Nullable::String
      })

      # Represents a vCloud Session.
      SESSION_TYPE = RESOURCE_TYPE.merge({
        :org => String,
        :user => String,
        :Link => [LINK_TYPE]
      })

      # A list of tasks.
      TASKS_LIST_TYPE = ENTITY_TYPE.merge({
        #:Task => TASK_TYPE
      })
      # Represents a vApp.
      VAPP_TYPE = ABSTRACT_VAPP_TYPE.merge({
        :ovfDescriptorUploaded => String,
        :Owner => OWNER_TYPE,
        :InMaintenanceMode => String,
        :Children => VAPP_CHILDREN_TYPE
      })

      # Represents the user view of an organization vDC.
      VDC_TYPE = ENTITY_TYPE.merge({
        :status => Fog::Nullable::String,
        :AllocationModel => String,
      # :StorageCapacity => CAPACITY_WITH_USAGE_TYPE,
        :ComputeCapacity => COMPUTE_CAPACITY_TYPE,
        :ResourceEntities => RESOURCE_ENTITIES_TYPE,
        :AvailableNetworks => AVAILABLE_NETWORKS_TYPE,
        :Capabilities => CAPABILITIES_TYPE,
        :NicQuota => String,
        :NetworkQuota => String,
        :UsedNetworkCount => String,
        :VmQuota => Fog::Nullable::String,
        :IsEnabled => Fog::Nullable::String,
        :VdcStorageProfiles => VDC_STORAGE_PROFILES_TYPE # >= 5.1
      })

      # Represents a storage profile in an organization vDC.
      VDC_STORAGE_PROFILE_TYPE = ENTITY_TYPE.merge({
        :Enabled => Fog::Nullable::String,
        :Units => String,
        :Limit => String,
        :Default => String
      })

      # Information about an individual operating system.
      OPERATING_SYSTEM_INFO_TYPE = {
        :OperatingSystemId => String,
        :DefaultHardDiskAdapterType => String,
        :MinimumHardDiskSizeGigabytes => String,
        :MinimumMemoryMegabytes => String,
        :Name => String,
        :InternalName => String,
        :Supported => String,
        :x64 => String,
        :MaximumCpuCount => String,
        :MinimumHardwareVersion => String,
        :PersonalizationEnabled => String,
        :PersonalizationAuto => String,
        :SysprepPackagingSupported => String,
        :SupportsMemHotAdd => String,
        :cimOsId => String,
        :CimVersion => String,
        :SupportedForCreate => String
      }

      # Represents an operating system family.
      OPERATING_SYSTEM_FAMILY_INFO_TYPE = {
        :Name => String,
        :OperatingSystemFamilyId => String,
        :OperatingSystem => [OPERATING_SYSTEM_INFO_TYPE]
      }

      # Operating systems available for use on virtual machines owned by this
      # organization.
      SUPPORTED_OPERATING_SYSTEMS_INFO_TYPE = RESOURCE_TYPE.merge({
        :OperatingSystemFamilyInfo => [OPERATING_SYSTEM_FAMILY_INFO_TYPE]
      })

      # Container for query results in records format.
      #   Combine with QUERY_RESULT_RECORD_TYPE subtypes to validate query results
      QUERY_RESULT_RECORDS_TYPE = CONTAINER_TYPE

      # Base type for a single record from query result in records format.
      # Subtypes define more specific elements.
      QUERY_RESULT_RECORD_TYPE = {
        :href => String,
        :id => Fog::Nullable::String,
        :type => Fog::Nullable::String
      }

      # Type for a single edgeGateway query result in records format.
      QUERY_RESULT_EDGE_GATEWAY_RECORD_TYPE = QUERY_RESULT_RECORD_TYPE.merge({
        :gatewayStatus => String,
        :haStatus => String,
        :isBusy => String,
        :name => String,
        :numberOfExtNetworks => String,
        :numberOfOrgNetworks=> String,
        :vdc => String
      })

      FIREWALL_RULE_TYPE__PROTOCOLS = {
        :Icmp => Fog::Nullable::String,
        :Asny => Fog::Nullable::String,
        :Other => Fog::Nullable::String
      }

      # Represents a firewall rule.
      FIREWALL_RULE_TYPE = {
        :Id => String,
        :IsEnabled => String,
        :MatchOnTranslate => Fog::Nullable::String,
        :Description => Fog::Nullable::String,
        :Policy => Fog::Nullable::String,
        :IcmpSubType => Fog::Nullable::String,
        :Port => Fog::Nullable::String,
        :DestinationPortRange => String,
        :SourcePort => Fog::Nullable::String,
        :SourcePortRange => String,
        :Direction => Fog::Nullable::String,
        :EnableLogging => Fog::Nullable::String,
        :Protocols => FIREWALL_RULE_TYPE__PROTOCOLS
      }

      # Represents a network firewall service.
      FIREWALL_SERVICE_TYPE = {
        :IsEnabled => String,
        :DefaultAction => String,
        :LogDefaultAction => String,
        #:FirewallRule => [FIREWALL_RULE_TYPE]  # not required
      }

      #Represents the SNAT and DNAT rules.
      GATEWAY_NAT_RULE_TYPE = {
        :Interface => REFERENCE_TYPE,
        :OriginalIp => String,
        :OriginalPort => Fog::Nullable::String,
        :TranslatedIp => String,
        :TranslatedPort => Fog::Nullable::String,
        :Protocol => Fog::Nullable::String,
        :IcmpSubType => Fog::Nullable::String
      }

      #Represents a NAT rule.
      NAT_RULE_TYPE = {
        :Description => Fog::Nullable::String,
        :RuleType => String,
        :IsEnabled => String,
        :Id => String,
        :GatewayNatRule => GATEWAY_NAT_RULE_TYPE
      }

      # Represents a NAT network service.
      NAT_SERVICE_TYPE = {
        :IsEnabled => String,
        :NatType => Fog::Nullable::String,
        :Policy => Fog::Nullable::String,
        #:NatRule => [NAT_RULE_TYPE],  # not required
        :ExternalIp => Fog::Nullable::String
      }

      # Represents a service port in a load balancer pool.
      LB_POOL_SERVICE_PORT_TYPE = {
        :IsEnabled => Fog::Nullable::String,
        :Protocol => String,
        :Algorithm => Fog::Nullable::String,
        :Port => String,
        :HealthCheckPort => String,
        #:HealthCheck => LBPoolHealthCheckType  # not required
      }

      # Represents a member in a load balancer pool.
      LB_POOL_MEMBER_TYPE = {
        :IpAddress => String,
        :Weight => String,
        :ServicePort => [LB_POOL_SERVICE_PORT_TYPE]
      }

      # Represents a load balancer pool.
      LOAD_BALANCER_POOL_TYPE = {
        :Id => Fog::Nullable::String,
        :Name => String,
        :Description => Fog::Nullable::String,
        :ServicePort => [LB_POOL_SERVICE_PORT_TYPE],
        :Member => [LB_POOL_MEMBER_TYPE],
        :Operational => String,
        :ErrorDetails => Fog::Nullable::String
      }

      # Represents persistence type for a load balancer service profile.
      LB_PERSISTENCE_TYPE = {
        :Method => String,
        :CookieName => Fog::Nullable::String,
        :CookieMode => Fog::Nullable::String
      }

      # Represents service profile for a load balancing virtual server.
      LB_VIRTUAL_SERVER_SERVICE_PROFILE_TYPE = {
        :IsEnabled => String,
        :Protocol => String,
        :Port => String,
        :Persistence => LB_PERSISTENCE_TYPE
      }

      # Information about a vendor service template. This is optional.
      VENDOR_TEMPLATE_TYPE = {
        :Name => String,
        :Id => String
      }

      # Represents a load balancer virtual server.
      LOAD_BALANCER_VIRTUAL_SERVER_TYPE = {
        :IsEnabled => String,
        :Name => String,
        :Description => Fog::Nullable::String,
        :Interface => REFERENCE_TYPE,
        :IpAddress => String,
        :ServiceProfile => [LB_VIRTUAL_SERVER_SERVICE_PROFILE_TYPE],
        :Logging => String,
        :Pool => String,
        #:LoadBalancerTemplates => VENDOR_TEMPLATE_TYPE  # not required
      }

      # Represents gateway load balancer service.
      LOAD_BALANCER_SERVICE_TYPE = {
        :Pool => LOAD_BALANCER_POOL_TYPE,
        :VirtualServer => LOAD_BALANCER_VIRTUAL_SERVER_TYPE,
        :IsEnabled => Fog::Nullable::String
      }

      # Represents Gateway DHCP service.
      GATEWAY_DHCP_SERVICE_TYPE = {
        :IsEnabled => String,
        #:Pool => DHCP_POOL_SERVICE_TYPE  # not required
      }

      # Represents edge gateway services.
      GATEWAY_FEATURES_TYPE = {
        #:StaticRoutingService => STATIC_ROUTING_SERVICE_TYPE, #not required
        #:GatewayIpsecVpnService => GATEWAY_IPSEC_VPN_SERVICE_TYPE, #not required
        #:GatewayDhcpService => GATEWAY_DHCP_SERVICE_TYPE, #not required
        #:LoadBalancerService => LOAD_BALANCER_SERVICE_TYPE,  #not required
        #:NatService => NAT_SERVICE_TYPE,  #not required
        :FirewallService => FIREWALL_SERVICE_TYPE
      }

      # Represents a range of IP addresses, start and end inclusive.
      IP_RANGE_TYPE = {
        :StartAddress => String,
        :EndAddress => String
      }

      # Represents a list of IP ranges.
      IP_RANGES_TYPE = {
        :IpRange => [IP_RANGE_TYPE]
      }

      # Allows to chose which subnets a gateway can be part of
      SUBNET_PARTICIPATION_TYPE = {
        :Gateway => String,
        :Netmask => String,
        :IpAddress => String,
        :IpRanges => IP_RANGES_TYPE
      }

      # Gateway Interface configuration.
      GATEWAY_INTERFACE_TYPE = {
        :Name => String,
        :DisplayName => String,
        :Network => REFERENCE_TYPE,
        :InterfaceType => String,
        #:SubnetParticipation => [SUBNET_PARTICIPATION_TYPE], #bug in parser means list or hash
        :ApplyRateLimit => String,
        :InRateLimit => Fog::Nullable::String,
        :OutRateLimit => Fog::Nullable::String,
        :UseForDefaultRoute => String,
      }

      # A list of Gateway Interfaces.
      GATEWAY_INTERFACES_TYPE = {
        :GatewayInterface => [GATEWAY_INTERFACE_TYPE]
      }

      # Gateway Configuration.
      GATEWAY_CONFIGURATION_TYPE = {
        :BackwardCompatibilityMode => Fog::Nullable::String,
        :GatewayBackingConfig => String,
        :GatewayInterfaces => GATEWAY_INTERFACES_TYPE,
        :EdgeGatewayServiceConfiguration => GATEWAY_FEATURES_TYPE,
        :HaEnabled => Fog::Nullable::String,
        :UseDefaultRouteForDnsRelay => Fog::Nullable::String
      }

      # Represents a gateway.
      GATEWAY_TYPE = {
        :href => String,
        :type => String,
        :id => String,
        :operationKey => Fog::Nullable::String,
        :name => String,
        :status => Fog::Nullable::String,
        #:Link => LINK_TYPE, # not required
        :Description => Fog::Nullable::String,
        #:Tasks => TASKS_IN_PROGRESS_TYPE,  # not required
        :Configuration => GATEWAY_CONFIGURATION_TYPE
      }

      ORGANIZATION_REFERENCE_TYPE = REFERENCE_TYPE
      PROVIDER_VDC_REFERENCE_TYPE = REFERENCE_TYPE
      RIGHT_REFERENCE_TYPE = REFERENCE_TYPE
      ROLE_REFERENCE_TYPE = REFERENCE_TYPE

      # Represents the admin view of this cloud.
      ORGANIZATION_REFERENCES_TYPE = {
        :OrganizationReference => [REFERENCE_TYPE]
      }

      # Container for references to Provider vDCs.
      PROVIDER_VDC_REFERENCES_TYPE = {
        :ProviderVdcReference => [PROVIDER_VDC_REFERENCE_TYPE]
      }

      # Container for references to rights.
      RIGHT_REFERENCES_TYPE = {
        :RightReference => [RIGHT_REFERENCE_TYPE]
      }

      # Container for references to roles.
      ROLE_REFERENCES_TYPE = {
        :RoleReference => [ROLE_REFERENCE_TYPE]
      }

      # Container for references to ExternalNetwork objects.
      NETWORKS_TYPE = {
        :Network => [REFERENCE_TYPE]
      }

      NETWORK_CONFIGURATION_TYPE = {
        :IpScopes => {
          :IpScope => {
            :IsInherited => String,
            :Gateway => Fog::Nullable::String,
            :Netmask => String,
            :Dns1 => String,
            :Dns2 => String,
            :DnsSuffix => String,
            :IsEnabled=> String,
            :IpRanges=> IP_RANGES_TYPE,
          }
        },
        :FenceMode => Fog::Nullable::String,
        :RetainNetInfoAcrossDeployments => String,
      }

      NETWORK_TYPE = {
        :name => String,
        :href => String,
        :type => String,
        :id => String,
        :Description => String,
        :Configuration => NETWORK_CONFIGURATION_TYPE,
        :IsShared => String,
      }

      VCLOUD_TYPE = ENTITY_TYPE.merge({
        :OrganizationReferences => ORGANIZATION_REFERENCES_TYPE,
        :ProviderVdcReferences => PROVIDER_VDC_REFERENCES_TYPE,
        :RightReferences => RIGHT_REFERENCES_TYPE,
        :RoleReferences => ROLE_REFERENCES_TYPE,
        :Networks => NETWORKS_TYPE
      })

      # Represents a named disk.
      DISK_TYPE = RESOURCE_ENTITY_TYPE.merge({
        :busSubType => Fog::Nullable::String,
        :busType => Fog::Nullable::String,
        :size => String,
        :StorageProfile => REFERENCE_TYPE,
        :Owner => OWNER_TYPE
      })

      VMS_TYPE = RESOURCE_TYPE.merge({
        :VmReference => [REFERENCE_TYPE]
      })
    end
  end
end
