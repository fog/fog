# Getting Started with Fog on CloudSigma

## Requirements

In order to use CloudSigma with Fog, you must use Fog version 1.12.0 or later.

## Setting credentials

Fog uses `~/.fog` to store credentials. To add CloudSigma as your default provider, simply add the following:

    :default:
      :cloudsigma_username: user@example.com
      :cloudsigma_password: SomeRandomPassword
      :cloudsigma_host: zrh.cloudsigma.com

Please note that you need to specify the host. If you're on the Zurich-based cloud, you will need to enter `zrh.cloudsigma.com` and if you're on the Las Vegas cloud, you'll need to enter `lvs.cloudsigma.com`.


## Creating a server

You can of course interact with Fog directly from your Ruby application, but in this example, we'll simply use the `fog` CLI tool. In the example below, we'll first create a 5GB disk, then we create server with 2Ghz CPU and 2GB RAM. Finally we attach the drive and boot up the server.

    $ fog
    > cs = Compute[:CloudSigma]
    > drive = cs.volumes.create(:name => 'fog_drive', :size => '5368709120', :media => 'disk')
    > server = cs.servers.create(:name => 'fog_server', :cpu => '2000', :mem => '2147483648', :vnc_password => 'foobar')
    > server.mount_volume(drive.uuid)
    > server.update
    > server.start

Now, this wasn't very useful by itself since the drive we created was just a blank drive (as a result it cannot boot). It does however illustrate a minimal work flow.

To make this a bit more useful, let's try to attach an ISO image (in this case Ubuntu 12.04 LTS), and boot into the installer. To do this, we'll run the following commands (assuming you haven't closed the session from above). You can either upload your own installer image, or you can use one from the drives library. In either case, you need to pass the UUID for the drive.

    > server.stop
    > ubuntu_image_uuid = '41d848c2-44e4-4428-9406-84e95bb1288d'
    > server.unmount_volume(drive.uuid)
    > server.mount_volume(ubuntu_image_uuid, 'ide', '0:0', 1)
    > server.mount_volume(drive.uuid, 'virtio', '0:0', 2)
    > server.update
    > server.start

What this does is to stop the server, unmount the previous drive, then we attach the Ubuntu installation drive as an IDE device (on bus 0:0), with the boot order 1 (first). We then mount the system drive as Virtio device (on bus 0:0) with the boot order 2. Finally we push the changes to the server and start it. This will bring you into the Ubuntu installation.

In order to actually run the installer, you need to open a VNC session to the server. This can be done bye issue the following command:

    > server.open_vnc

That will print out the VNC URL, among with other data. You can simply pass the value of 'vnc_url' into your VNC client. When opening the session, you also need to provide the password, which we set to 'foobar' during the server creation.

After you're done with the installation, you can unmount the Ubuntu installation disk by running the following command:

    > server.unmount_volume(ubuntu_image_uuid)

You might also want to close the VNC session to increase security. This can be done by running:

    > server.close_vnc

That's it. You've now set up a fully working Ubuntu server on CloudSigma using fog.
