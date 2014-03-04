# Getting started for SakuraCloud

## Links

- Product Information: http://cloud.sakura.ad.jp/
- API Reference(1.1): http://developer.sakura.ad.jp/cloud/api/1.1/

## Requeirement

- API TOKEN
- API TOKEN SECRET

You can retreave them from dashboard.


## Resources

|Service |Class |Description |
|----|----|----|
|Volume(disk) |Fog::Volume::SakuraCloud |Block device for server. |
|Compute |Fog::Compute::SakuraCloud |Server. |

## Simple start

Inital boot from template with ssh key.

```
require 'fog'
compute = Fog::Compute::SakuraCloud.new(
  :sakuracloud_api_token => 'YOUR_API_TOKEN',
  :sakuracloud_api_token_secret => 'YOUR_API_TOKEN_SECRET'
)


server = compute.servers.create({
  :sakuracloud_api_token => 'YOUR_API_TOKEN',
  :sakuracloud_api_token_secret => 'YOUR_API_TOKEN_SECRET',
  :sshkey => '11260003****',          # Your SSH Key id
  :serverplan => '2001',              # Server Type
  :volume => {
    :diskplan => 4,                   # Type SSD
    :sourcearchive => '112500463685'  # Ubuntu12.04
  },
  :boot => true
})
```

You can login or integrate with configuration management tools to server at once.


## Services

Usage for SakuraCloud Services.

### Volume(disk) Service

Initailize Volume service.

```
require 'fog'
volume = Fog::Volume::SakuraCloud.new(
  :sakuracloud_api_token => 'YOUR_API_TOKEN',
  :sakuracloud_api_token_secret => 'YOUR_API_TOKEN_SECRET'
)
```

or initailize with `Fog.credentials`


```
Fog.credentials[:sakuracloud_api_token] = 'YOUR_API_TOKEN'
Fog.credentials[:sakuracloud_api_token_secret] = 'YOUR_API_TOKEN_SECRET'

volume = Fog::Volume[:sakuracloud]
```


#### Listing disk plans

use `volume.plans`.

```
> volume.plans

=> [  <Fog::Volume::SakuraCloud::Plan
    id=4,
    name="SSDプラン"
  >,
   <Fog::Volume::SakuraCloud::Plan
    id=2,
    name="標準プラン"
  >]
```



#### Listing volume templates(archives)

use `volume.archives`.

```
require 'fog'
volume = Fog::Volume::SakuraCloud.new(
  :sakuracloud_api_token => 'YOUR_API_TOKEN',
  :sakuracloud_api_token_secret => 'YOUR_API_TOKEN_SECRET'
)


> volume.archives

=> [  <Fog::Volume::SakuraCloud::Archive
    id="112500514887",
    name="CentOS 5.10 64bit (基本セット)"
  >,
   <Fog::Volume::SakuraCloud::Archive
    id="112500571575",
    name="CentOS 6.5 64bit (基本セット)"
  >,
   <Fog::Volume::SakuraCloud::Archive
    id="112500556904",
    name="Scientific Linux 6.4 64bit (基本セット)"
  >,
   <Fog::Volume::SakuraCloud::Archive
    id="112500587018",
    name="Scientific Linux 6.5 RC1 64bit (基本セット)"
  >,
   <Fog::Volume::SakuraCloud::Archive
    id="112500556903",
    name="FreeBSD 8.3 64bit (基本セット)"
  >,
   <Fog::Volume::SakuraCloud::Archive
    id="112500556906",
    name="FreeBSD 9.1 64bit (基本セット)"
  >,
   <Fog::Volume::SakuraCloud::Archive
    id="112500556907",
    name="Ubuntu Server 13.04 64bit (基本セット)"
  >,
   <Fog::Volume::SakuraCloud::Archive
    id="112500463685",
    name="Ubuntu Server 12.04.3 LTS 64bit (基本セット)"
  >,
   <Fog::Volume::SakuraCloud::Archive
    id="112500490219",
    name="Ubuntu Server 13.10 64bit(基本セット)"
  >,
   <Fog::Volume::SakuraCloud::Archive
    id="112500556909",
    name="Debian GNU/Linux 6.0.7 64bit (基本セット)"
  >,
-- snip --
```

#### Create volume from templates(archives)

use `volume.disks.create` with `:name`, `:plan`(Plan id) and `:source_archive`(id, optional)

##### Example: Create SSD installed 'Ubuntu 12.04'.

```
disk = volume.disks.create :name => 'foobar',
                           :plan  => 4,  # Type SSD
                           :source_archive => 112500463685 # Ubuntu12.04
```

It creates disk.

```
=>   <Fog::Volume::SakuraCloud::Disk
    id="112600053876",
    name="foobar",
    Connection="virtio",
    Availability="migrating",
    Plan={"id"=>4, "StorageClass"=>"iscsi1204", "name"=>"SSDプラン"},
    SizeMB=20480,
    SourceDisk=nil,
    SourceArchive={"id"=>"112500463685", "name"=>"Ubuntu Server 12.04.3 LTS 64bit (基本セット)", "Availability"=>"available", "SizeMB"=>20480, "Plan"=>{"id"=>2, "StorageClass"=>"iscsi1204", "name"=>"標準プラン"}, "Storage"=>{"id"=>"3100297001", "Class"=>"iscsi1204", "name"=>"sac-is1b-arc-st01", "Zone"=>{"id"=>31002, "name"=>"is1b", "Region"=>{"id"=>310, "name"=>"石狩"}}, "DiskPlan"=>{"id"=>2, "StorageClass"=>"iscsi1204", "name"=>"標準プラン"}}, "BundleInfo"=>nil}
  >
```

#### Listing available disks

use `volume.disks`

```
> volume.disks

=> [  <Fog::Volume::SakuraCloud::Disk
    id="112600053837",
    name="ed86efca-d7f1-4367-97df-30e16c4f331e",
    Connection="virtio",
    Availability="available",
    Plan={"id"=>4, "StorageClass"=>"iscsi1204", "name"=>"SSDプラン"},
    SizeMB=20480,
    SourceDisk=nil,
    SourceArchive={"id"=>"112500463685", "name"=>"Ubuntu Server 12.04.3 LTS 64bit (基本セット)", "Availability"=>"available", "SizeMB"=>20480, "Plan"=>{"id"=>2, "StorageClass"=>"iscsi1204", "Na
  >,
   <Fog::Volume::SakuraCloud::Disk
    id="112600053840",
    name="2a3f571a-2562-49e1-a4ea-86f7cf34c571",
    Connection="virtio",
    Availability="available",
    Plan={"id"=>4, "StorageClass"=>"iscsi1204", "name"=>"SSDプラン"},
    SizeMB=20480,
    SourceDisk=nil,
    SourceArchive={"id"=>"112500463685", "name"=>"Ubuntu Server 12.04.3 LTS 64bit (基本セット)", "Availability"=>"available", "SizeMB"=>20480, "Plan"=>{"id"=>2, "StorageClass"=>"iscsi1204", "Na
  >,
-- snip --

```

Get Disk id or any attributes.

```
> volume.disks.first.id
=> "112600053837"

> volume.disks.first.SizeMB
=> 20480
```

or

```
> disk = volume.disks.first
> disk.id
=> "112600053837"
```

You can reload disk attributes.

```
> disk.reload
=>   <Fog::Volume::SakuraCloud::Disk
    id="112600053837",
    name="ed86efca-d7f1-4367-97df-30e16c4f331e",
    Connection="virtio",
    Availability="available",
    Plan={"id"=>4, "StorageClass"=>"iscsi1204", "name"=>"SSDプラン"},
    SizeMB=20480,
    SourceDisk=nil,
    SourceArchive={"id"=>"112500463685", "name"=>"Ubuntu Server 12.04.3 LTS 64bit (基本セット)", "Availability"=>"available", "SizeMB"=>20480, "Plan"=>{"id"=>2, "StorageClass"=>"iscsi1204", "name"=>"標準プラン"}, "Storage"=>{"id"=>"3100297001", "Class"=>"iscsi1204", "name"=>"sac-is1b-arc-st01", "Zone"=>{"id"=>31002, "name"=>"is1b", "Region"=>{"id"=>310, "name"=>"石狩"}}, "DiskPlan"=>{"id"=>2, "StorageClass"=>"iscsi1204", "name"=>"標準プラン"}}, "BundleInfo"=>nil}
  >
```

#### Delete disk

use `volume.disks.delete('Disk_id')`

```
> volume.disks.delete('112600053837')

=> true
```

or execute delete method for disk.

```
> volume.disks.first.delete

=> true
```

##### Example: Delete all disks

```
> volume.disks.each {|d| d.delete}
```


### SSH Key Service (Part of the Compute Service)

Initailize Compute service.

```
require 'fog'
compute = Fog::Compute::SakuraCloud.new(
  :sakuracloud_api_token => 'YOUR_API_TOKEN',
  :sakuracloud_api_token_secret => 'YOUR_API_TOKEN_SECRET'
)
```

#### Listing SSH Keys

use `compute.ssh_keys`

```
> compute.ssh_keys

=> [  <Fog::Compute::SakuraCloud::SshKey
    id="11260003****",
    name="sawanobori",
    PublicKey="ssh-rsa ***********************"
  >]
```


#### Add SSH Key to disk.

Work with Volume service.

use `configure` method with SSH Key id.

##### Example

```
> volume.disks.first.configure(11260003****)

=> true
```


### Compute Service

Initailize Compute service.

```
require 'fog'
compute = Fog::Compute::SakuraCloud.new(
  :sakuracloud_api_token => 'YOUR_API_TOKEN',
  :sakuracloud_api_token_secret => 'YOUR_API_TOKEN_SECRET'
)
```

or initailize with `Fog.credentials`


```
Fog.credentials[:sakuracloud_api_token] = 'YOUR_API_TOKEN'
Fog.credentials[:sakuracloud_api_token_secret] = 'YOUR_API_TOKEN_SECRET'

volume = Fog::Compute[:sakuracloud]
```


#### Listing server plans

use `compute.plans`.

```
> compute.plans

=> [  <Fog::Compute::SakuraCloud::Plan
    id=1001,
    name="プラン/1Core-1GB",
    ServiceClass="cloud/plan/1core-1gb",
    CPU=1,
    MemoryMB=1024
  >,
   <Fog::Compute::SakuraCloud::Plan
    id=2001,
    name="プラン/1Core-2GB",
    ServiceClass="cloud/plan/1core-2gb",
    CPU=1,
    MemoryMB=2048
  >,
-- snip --
```


#### Listing zones

use `compute.zones`.

```
> compute.zones

=> [  <Fog::Compute::SakuraCloud::Zone
    id=31001,
    name="is1a",
    Description="石狩第1ゾーン"
  >,
   <Fog::Compute::SakuraCloud::Zone
    id=31002,
    name="is1b",
    Description="石狩第2ゾーン"
  >]
```

#### Create server

use `volume.servers.create` with `:name`, `:ServerPlan`(Plan id)

##### Example: Create server with public switch connection.

```
server = compute.servers.create :name => 'foobar',
                                :ServerPlan  => 2001
```

It creates server.

```
=>   <Fog::Compute::SakuraCloud::Server
    id="112600055437",
    name="foobar",
    ServerPlan={"id"=>2001, "name"=>"プラン/1Core-2GB", "CPU"=>1, "MemoryMB"=>2048, "ServiceClass"=>"cloud/plan/1core-2gb", "Availability"=>"available"},
    Instance={"Server"=>{"id"=>"112600055437"}, "Status"=>"down", "BeforeStatus"=>nil, "StatusChangedAt"=>nil, "MigrationProgress"=>nil, "MigrationSchedule"=>nil, "IsMigrating"=>nil, "MigrationAllowed"=>nil, "ModifiedAt"=>"2014-01-30T23:54:47+09:00", "Host"=>nil, "CDROM"=>nil, "CDROMStorage"=>nil},
    Disks=[],
    Interfaces=[{"id"=>"112600055438", "MACAddress"=>"9C:A3:BA:30:13:28", "IPAddress"=>"133.242.236.247", "UserIPAddress"=>nil, "Hostname"=>nil, "Switch"=>{"id"=>"112500556860", "name"=>"スイッチ", "Scope"=>"shared", "Subnet"=>{"id"=>nil, "NetworkAddress"=>"133.242.236.0", "NetworkMaskLen"=>24, "DefaultRoute"=>"133.242.236.1", "Internet"=>{"BandWidthMbps"=>100}}, "UserSubnet"=>nil}, "PacketFilter"=>nil}]
  >
```

#### Listing available servers

use `compute.servers`

```
> compute.servers

=> [  <Fog::Compute::SakuraCloud::Server
    id="112600055437",
    name="foobar",
    ServerPlan={"id"=>2001, "name"=>"プラン/1Core-2GB", "CPU"=>1, "MemoryMB"=>2048, "ServiceClass"=>"cloud/plan/1core-2gb", "Availability"=>"available"},
    Instance={"Server"=>{"id"=>"112600055437"}, "Status"=>"down", "BeforeStatus"=>nil, "StatusChangedAt"=>nil, "MigrationProgress"=>nil, "MigrationSchedule"=>nil, "IsMigrating"=>nil, "MigrationAllowed"=>nil, "ModifiedAt"=>"2014-01-30T23:54:47+09:00", "Host"=>nil, "CDROM"=>nil, "CDROMStorage"=>nil},
    Disks=[],
    Interfaces=[{"id"=>"112600055438", "MACAddress"=>"9C:A3:BA:30:13:28", "IPAddress"=>"133.242.236.247", "UserIPAddress"=>nil, "Hostname"=>nil, "Switch"=>{"id"=>"112500556860", "name"=>"スイッチ", "Scope"=>"shared", "Subnet"=>{"id"=>nil, "NetworkAddress"=>"133.242.236.0", "NetworkMaskLen"=>24, "DefaultRoute"=>"133.242.236.1", "Internet"=>{"BandWidthMbps"=>100}}, "UserSubnet"=>nil}, "PacketFilter"=>nil}]
  >]

```


#### Boot or stop servers

execute boot/stop method for server.


##### Example: boot server

```
> compute.servers.first.boot

=> true
```

##### Example: stop server

```
> compute.servers.first.stop

=> true
```

force stop

```
> compute.servers.first.stop(true)

=> true
```