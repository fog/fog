# Storage Repositories

Official storage repository Citrix API documentation:

http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=SR

Create the XenServer connection first, as usual:

```ruby
require 'fog'
require 'net/scp'
require 'pp'

xenserver = Fog::Compute.new({
  :provider => 'XenServer',
  :xenserver_url => 'xenserver-test',
  :xenserver_username => 'root',
  :xenserver_password => 'secret',
})
```

Listing the available storage repositories:

```ruby
xenserver.storage_repositories
```


Filter storage repositories by content type:

```ruby
xenserver.storage_repositories.select { |sr| sr.content_type == 'iso' }
```

Filter storage repositories by allowed operations:

```ruby
rw_srs = xenserver.storage_repositories.select do |sr|
  # Are we allowed to create a VDI here?
  sr.allowed_operations.include? 'vdi_create'
end
```

Print some attributes of the first SR found:

```ruby
sr = rw_srs.first
puts sr.name
puts sr.description
puts sr.type
puts sr.tags
# in bytes
puts sr.physical_size
puts sr.physical_utilisation
# sum of virtual_sizes of all VDIs in this storage repository (in bytes)
puts sr.virtual_allocation
```

List virtual disk images available and print some VDI's attributes:

```ruby
sr.vdis.each do |vdi|
  # http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=VDI
  puts vdi.uuid
  puts vdi.is_a_snapshot
  puts vdi.name
  # in bytes
  puts vdi.physical_utilisation
  puts vdi.virtual_size
  puts vdi.read_only
  # ["update", "resize", "destroy", "clone", "copy", "snapshot"],
  puts vdi.allowed_operations
end
```

Create a new VDI in this storage repository:

```ruby
vdi = xenserver.vdis.create :name => 'super-vdi',
                            :storage_repository => sr,
                            :description => 'my super-vdi',
                            :virtual_size => '1073741824' # 1 GB
```

I have an ext3 storage repository and this creates a 1GB VHD file there:

    [root@xenserver ~]# vhd-util query -v -n /var/run/sr-mount/6edd263a-2da1-7533-840c-768417b5be25/4050057d-a3a8-4c00-8f2e-cf5531232921.vhd
    1024

Destroy the VDI:

```ruby
vdi.destroy
```
