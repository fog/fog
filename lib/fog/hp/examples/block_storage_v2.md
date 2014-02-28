#Examples for working with HP Cloud Block Storage Service v13.5

HP Cloud block storage provides support for volumes and snapshots. The latest HP Cloud deployment, version 13.5, takes advantage of more OpenStack functionality and the block storage service uses slightly different commands (often noted by *v2* in the commands) than the previous 12.12 version. Verify which version of HP Cloud you are working with.

A volume can store boot images, user data or both. They provide customers with persistent and flexible permanent storage. You can think of it as list of USB devices, that can be plugged in anywhere at will. Volumes can be attached to server instances and mounted.

Snapshots are saved volume images at specific moments in time. You can take a snapshot of a volume and then use that snapshot to create a new volume.

The block storage provider has two abstractions: [a model layer](#ModelLayer) and [a request layer](#RequestLayer). Both layers are detailed below. The following code snippets can be executed from within a Ruby console (IRB):

        irb

This page discusses the following tasks:

* [Connecting to the Service](#connecting-to-the-service)

**Model Layer Examples**

* [Model Volume Operations](#model-volume-operations)
* [Model Snapshot Operations](#model-snapshot-operations)
* [Model Volume Backup Operations](#model-volume-backup-operations)

**Request Layer Examples**

* [Request Volume Operations](#request-volume-operations)
* [Request Snapshot Operations](#request-snapshot-operations)
* [Volume Operations (Request Layer)](#request-volume-backup-operations)

## Connecting to the Service

To connect to the HP Cloud Block Storage Service, follow these steps:

1. Enter IRB

        irb

2. Require the Fog library

        require 'fog'

3. Establish a connection to the HP Cloud Block Storage service

        conn = Fog::HP::BlockStorageV2.new(
               :hp_access_key  => "<your_ACCESS_KEY>",
               :hp_secret_key => "<your_SECRET_KEY>",
               :hp_auth_uri   => "<IDENTITY_ENDPOINT_URL>",
               :hp_tenant_id => "<your_TENANT_ID>",
               :hp_avl_zone => "<your_AVAILABILITY_ZONE>",
               <other optional parameters>
               )

**Note**: You must use the `:hp_access_key` parameter rather than the now-deprecated  `:hp_account_id` parameter you might have used in previous Ruby Fog versions.

You can find the values the access key, secret key, and other values by clicking the [`API Keys`](https://console.hpcloud.com/account/api_keys) button in the [Console Dashboard](https://console.hpcloud.com/dashboard).

## Model Volume Operations

This section discusses the volume operations you can perform using the model abstraction.

1. List all available volumes for an account:

        volumes = conn.volumes
        volumes.size   # returns no. of volumes
        # display volumes in a tabular format
        volumes.table([:id, :name, :status, :created_at])

2. Obtain the details of a volume by the volume ID:

        volume = conn.volumes.get("<volume_id>")
        volume.name             # returns name of the volume
        volume.created_at       # returns the date the volume was created
        volume.status           # returns the state of the volume e.g. available, in-use

3. List volume details using a filter:

        volume = conn.volumes.all(:status => 'error')

4. Create a volume

        new_volume = conn.volumes.create(
               :name => "TestVolume",
               :description => "My Test Volume",
               :size => 1)
        new_volume.id       # returns the id of the volume
        new_volume.name     # => "TestVolume"
        new_volume.status   # returns the status of the volume e.g., creating, available

5. Create a new bootable volume from an suitable single-part image

        new_volume = conn.volumes.create(
               :name => "BootVolume",
               :description => "My Boot Volume",
               :image_id => 11111,
               :size => 10)
        new_volume.id       # returns the id of the volume
**Note**: You can use a bootable volume to create a persistent server instance.
**Note**: The size of the volume you create from an image is the same as that of the image. The `:size` parameter has no effect in this case.

6. Create a volume from a volume snapshot:

        new_volume = conn.volumes.create(
                :name => 'VolumeFromSnapshot',
                :snapshot_id => "<snapshot_id>")
**Note**: The size of the volume you create from a snapshot, is the same as that of the snapshot.

7. Create a volume from another source volume:

        new_volume = conn.volumes.create(
                :name => 'VolumeClone',
                :source_volid => "<source_volid>")
**Note**: The size of the volume you create from a source volume, is the same as that of the source volume.

8. Attach a volume to a server:

        # assuming we have a server
        server.volume_attachments.create(
                :server_id => server.id,
                :volume_id => "<volume_id>",
                :device => "/dev/sdf")
        # => true
**Note**: The device parameter is the mount point on the server instance to which the volume is attached (for example, `/dev/sdf`).

9. List the attached volumes for a server:

        # assuming we have a server
        server.volume_attachments.all

10. Detach a volume from a server:

        # assuming we have a server
        att_vol = server.volume_attachments.get("<volume_id>")
        att_vol.destroy
        # => true

11. Update a volume:

        volume = conn.volumes.get("<volume_id>")
        vol.description = "from a source vol. in a diff. availability zone"
        => "from a source vol. in a diff. availability zone"
        vol.save
        => true

12. Delete a volume:

        volume = conn.volumes.get("<volume_id>")
        volume.destroy
        # => true

## Model Snapshot Operations

This section discusses the snapshot operations you can perform using the model abstraction.

1. List all available snapshots for an account:

        snapshot = conn.snapshots
        snapshots.size   # returns no. of snapshots
        # display snapshots in a tabular format
        conn.snapshots.table([:id, :name, :state, :created_at])

2. List snapshots using a filter:

        snapshot = conn.snapshots.all(:display_name => 'My Snapshot')
        snapshot.name            # returns name of the snapshot
        snapshot.description     # returns the description of the snapshot
        snapshot.created_at      # returns the date the snapshot was created
        snapshot.status          # returns the state of the snapshot e.g., available

3. Obtain the details of a snapshot by the ID:

        snapshot = conn.snapshots.get("<snapshot_id>")
        snapshot.name            # returns name of the volume
        snapshot.description     # returns the description of the snapshot
        snapshot.status          # returns the state of the snapshot e.g., available
        snapshot.created_at      # returns the date the snapshot was created
        snapshot.volume_id       # returns the volume ID

4. Create a snapshot:

        snapshot = conn.snapshots.create(
               :volume_id => "<volume_id>",
               :name => "TestSnapshot",
               :description => "My Test Snapshot")

        snapshot.id              # returns the id of the volume
        snapshot.name            # => "TestVolume"
        snapshot.description     # returns the description of the snapshot
        snapshot.status          # returns the status of the volume e.g., creating, available
        snapshot.created_at      # returns the date the snapshot was created
        snapshot.volume_id       # => 1

5. Update a snapshot

        snapshot = conn.snapshots.get("<snapshot_id>")
        snapshot.name = "Snapshot 1"
        snapshot.save
        => true

6. Delete an existing snapshot

        conn.snapshots.get("<snapshot_id>").destroy
        => true

## Model Volume Backup Operations

This section discusses the volume backup operations you can perform using the model abstraction.

1. List available volume backups for an account:

        conn.volume_backups

2. List details of volume backups:

        conn.volume_backups.all(:details => true)

3. Obtain the details of a volume backup by ID:

        volume = conn.volume_backups.get("<volume_backup_id>")

        volume.name             # returns the name of the volume backup
        volume.status           # provides the status of the volume backup e.g., available
        volume.created_at       # provides the date the backup was created
        volume.volume_id        # returns the id of the volume
        volume.container        # returns the container holding the backup

4. Create a volume backup:

        volume = conn.volume_backups.create(
                :name => "My Volume Backup",
                :volume_id => "<volume_id>")

5. Restore from a volume backup into a new volume:

        # restore into a new volume
        backup = conn.volume_backups.get("<volume_backup_id>")
        backup.restore
        => true

6. Restore from a volume backup into an existing volume:

        # restore into an existing volume
        backup = conn.volume_backups.get("<volume_backup_id>")
        backup.restore("<existing_volume_id>")
        => true

7. Delete a volume backup:

        backup = conn.volume_backups.get("<volume_backup_id>")
        backup.destroy

## Request Volume Operations

This section discusses the volume operations you can perform using the request abstraction.

1. List all available volumes for an account:

        response = conn.list_volumes
        response.body['volumes']                     # returns an array of volume hashes
        response.headers                             # returns the headers
        response.body['volumes'][0]['display_name']  # returns the name of the volume

2. List available volumes using a filter:

        conn.list_volumes(:limit => 2 )

3. List volumes with details:

        response = conn.list_volumes_detail
        response.body['volumes'][0]['volume_image_metadata']  # returns volume image metadata

4. List volumes with details using a filter:

        response = conn.list_volumes_detail(:display_name => "Test Volume")
        response.body['volumes'][0]['volume_image_metadata']  # returns volume image metadata

5. Obtain the details of a volume by ID:

        response = conn.get_volume_details("<volume_id>")
        volume = response.body['volume']
        volume['display_name']        # returns the name of the volume
        volume['size']                # returns the size of the volume
        volume['status']              # returns the status of the volume e.g. available, in-use

6. Create a volume:

        response = conn.create_volume('display_name' => 'Test Volume', 'size' => 10)
        volume = response.body['volume']
        volume['id']                     # returns the id of the new volume
        volume['display_name']           # => "demo-vol"
        volume['size']                   # => 10
        volume['status']                 # returns the status of the volume e.g. creating, available

7. Create a new volume from an existing image:

        conn.create_volume('display_name' => 'Test Volume 1',
                        'display_description' => 'Test Volume from image',
                        'size' => 10,
                        'imageRef' => "<image_id>")

8. Create a new volume from an existing snapshot:

        response = conn.create_volume(
                'display_name' => 'Test Volume 2',
                'display_description' => 'New Volume from Snapshot',
                'snapshot_id' => "<snapshot_id>")
        volume = response.body['volume']

        volume['id']                         # returns the id of the new volume
        volume['display_name']               # => "Test Volume 2"
        volume['size']                       # => 1
        volume['snapshot_id']                # => 1
        volume['status']                     # returns the status of the volume e.g. creating, available
**Note**: The size of the volume you create from a snapshot is the same as that of the snapshot. The third parameter (the size) has no effect in this case.

9. Create a new volume from an existing volume:

        conn.create_volume(
                'display_name' => 'Test Volume 3',
                'display_description' => 'Test volume from another image',
                'source_volid' => "<source_volid>")

10. Create a new bootable volume from an suitable single-part image:

        conn.create_volume(
                'display_name' => "TestBootVol",
                'display_description' => "My Test Boot Volume",
                'size' => 10,
                'imageRef' => "<bootable_image_id>")
**Note**: You can use a bootable volume to create a persistent server instance.

11. Attach an existing volume to an existing server:

        response = conn.attach_volume("<server_id>", "<volume_id>", "/dev/sdf")
        volume_attachment = response.body['volumeAttachment']
        volume_attachment['id']        # returns the id of the volume
        volume_attachment['volumeId']  # returns the id of the volume
        volume_attachment['serverId']  # returns the id of the server
        volume_attachment['device']    # returns the device of the volume
**Note**: The device parameter is the mount point on the server instance to which the volume is attached (for example, `/dev/sdf`)

12. List volumes attached to a server:

        response = conn.list_server_volumes("<server_id>")
        volume_attachments = response.body['volumeAttachments']
        volume_attachment[0]['id']       # returns the id of the volume
        volume_attachment[0]['volumeId'] # returns the id of the volume
        volume_attachment[0]['serverId'] # returns the id of the volume
        volume_attachment[0]['device']   # returns the device of the volume

13. Detach an existing volume from a server:

        conn.detach_volume("<server_id>", "<volume_id>")

14. Update a volume:

        conn.update_volume("<volume_id>",
                {'display_name' => 'Test Volume Update'})

15. Delete an existing volume:

        conn.delete_volume("<volume_id>")

## Request Snapshot Operations

This section discusses the snapshot operations you can perform using the request abstraction.

1. List all available snapshots for an account:

        response = conn.list_snapshots
        response.body['snapshots']                        # returns an array of snapshot hashes
        response.headers                                  # returns the headers
        response.body['snapshots'][0]['display_name']     # returns the name of the snapshot
        response.body['snapshots'][0]['size']             # returns the size of the snapshot
        response.body['snapshots'][0]['volume_id']        # returns the volume id of the snapshot

2. List the details of all snapshots:

        conn.list_snapshots_detail

3. List the details of a snapshot using a filter:

        conn.list_snapshots_detail(:limit => 2)

4. Obtain the details of a snapshot by ID:

        response = conn.get_snapshot_details("<snapshot_id>")
        snapshot = response.body['snapshot']
        snapshot['display_name']                  # returns the name of the snapshot
        snapshot['size']                          # returns the size of the snapshot
        snapshot['volume_id']                     # returns the volume id of the snapshot
        snapshot['status']                        # returns the status of the snapshot e.g. available, in-use

5. Create a new snapshot:

        response = conn.create_snapshot("<volume_id>",
                'display_name' => 'Test Snapshot',
                'display_description' => 'Test Snapshot from Vol Test')
        snapshot = response.body['snapshot']
        snapshot['id']                           # returns the id of the new volume
        snapshot['display_name']                 # => "demo-vol"
        snapshot['size']                         # => 1
        snapshot['volume_id']                    # returns the volume id of the snapshot
        snapshot['status']                       # returns the status of the snapshot e.g. creating, available

6. Update a snapshot:

        conn.update_snapshot("<snapshot_id>", 'display_name' => "Test Snapshot 1 Update")

7. Delete a snapshot:

        conn.delete_snapshot("<snapshot_id>")

## Request Volume Backup Operations

This section discusses the volume backup operations you can perform using the request abstraction.

1. List all available volume backups for an account:

        conn.list_volume_backups

2. List details of all available volume backups:

        conn.list_volume_backups_detail

3. Obtain the details of a volume backup by ID:

        conn.get_volume_backup_details("<volume_backup_id>")

4. Create a volume backup:

        conn.create_volume_backup("<volume_id>")

5. Restore into a new volume using a volume backup:

        conn.restore_volume_backup("<volume_backup_id>")
        # creates a new volume that is a clone of the volume the backup was created from

6. Restore into an existing volume using a volume backup:

        conn.restore_volume_backup("<volume_backup_id>", "<existing_volume_id>")

7. Delete a volume backup:

        conn.delete_volume_backup("<volume_backup_id>")

---------
[Documentation Home](https://github.com/fog/fog/blob/master/lib/fog/hp/README.md) | [Examples](https://github.com/fog/fog/blob/master/lib/fog/hp/examples/getting_started_examples.md)
