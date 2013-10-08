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
        :File => FILE_TYPE
      }

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
        :Error => ERROR_TYPE,
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
      # :Files => FILES_LIST_TYPE
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
        :Vm => ABSTRACT_VAPP_TYPE
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

      # Represents the owner of this entity.
      OWNER_TYPE = RESOURCE_TYPE.merge({
        :User => REFERENCE_TYPE
      })

      # Container for references to storage profiles associated with a vDC.
      VDC_STORAGE_PROFILES_TYPE = {
        :VdcStorageProfile => REFERENCE_TYPE
      }

      # Represents the user view of a Catalog object.
      CATALOG_TYPE = ENTITY_TYPE.merge({
        #:Owner => OWNER_TYPE,
        #:CatalogItems => CATALOG_ITEMS_TYPE,
        :IsPublished => String,
        :DateCreated => String
      })

      # Represents a Media object.
      MEDIA_TYPE = RESOURCE_ENTITY_TYPE.merge({
        :imageType => String,
        :size => String,
        :Owner => OWNER_TYPE,
        # TODO:
        #:VdcStorageProfiles => VDC_STORAGE_PROFILES_TYPE # >= 5.1
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
        # TODO:
        #:VdcStorageProfiles => VDC_STORAGE_PROFILES_TYPE # >= 5.1
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

    end
  end
end
