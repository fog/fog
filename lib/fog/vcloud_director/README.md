# VMware vCloud Director 5.1 API client

## Introduction

Collection and Model representation in vcloud_director fog provider.

```no-highlight
organizations
  organization
    vdcs -> vdc -> vapps -> vapp -> vms -> vm -> customizations -> script
                                              -> network
                                              -> disks -> disk
                                              -> tags -> tag
                                              -> power_on
    networks -> network
    catalogs -> catalog -> catalog_items -> catalog_item -> instantiate_vapp
    medias -> media
```

### Actions

Every collection supports the following methods:

Method Name       | Lazy Load
----------------- | ---------
get(id)           | false
get_by_name(name) | false
all               | true
all(false)        | false

### Lazy Loading

When listing a collection (eg: `vdc.vapps`), lazy load will be used by default
to improve the performance, otherwise it will make as many requests as items
are in the collection.

You can disable lazy load using the explict caller and passing a *false*
option: `vdc.vapps.all(false)`.

Attributes showing the value **NonLoaded** will be populated when accessing the
value, if there are more than one **NonLoaded** values the first time accessing
on any of those values will populate the others.

You can explicitly load those attributes with the `reload` method:

```ruby
org = vcloud.organizations.first
org.reload
```

Lazy load isn't used with `get` and `get_by_name` methods are used.

## Initialization

```ruby
vcloud = Fog::Compute::VcloudDirector.new(
  :vcloud_director_username => "<username>@<org_name>",
  :vcloud_director_password => "<password>",
  :vcloud_director_host => 'api.example.com',
  :vcloud_director_show_progress => false, # task progress bar on/off
)
```

## Organizations

### List Organizations

Note that when listing, by default only the attributes `id`, `name`, `type`,
and `href` are loaded. To disable lazy loading, and load all attributes, just
specify `false`. Another option is to reload a specific item:
`vcloud.organizations.first.reload`

```ruby
vcloud.organizations
```
```
  <Fog::Compute::VcloudDirector::Organizations
    [
      <Fog::Compute::VcloudDirector::Organization
        id="c6a4c623-c158-41cf-a87a-dbc1637ad55a",
        name="DevOps",
        type="application/vnd.vmware.vcloud.org+xml",
        href="https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a",
        description=NonLoaded
      >
    ]
  >
```

### Retrieve an Organization by Id

```ruby
org = vcloud.organizations.get("c6a4c623-c158-41cf-a87a-dbc1637ad55a")
```

### Retrieve an Organization by Name

```ruby
org = vcloud.organizations.get_by_name("DevOps")
```

## vDCs

It shows the Organization's vDCs.

### List vDCs

```ruby
org = vcloud.organizations.first
org.vdcs
```
```ruby
  <Fog::Compute::VcloudDirector::Vdcs
    organization=    <Fog::Compute::VcloudDirector::Organization
      id="c6a4c623-c158-41cf-a87a-dbc1637ad55a",
      name="DevOps",
      type="application/vnd.vmware.vcloud.org+xml",
      href="https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a",
      description=NonLoaded
    >
    [
      <Fog::Compute::VcloudDirector::Vdc
        id="9a06a16b-12c6-44dc-aee1-06aa52262ea3",
        name="DevOps - VDC",
        type="application/vnd.vmware.vcloud.vdc+xml",
        href="https://example.com/api/vdc/9a06a16b-12c6-44dc-aee1-06aa52262ea3",
        description=NonLoaded,
        available_networks=NonLoaded,
        compute_capacity_cpu=NonLoaded,
        compute_capacity_memory=NonLoaded,
        storage_capacity=NonLoaded,
        allocation_model=NonLoaded,
        capabilities=NonLoaded,
        nic_quota=NonLoaded,
        network_quota=NonLoaded,
        vm_quota=NonLoaded,
        is_enabled=NonLoaded
      >
    ]
  >
```

### Retrieve a vDC

```ruby
org = vcloud.organizations.first
org.vdcs.get_by_name("DevOps - VDC")
```
```ruby
  <Fog::Compute::VcloudDirector::Vdc
    id="9a06a16b-12c6-44dc-aee1-06aa52262ea3",
    name="DevOps - VDC",
    type="application/vnd.vmware.vcloud.vdc+xml",
    href="https://example.com/api/vdc/9a06a16b-12c6-44dc-aee1-06aa52262ea3",
    description="",
    available_networks={:type=>"application/vnd.vmware.vcloud.network+xml", :name=>"DevOps - Dev Network Connection", :href=>"https://example.com/api/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17"},
    compute_capacity_cpu=NonLoaded,
    compute_capacity_memory={:Units=>"MB", :Allocated=>"0", :Limit=>"0", :Used=>"3584", :Overhead=>"65"},
    storage_capacity={:Units=>"MB", :Allocated=>"1048320", :Limit=>"1048320", :Used=>"903168", :Overhead=>"0"},
    allocation_model="AllocationVApp",
    capabilities={:SupportedHardwareVersion=>"vmx-09"},
    nic_quota=0,
    network_quota=1024,
    vm_quota=0,
    is_enabled=true
  >
```

## vApps

### List vApps

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vdc.vapps
```
```ruby
  <Fog::Compute::VcloudDirector::Vapps
    vdc=    <Fog::Compute::VcloudDirector::Vdc
      id="9a06a16b-12c6-44dc-aee1-06aa52262ea3",
      name="DevOps - VDC",
      type="application/vnd.vmware.vcloud.vdc+xml",
      href="https://example.com/api/vdc/9a06a16b-12c6-44dc-aee1-06aa52262ea3",
      description=NonLoaded,
      available_networks=NonLoaded,
      compute_capacity_cpu=NonLoaded,
      compute_capacity_memory=NonLoaded,
      storage_capacity=NonLoaded,
      allocation_model=NonLoaded,
      capabilities=NonLoaded,
      nic_quota=NonLoaded,
      network_quota=NonLoaded,
      vm_quota=NonLoaded,
      is_enabled=NonLoaded
    >
    [
      <Fog::Compute::VcloudDirector::Vapp
        id="vapp-11c7102f-443d-40fd-b1da-cca981fb44b6",
        name="segundo",
        type="application/vnd.vmware.vcloud.vApp+xml",
        href="https://example.com/api/vApp/vapp-11c7102f-443d-40fd-b1da-cca981fb44b6",
        description=NonLoaded,
        deployed=NonLoaded,
        status=NonLoaded,
        deployment_lease_in_seconds=NonLoaded,
        storage_lease_in_seconds=NonLoaded,
        startup_section=NonLoaded,
        network_section=NonLoaded,
        network_config=NonLoaded,
        owner=NonLoaded,
        InMaintenanceMode=NonLoaded
      >,
      <Fog::Compute::VcloudDirector::Vapp
        id="vapp-6ac43e0e-13e2-4642-a58a-6dc3a12f585b",
        name="vApp_restebanez_9",
        type="application/vnd.vmware.vcloud.vApp+xml",
        href="https://example.com/api/vApp/vapp-6ac43e0e-13e2-4642-a58a-6dc3a12f585b",
        description=NonLoaded,
        deployed=NonLoaded,
        status=NonLoaded,
        deployment_lease_in_seconds=NonLoaded,
        storage_lease_in_seconds=NonLoaded,
        startup_section=NonLoaded,
        network_section=NonLoaded,
        network_config=NonLoaded,
        owner=NonLoaded,
        InMaintenanceMode=NonLoaded
      >
    ]
  >
```

### Retrieve a vApp

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vdc.vapps.get_by_name("segundo")
```
```ruby
  <Fog::Compute::VcloudDirector::Vapp
    id="vapp-11c7102f-443d-40fd-b1da-cca981fb44b6",
    name="segundo",
    type="application/vnd.vmware.vcloud.vApp+xml",
    href="https://example.com/api/vApp/vapp-11c7102f-443d-40fd-b1da-cca981fb44b6",
    description="",
    deployed=false,
    status="8",
    deployment_lease_in_seconds=NonLoaded,
    storage_lease_in_seconds="7776000",
    startup_section={:ovf_stopDelay=>"0", :ovf_stopAction=>"powerOff", :ovf_startDelay=>"0", :ovf_startAction=>"powerOn", :ovf_order=>"0", :ovf_id=>"DEVWEB"},
    network_section={:ovf_name=>"DevOps - Dev Network Connection", :"ovf:Description"=>""},
    network_config={:networkName=>"DevOps - Dev Network Connection", :Link=>{:rel=>"repair", :href=>"https://example.com/api/admin/network/82a07044-4dda-4a3e-a53d-8981cf0d5baa/action/reset"}, :Description=>"", :Configuration=>{:IpScope=>{:IsInherited=>"true", :Gateway=>"10.192.0.1", :Netmask=>"255.255.252.0", :Dns1=>"10.192.0.11", :Dns2=>"10.192.0.12", :DnsSuffix=>"dev.ad.mdsol.com", :IpRanges=>{:IpRange=>{:StartAddress=>"10.192.0.100", :EndAddress=>"10.192.3.254"}}}, :ParentNetwork=>{:name=>"DevOps - Dev Network Connection", :id=>"d5f47bbf-de27-4cf5-aaaa-56772f2ccd17", :href=>"https://example.com/api/admin/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17"}, :FenceMode=>"bridged", :RetainNetInfoAcrossDeployments=>"false"}, :IsDeployed=>"false"},
    owner={:type=>"application/vnd.vmware.admin.user+xml", :name=>"restebanez", :href=>"https://example.com/api/admin/user/c3ca7b97-ddea-425f-8bdb-1fdb946f7349"},
    InMaintenanceMode=false
  >
```

## VMs

### List VMs

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vapp.vms
```
```ruby
  <Fog::Compute::VcloudDirector::Vms
    vapp=    <Fog::Compute::VcloudDirector::Vapp
      id="vapp-11c7102f-443d-40fd-b1da-cca981fb44b6",
      name="segundo",
      type="application/vnd.vmware.vcloud.vApp+xml",
      href="https://example.com/api/vApp/vapp-11c7102f-443d-40fd-b1da-cca981fb44b6",
      description="",
      deployed=false,
      status="8",
      deployment_lease_in_seconds=NonLoaded,
      storage_lease_in_seconds="7776000",
      startup_section={:ovf_stopDelay=>"0", :ovf_stopAction=>"powerOff", :ovf_startDelay=>"0", :ovf_startAction=>"powerOn", :ovf_order=>"0", :ovf_id=>"DEVWEB"},
      network_section={:ovf_name=>"DevOps - Dev Network Connection", :"ovf:Description"=>""},
      network_config={:networkName=>"DevOps - Dev Network Connection", :Link=>{:rel=>"repair", :href=>"https://example.com/api/admin/network/82a07044-4dda-4a3e-a53d-8981cf0d5baa/action/reset"}, :Description=>"", :Configuration=>{:IpScope=>{:IsInherited=>"true", :Gateway=>"10.192.0.1", :Netmask=>"255.255.252.0", :Dns1=>"10.192.0.11", :Dns2=>"10.192.0.12", :DnsSuffix=>"dev.ad.mdsol.com", :IpRanges=>{:IpRange=>{:StartAddress=>"10.192.0.100", :EndAddress=>"10.192.3.254"}}}, :ParentNetwork=>{:name=>"DevOps - Dev Network Connection", :id=>"d5f47bbf-de27-4cf5-aaaa-56772f2ccd17", :href=>"https://example.com/api/admin/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17"}, :FenceMode=>"bridged", :RetainNetInfoAcrossDeployments=>"false"}, :IsDeployed=>"false"},
      owner={:type=>"application/vnd.vmware.admin.user+xml", :name=>"restebanez", :href=>"https://example.com/api/admin/user/c3ca7b97-ddea-425f-8bdb-1fdb946f7349"},
      InMaintenanceMode=false
    >
    [
      <Fog::Compute::VcloudDirector::Vm
        id="vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192",
        vapp_id="vapp-11c7102f-443d-40fd-b1da-cca981fb44b6",
        name="DEVWEB",
        type="application/vnd.vmware.vcloud.vm+xml",
        href="https://example.com/api/vApp/vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192",
        status="off",
        operating_system="Microsoft Windows Server 2008 R2 (64-bit)",
        ip_address="10.192.0.144",
        cpu=3,
        memory=3584,
        hard_disks=[{"Hard disk 1"=>163840}]
      >
    ]
  >
```

### Retrieve a VM

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vapp.vms.get_by_name("DEVWEB")
```
```ruby
  <Fog::Compute::VcloudDirector::Vm
    id="vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192",
    vapp_id="vapp-11c7102f-443d-40fd-b1da-cca981fb44b6",
    name="DEVWEB",
    type="application/vnd.vmware.vcloud.vm+xml",
    href="https://example.com/api/vApp/vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192",
    status="off",
    operating_system="Microsoft Windows Server 2008 R2 (64-bit)",
    ip_address="10.192.0.144",
    cpu=3,
    memory=3584,
    hard_disks=[{"Hard disk 1"=>163840}]
  >
```

### Modify CPU

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
vm.cpu = 4
```
```no-highlight
4
```

### Modify Memory

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
vm.memory = 4096
```
```no-highlight
4096
```

### Power On a VM

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
vm.power_on
```
```no-highlight
true
```

## VM Customization

### Retrieve VM Customization

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
vm.customization
```
```ruby
  <Fog::Compute::VcloudDirector::VmCustomization
    id="vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192",
    type="application/vnd.vmware.vcloud.guestCustomizationSection+xml",
    href="https://example.com/api/vApp/vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192/guestCustomizationSection/",
    enabled=false,
    change_sid=false,
    join_domain_enabled=false,
    use_org_settings=false,
    admin_password_auto=false,
    admin_password='',
    admin_password_enabled=false,
    reset_password_required=false,
    virtual_machine_id="2ddeea36-ac71-470f-abc5-c6e3c2aca192",
    computer_name="DEVWEB-001",
    has_customization_script=true
  >
```

### Modify VM Customization

Customization attributes model requires to `save` it after setting the
attributes.

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
customization = vm.customization
customization.compute_name = "NEWNAME"
customization.enabled = false
customization.script = "new userdata script"
customization.save
```
```no-highlight
true
```

## VM Network

### Show VM Networks

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
vm.network
```
```ruby
    <Fog::Compute::VcloudDirector::VmNetwork
    id="vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192",
    type="application/vnd.vmware.vcloud.networkConnectionSection+xml",
    href="https://example.com/api/vApp/vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192/networkConnectionSection/",
    info="Specifies the available VM network connections",
    primary_network_connection_index=0,
    network="DevOps - Dev Network Connection",
    needs_customization=true,
    network_connection_index=0,
    is_connected=true,
    mac_address="00:50:56:01:00:ea",
    ip_address_allocation_mode="POOL"
  >
```

### Modify one or more attributes

Network attributes model requires to `save` it after setting the attributes.

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
network = vm.network
network.is_connected = false
network.ip_address_allocation_mode = "DHCP"
network.save
```
```no-highlight
true
```

## VM Disk

### List VM Disks

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
vm.disks
```
```ruby
  <Fog::Compute::VcloudDirector::Disks
    vm=    <Fog::Compute::VcloudDirector::Vm
      id="vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192",
      vapp_id="vapp-11c7102f-443d-40fd-b1da-cca981fb44b6",
      name="DEVWEB",
      type="application/vnd.vmware.vcloud.vm+xml",
      href="https://example.com/api/vApp/vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192",
      status="off",
      operating_system="Microsoft Windows Server 2008 R2 (64-bit)",
      ip_address="10.192.0.144",
      cpu=4,
      memory=4096,
      hard_disks=[{"Hard disk 1"=>163840}]
    >
    [
      <Fog::Compute::VcloudDirector::Disk
        id=2,
        address=0,
        description="SCSI Controller",
        name="SCSI Controller 0",
        resource_sub_type="lsilogicsas",
        resource_type=6,
        address_on_parent=nil,
        parent=nil,
        capacity=nil,
        bus_sub_type=nil,
        bus_type=nil
      >,
      <Fog::Compute::VcloudDirector::Disk
        id=2000,
        address=nil,
        description="Hard disk",
        name="Hard disk 1",
        resource_sub_type=nil,
        resource_type=17,
        address_on_parent=0,
        parent=2,
        capacity=163840,
        bus_sub_type="lsilogicsas",
        bus_type=6
      >,
      <Fog::Compute::VcloudDirector::Disk
        id=3,
        address=0,
        description="IDE Controller",
        name="IDE Controller 0",
        resource_sub_type=nil,
        resource_type=5,
        address_on_parent=nil,
        parent=nil,
        capacity=nil,
        bus_sub_type=nil,
        bus_type=nil
      >
    ]
  >
```

### Create a New Disk

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
vm.disks.create(1024)
```
```no-highlight
true
```

The new disk should show up.

```ruby
>> vm.disks
  <Fog::Compute::VcloudDirector::Disks
    vm=    <Fog::Compute::VcloudDirector::Vm
      id="vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192",
      vapp_id="vapp-11c7102f-443d-40fd-b1da-cca981fb44b6",
      name="DEVWEB",
      type="application/vnd.vmware.vcloud.vm+xml",
      href="https://example.com/api/vApp/vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192",
      status="off",
      operating_system="Microsoft Windows Server 2008 R2 (64-bit)",
      ip_address="10.192.0.144",
      cpu=4,
      memory=4096,
      hard_disks=[{"Hard disk 1"=>163840}]
    >
    [
      <Fog::Compute::VcloudDirector::Disk
        id=2,
        address=0,
        description="SCSI Controller",
        name="SCSI Controller 0",
        resource_sub_type="lsilogicsas",
        resource_type=6,
        address_on_parent=nil,
        parent=nil,
        capacity=nil,
        bus_sub_type=nil,
        bus_type=nil
      >,
      <Fog::Compute::VcloudDirector::Disk
        id=2000,
        address=nil,
        description="Hard disk",
        name="Hard disk 1",
        resource_sub_type=nil,
        resource_type=17,
        address_on_parent=0,
        parent=2,
        capacity=163840,
        bus_sub_type="lsilogicsas",
        bus_type=6
      >,
      <Fog::Compute::VcloudDirector::Disk
        id=2001,
        address=nil,
        description="Hard disk",
        name="Hard disk 2",
        resource_sub_type=nil,
        resource_type=17,
        address_on_parent=1,
        parent=2,
        capacity=1024,
        bus_sub_type="lsilogicsas",
        bus_type=6
      >,
      <Fog::Compute::VcloudDirector::Disk
        id=3,
        address=0,
        description="IDE Controller",
        name="IDE Controller 0",
        resource_sub_type=nil,
        resource_type=5,
        address_on_parent=nil,
        parent=nil,
        capacity=nil,
        bus_sub_type=nil,
        bus_type=nil
      >
    ]
  >
```

### Modify the Hard Disk Size

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
disk = vm.disks.get_by_name("Hard disk 2")
disk.capacity = 2048
```
```no-highlight
true
```

### Destroy a Hard Disk

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
disk = vm.disks.get_by_name("Hard disk 2")
disk.destroy
```
```no-highlight
true
```

## VM Tags

### List VM Tags

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
vm.tags
```
```ruby
  <Fog::Compute::VcloudDirector::Tags
    vm=    <Fog::Compute::VcloudDirector::Vm
      id="vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192",
      vapp_id="vapp-11c7102f-443d-40fd-b1da-cca981fb44b6",
      name="DEVWEB",
      type="application/vnd.vmware.vcloud.vm+xml",
      href="https://example.com/api/vApp/vm-2ddeea36-ac71-470f-abc5-c6e3c2aca192",
      status="off",
      operating_system="Microsoft Windows Server 2008 R2 (64-bit)",
      ip_address="10.192.0.144",
      cpu=4,
      memory=4096,
      hard_disks=[{"Hard disk 1"=>163840}]
    >
    [
      <Fog::Compute::VcloudDirector::Tag
        id="environment",
        value="devlab"
      >,
      <Fog::Compute::VcloudDirector::Tag
        id="product",
        value="devlabtest"
      >,
      <Fog::Compute::VcloudDirector::Tag
        id="hello",
        value="ddd"
      >,
      <Fog::Compute::VcloudDirector::Tag
        id="uno",
        value="jander"
      >
    ]
  >
```

### Create a Tag

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
vm.tags.create('this_is_a_key', 'this_is_a_value')
```
```no-highlight
true
```

### Retrieve a Tag

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
vm.tags.get_by_name('this_is_a_key')
```
```ruby
  <Fog::Compute::VcloudDirector::Tag
    id="this_is_a_key",
    value="this_is_a_value"
  >
```

### Modify a Tag

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
vm.tags.get_by_name('this_is_a_key').value = 'new_value'
```
```no-highlight
"new_value"
```

### Destroy a Tag

```ruby
org = vcloud.organizations.first
vdc = org.vdcs.first
vapp = vdc.vapps.get_by_name("segundo")
vm = vapp.vms.get_by_name("DEVWEB")
vm.tags.get_by_name('this_is_a_key').destroy
```
```no-highlight
true
```

## Networks

It shows the Organization's Networks.

### List Networks

```ruby
org = vcloud.organizations.first
org.networks
```
```ruby
  <Fog::Compute::VcloudDirector::Networks
    organization=    <Fog::Compute::VcloudDirector::Organization
      id="c6a4c623-c158-41cf-a87a-dbc1637ad55a",
      name="DevOps",
      type="application/vnd.vmware.vcloud.org+xml",
      href="https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a",
      description=NonLoaded
    >
    [
      <Fog::Compute::VcloudDirector::Network
        id="d5f47bbf-de27-4cf5-aaaa-56772f2ccd17",
        name="DevOps - Dev Network Connection",
        type="application/vnd.vmware.vcloud.orgNetwork+xml",
        href="https://example.com/api/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17",
        description=NonLoaded,
        is_inherited=NonLoaded,
        gateway=NonLoaded,
        netmask=NonLoaded,
        dns1=NonLoaded,
        dns2=NonLoaded,
        dns_suffix=NonLoaded,
        ip_ranges=NonLoaded
      >
    ]
  >
```

### Retrieve a Network

```ruby
org = vcloud.organizations.first
org.networks.get_by_name("DevOps - Dev Network Connection")
```
```ruby
  <Fog::Compute::VcloudDirector::Network
    id="d5f47bbf-de27-4cf5-aaaa-56772f2ccd17",
    name="DevOps - Dev Network Connection",
    type="application/vnd.vmware.vcloud.orgNetwork+xml",
    href="https://example.com/api/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17",
    description=nil,
    is_inherited=true,
    gateway="10.192.0.1",
    netmask="255.255.252.0",
    dns1="10.192.0.11",
    dns2="10.192.0.12",
    dns_suffix="dev.ad.mdsol.com",
    ip_ranges=[{:start_address=>"10.192.0.100", :end_address=>"10.192.3.254"}]
  >
```

## Catalogs

It shows the Organization's Catalogs.

### List Catalogs

```ruby
org = vcloud.organizations.first
org.catalogs
```
```ruby
  <Fog::Compute::VcloudDirector::Catalogs
    organization=    <Fog::Compute::VcloudDirector::Organization
      id="c6a4c623-c158-41cf-a87a-dbc1637ad55a",
      name="DevOps",
      type="application/vnd.vmware.vcloud.org+xml",
      href="https://example.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a",
      description=NonLoaded
    >
    [
      <Fog::Compute::VcloudDirector::Catalog
        id="4ee720e5-173a-41ac-824b-6f4908bac975",
        name="Public VM Templates",
        type="application/vnd.vmware.vcloud.catalog+xml",
        href="https://example.com/api/catalog/4ee720e5-173a-41ac-824b-6f4908bac975",
        description=NonLoaded,
        is_published=NonLoaded
      >,
      <Fog::Compute::VcloudDirector::Catalog
        id="ea0c6acf-c9c0-46b7-b19f-4b2d3bf8aa33",
        name="prueba",
        type="application/vnd.vmware.vcloud.catalog+xml",
        href="https://example.com/api/catalog/ea0c6acf-c9c0-46b7-b19f-4b2d3bf8aa33",
        description=NonLoaded,
        is_published=NonLoaded
      >
    ]
  >
```

### Retrieve a Catalog

```ruby
org = vcloud.organizations.first
org.catalogs.get("4ee720e5-173a-41ac-824b-6f4908bac975") # or get_by_name("Public VM Templates")
```
```ruby
  <Fog::Compute::VcloudDirector::Catalog
    id="4ee720e5-173a-41ac-824b-6f4908bac975",
    name="Public VM Templates",
    type="application/vnd.vmware.vcloud.catalog+xml",
    href="https://example.com/api/catalog/4ee720e5-173a-41ac-824b-6f4908bac975",
    description="",
    is_published=true
  >
```

## Catalog Items

### List Catalog Items

```ruby
org = vcloud.organizations.first
catalog = org.catalogs.first
catalog.catalog_items
```
```ruby
  <Fog::Compute::VcloudDirector::CatalogItems
    catalog=    <Fog::Compute::VcloudDirector::Catalog
      id="4ee720e5-173a-41ac-824b-6f4908bac975",
      name="Public VM Templates",
      type="application/vnd.vmware.vcloud.catalog+xml",
      href="https://example.com/api/catalog/4ee720e5-173a-41ac-824b-6f4908bac975",
      description=NonLoaded,
      is_published=NonLoaded
    >
    [
      <Fog::Compute::VcloudDirector::CatalogItem
        id="2bd55629-2734-420c-9068-2ff06a4a8028",
        name="DEVWIN",
        type="application/vnd.vmware.vcloud.catalogItem+xml",
        href="https://example.com/api/catalogItem/2bd55629-2734-420c-9068-2ff06a4a8028",
        description=NonLoaded,
        vapp_template_id=NonLoaded
      >,
      <Fog::Compute::VcloudDirector::CatalogItem
        id="5437aa3f-e369-40b2-b985-2e63e1bc9f2e",
        name="DEVRHL",
        type="application/vnd.vmware.vcloud.catalogItem+xml",
        href="https://example.com/api/catalogItem/5437aa3f-e369-40b2-b985-2e63e1bc9f2e",
        description=NonLoaded,
        vapp_template_id=NonLoaded
      >,
      <Fog::Compute::VcloudDirector::CatalogItem
        id="54cf5deb-326f-4770-a91a-39048689b6ea",
        name="DEVAPP",
        type="application/vnd.vmware.vcloud.catalogItem+xml",
        href="https://example.com/api/catalogItem/54cf5deb-326f-4770-a91a-39048689b6ea",
        description=NonLoaded,
        vapp_template_id=NonLoaded
      >
    ]
  >
```

### Retrieve a Catalog Item

```ruby
org = vcloud.organizations.first
catalog = org.catalogs.first
catalog.catalog_items.get_by_name('DEVAPP')
```
```ruby
  <Fog::Compute::VcloudDirector::CatalogItem
    id="54cf5deb-326f-4770-a91a-39048689b6ea",
    name="DEVAPP",
    type="application/vnd.vmware.vcloud.catalogItem+xml",
    href="https://example.com/api/catalogItem/54cf5deb-326f-4770-a91a-39048689b6ea",
    description="Windows Server 2008 R2 Application Server",
    vapp_template_id="vappTemplate-b5902d57-7906-49c8-8af5-bbebe0a60a97"
  >
```

### Instantiate a vApp Template

It creates a Vapp from a CatalogItem.

```ruby
org = vcloud.organizations.first
catalog = org.catalogs.first
template = catalog.catalog_items.get_by_name('DEVAPP')
template.instantiate('webserver')
```

It there were more than one vDC or/and network you'd have to specify it as a
second param:

```ruby
template.instantiate('webserver', {
  vdc_id: "9a06a16b-12c6-44dc-aee1-06aa52262ea3",
  network_id: "d5f47bbf-de27-4cf5-aaaa-56772f2ccd17"
}
```

