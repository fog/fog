# Examples for working with HP Cloud Compute Service v13.5

The latest HP Cloud deployment, version 13.5, takes advantage of more OpenStack functionality and the compute service uses slightly different commands (often noted by *v2* in the commands) than the previous 12.12 version. Verify which version of HP cloud you are working with.

The HP Cloud services provides compute support using two abstractions: [a model layer](#ModelLayer) and [a request layer](#RequestLayer). Both layers are detailed below.  The code samples on this page can be executed from within a Ruby console (IRB):

        irb

This page discusses the following topics:

* [Connecting to the Service](#connecting-to-the-service)

**Model Layer Examples**

* [Model Server Operations](#model-server-operations)
* [Model Server Volume Operations](#model-server-volume-operations)
* [Model Server Metadata Operations](#model-server-metadata-operations)
* [Model Flavor Operations](#model-flavor-operations)
* [Model Image Operations](#model-image-operations)
* [Model Image Metadata Operations](#model-image-metadata-operations)
* [Model Keypair Operations](#model-keypair-operations)
* [Model Address Operations](#model-address-operations)

**Request Layer Examples**

* [Request Server Operations](#request-server-operations)
* [Request Server Metadata Operations](#request-server-metadata-operations)
* [Request Flavor Operations](#request-flavor-operations)
* [Request Image Operations](#request-image-operations)
* [Request Image Metadata Operations](#request-image-metadata-operations)
* [Request Keypair Operations](#request-keypair-operations)
* [Request Address Operations](#request-address-operations)

## Connecting to the Service

To connect to the HP Cloud Compute V2 Service, follow these steps:

1. Enter IRB

        irb

2. Require the Fog library

        require 'fog'

3. Establish a connection to the HP Cloud Compute V2 service

        conn = Fog::Compute.new(
               :provider => "HP",
               :version => :v2,
               :hp_access_key => "<your_ACCESS_KEY>",
               :hp_secret_key => "<your_SECRET_KEY>",
               :hp_auth_uri => "<IDENTITY_ENDPOINT_URL>",
               :hp_tenant_id => "<your_TENANT_ID>",
               :hp_avl_zone => "<your_AVAILABILITY_ZONE>",
               <other optional parameters>
               )

**Note**: You must use the `:hp_access_key` parameter rather than the now-deprecated  `:hp_account_id` parameter you might have used in previous Ruby Fog versions.

You can find the values the access key, secret key, and other values by clicking the [`API Keys`](https://console.hpcloud.com/account/api_keys) button in the [Console Dashboard](https://console.hpcloud.com/dashboard).

## Model Server Operations

1. List all available servers for an account:

        servers = conn.servers
        servers.size   # returns no. of servers
        # display servers in a tabular format
        conn.servers.table([:id, :name, :state, :created_at])

2.  List servers using a filter:

        servers = conn.servers.all(:name => 'My Shiny Server')


3. Obtain the details of a particular server:

        server = conn.servers.get("<server_id>")
        server.name                         # returns name of the server
        server.flavor_id                    # returns id of the flavor used to create the server
        server.image_id                     # returns id of the image used to create the server
        server.addresses                    # returns a hash of public and private IP addresses
        server.created_at                   # returns the date the server was created
        server.state                        # returns the state of the server e.g. ACTIVE, BUILD

4. Create a new server:

        new_server = conn.servers.create(
              :name => "My Shiny Server",
              :flavor_id => 101,
              :image_id => "<server_id>"
        )
        new_server.id       # returns the id of the server
        new_server.name     # => "My Shiny Server"
        new_server.state    # returns the state of the server e.g. BUILD
        new_server.private_ip_address   # returns the private ip address
        new_server.public_ip_address    # returns the public ip address, if any assigned

5. Create a server by passing in a keypair and security group:

        new_server = conn.servers.create(
                :name=> "My Shiny Server",
                :flavor_id => 101,
                :image_id => "<image_id>",
                :key_name => "my_keypair",
                :security_groups => ["My Security Group"]
        )

6. Create a server by passing in a network_id:

        new_server = conn.servers.create(
                :name=> "My Shiny Server",
                :flavor_id => 101,
                :image_id => "<image_id>",
                :key_name => "my_keypair",
                :security_groups => ["My Security Group"],
                :networks => ["<network_id>"]
        )

7. Create a Linux-based persistent server by passing in a bootable volume:

        new_server = conn.servers.create(
                :name=> "My Sticky Server",
                :flavor_id => 104,
                :block_device_mapping => [{ 'volume_size' => '',
                'volume_id' => "<volume_id>",
                'delete_on_termination' => '0',
                'device_name' => 'vda'
                }]
        )
    **Note**: In *block_device_mapping*, *volume_size* is ignored; it is automatically retrieved from the specified bootable volume. To delete the bootable volume after the server instance is killed you can set  *delete_on_termination* to `1`.  To preserve the bootable volume, set it to `0` as shown above.

8. Create a new Linux-based server with advanced personalization options:

        new_server = conn.servers.create(
              :name => "My Personalized Server",
              :flavor_id => 1,
              :image_id => 2,
              :key_name => "hpdefault",
              :security_groups => ["aaa"],
              :config_drive => true,
              :user_data_encoded => ["This is some encoded user data"].pack('m'),
              :personality => [{
                'contents'  => File.read("/path/to/sample.txt"),
                'path'      => "/path/to/sample.txt"
              }]
        )
        new_server.id       # returns the id of the server
        new_server.name     # => "My Personalised Server"

        # Note: that un-encoded user data can also be provided by setting the user_data property
        # although, encoding the data on the client is faster and efficient
        new_server = conn.servers.new(
              :name => "My Personalized Server",
              ...
              ...
        )
        new_server.user_data = "This is some un-encoded user data"
        new_server.save

    The personalization options are:

    *config_drive*
    : Disk accessible to the server that contains a FAT filesystem. If `config_drive` parameter is set to `true` at the time of server creation, the configuration drive is created.

    *user_data_encoded* or *user_data*
    : Allows additional metadata to be inserted during server creation by supplying a Base64-encoded string in the `user_data_encoded` parameter, or by providing an unencoded string with the `user_data` attribute. Note that encoding the data on the client is faster and more efficient.

    *personality*
    : Allows files to be injected into the server instance after its creation. The file `contents` are Base64 encoded and injected into the location specified by `path`.

    **Note**: The above personalization options are not supported on Windows server instances.


9. Create a new Windows server instance and retrieve the encrypted password:

        win_server = conn.servers.create(
              :name => "My Windows Server",
              :flavor_id => 1,
              :image_id => 3,   # Make sure it is a Windows image
              :key_name => "<key_name>",
              :security_groups => ["<security_group_name>"]
        )
        win_server.id           # returns the id of the server
        # Retrieve the encrypted password
        win_server.windows_password
        # => "Im6ZJ8auyMRnkJ24KKWQvTgWDug1s ... y0uY1BcHLJ5OrkEPHhQoQntIKOoQ=\n"
**Note**: You must retrieve the Windows password immediately after you create the Windows instance. Also, make sure you have a security rule defined to open RDP port 3389 so that you can connect to the Windows server.

10. Get console output:

        server = conn.servers.get("<server_id>")
        server.console_output(10)           # returns 10 lines of console output

11. Get VNC console:

        server = conn.servers.get("<server_id>")
        server.vnc_console_url('novnc')     # URL to access the VNC console of a server from a browser

12. Update a server:

        server = conn.servers.get("<server_id>")
        server.update_name("My Shiny Server Updated")

13. Reboot a server:

        server = conn.servers.get("server_id>")
        server.reboot          # soft reboot by default

        server.reboot("HARD")  # hard reboot also possible

14. Rebuild a server:

        server = conn.servers.get("<server_id>")
        server.rebuild('server_id', 'My Shiny Server Rebuild')

15. Delete a server:

        server = conn.servers.get("<server_id>").destroy


## Model Server Volume Operations

1. Attach a volume to a server:

        server = conn.servers.get("<server_id>")
        server.volume_attachments.create(
                :server_id => s.id,
                :volume_id => "<volume id>",
                :device => "/dev/sdf"
        )
        server.reload                    #reload the server
        server.volume_attachments.all    #list the attachments

2. Obtain details for an volume attached to a server:

        server = conn.servers.get("<server_id>")
        server.volume_attachements.get("<volume_id>")

3. List attached volumes for a server:

        server = conn.servers.get("<server_id>")
        server.volume_attachments.all

4. Detach a volume from a server:

        server = conn.servers.get("<server_id>")
        att_volume = server.volume_attachments.get("<volume_id>")
        att_volume.destroy     # also aliased to att_volume.detach

## Model Server Metadata Operations

1. Create a server with some metadata:

        server = conn.servers.create(
              :flavor_id => 1,
              :image_id => 2,
              :name => "myserver",
              :metadata => {'Meta1' => 'MetaValue1', 'Meta2' => 'MetaValue2'}
        )

2. Get the metadata item:

        server.metadata.get("Meta1")

3. Update the metadata:

        s.metadata.update({"Meta2" => "MetaValue2"})

4. Set the metadata:

        s.metadata.set({"Meta3" => "MetaValue3"})

5. Set the metadata explicitly:

        m = myserver.metadata.new
        m.key = "Meta4"
        m.value = "Value4"
        m.save

6. Update the metadata:

        m = s.metadata.get("Meta1")
        m.value = "MetaUpdValue1"
        m.save

7. List metadata:

        s.metadata.all

8. Delete metadata:

        m = s.metadata.get("Meta3").destroy

## Model Flavor Operations

1. List all available flavors:

        flavors = conn.flavors.all
        flavors.size   # returns no. of flavors
        # display flavors in a tabular format
        conn.flavors.table([:id, :name, :ram, :disk])

2. List flavors using a filter:

        flavors = conn.flavors.all(:limit => 2)

3. Obtain the details of a particular flavor:

        flavor = conn.flavors.get("<flavor_id>")   # get the flavor
        flavor.name    # returns the name of the flavor eg: m1.tiny, m1.small etc.
        flavor.ram     # returns the ram memory in bytes for the flavor, eg: 4096
        flavor.disk    # returns the disk size in GB for the flavor, eg: 80
        flavor.cores   # returns no. of cores for the flavor, eg: 0.25

## Model Image Operations

1. List all available images:

        images = conn.images
        images.size   # returns no. of images
        # display images in a tabular format
        conn.images.table([:id, :name, :status, :created_at])

2. Obtain the details of a particular image:

        image = conn.images.get("<image_id>")    # get the image
        image.name          # returns name of the image
        image.created_at    # returns the date the image was created
        image.status        # returns the state of the image e.g. ACTIVE

3. Create a new snapshot image based on an existing server:

        # first, get a server
        server = conn.servers.get("<server_id>")
        s.create_image("My Image")

4. Delete an existing snapshot image:

        image = conn.images.get("<image_id>").destroy

## Model Image Metadata Operations

1. Create an image snapshot with some metadata:

        myserver.create_image("My Image", {"ImgMeta1" => "ImgMeta1Value"})

2. Get the metadata item:

        image = conn.images.get("<image_id>")
        image.metadata.set({"Meta3" => "MetaValue3"})

3. Update the metadata:

        image.metadata.update({"Meta2" => "MetaValue2"})

4. Set the metadata:

        image.metadata.set({"Meta3" => "MetaValue3"})

5. Set the metadata explicitly:

        m = image.metadata.set("Meta1")
        m.value = "MetaUpValue1"
        m.save

6. Update the metadata:

        m = myimage.metadata.get("ImgMeta3")
        m.value = "ImgUpdValue3"
        m.save

7. List metadata:

        myimage.metadata.all

8. Delete metadata:

        m = image.metadata.get("ImgMeta3").destroy

## Model Keypair Operations

1. List all available keypairs:

        keypairs = conn.key_pairs
        keypairs.size         # returns no. of keypairs
        # display keypairs in a tabular format
        conn.key_pairs.table([:name, :public_key])

2. Obtain the details of a particular keypair:

        keypair = conn.key_pairs.get(key_name)    # get the keypair
        keypair.name          # returns name of the keypair
        keypair.public_key    # returns the public key of the keypair
        # NOTE: Due to security considerations, the private key is not available on subsequent gets
        keypair.private_key   # => nil

3. Create a new keypair:

        keypair = conn.key_pairs.create(:name => "mykey")
        keypair.name          # returns name of the keypair
        keypair.public_key    # returns the public key of the keypair
        keypair.private_key   # returns the private key of the keypair
    **Note**: Keypairs with a dot (.) are not allowed.

4. Export a keypair to a file:

        keypair = conn.key_pairs.create(:name => "mykey2")
        keypair.write         # => "Key file built: /Users/xxxxx/.ssh/mykey2.pem"

        # Alternatively, you can pass in a path to export the key
        keypair.write("/Users/xxxxx/Downloads/mykey2.pem")

5. Import a public key to create a new keypair:

        keypair = conn.key_pairs.create(:name => "mykey", :public_key => "public key material")
        keypair.name          # returns name of the keypair

6. Delete an existing keypair:

        keypair = conn.key_pairs.get(key_name)
        keypair.destroy

## Model Address Operations

1. List all public and private ip addresses for a server:

        address = conn.addresses

2. Obtain the details of a particular address:

        address = conn.addresses.get("<address_id>")  # get the address
        address.ip                                  # returns the ip address

3. Create or allocate a new address:

        address = conn.addresses.create             # allocates an ip address from the pool
        address.ip                                  # returns the ip address

4. Associate a server to an existing address:

        server = conn.servers.get("<server_id>")        # get the server
        address = conn.addresses.get("<address_id>")    # get the address
        address.server = server                     # associate the server
        address.reload

5. Disassociate a server from an existing address:

        address = conn.addresses.get("<address_id>")    # get the address
        address.server = nil                        # disassociate the server
        address.instance_id                         # => nil

6. Delete (release) an existing address:

        server = conn.servers.get("<server_id>")      # get the server
        address = conn.addresses.get("<address_id>")  # get the address
        address.server = nil       # disassociate the server
        address.reload

7. Release an address back into the IP pool:

        address = conn.addresses.get("<address_id>").destroy
        => true

## Request Server Operations

1. List all available servers for an account:

        response = conn.list_servers
        response.body['servers']                    # returns an array of server hashes
        response.headers                            # returns the headers
        response.body['servers'][0]['name']         # returns the name of the server

2. List all available servers using a filter:

        response = conn.list_servers_detail(:name => 'My Shiny Server')

3. List all available servers with additional details:

        response = conn.list_servers_detail
        response.body['servers']                    # returns an array of server hashes
        response.body['servers'][0]['name']         # returns the name of the server

4. Obtain the details of a particular server:

        response = conn.get_server_details("<server_id>")
        server = response.body['server']
        server['name']                              # returns the name of the server
        server['flavor']                            # returns the flavor used to create the server
        server['image']                             # returns the image used to create the server
        server['addresses']                         # returns the public and private addresses
        server['status']                            # returns the state of the server e.g. ACTIVE

5. Create a new server:

        response = conn.create_server(
            "My Shiny Server",
            flavor_id,
            image_id,
            {
              'availability_zone' => "az2"
            }
            {
              'security_groups' => ["SecGroup1, SecGroup2"],
              'key_name' => "MyKeyPair1"
            }
        )
        server = response.body['server']
        server['id']                                # returns the id of the new server
        server['name']                              # => "My Shiny Server"
        server['status']                            # returns the state of the server e.g. BUILD

6. Create a server by passing in a keypair and security group:

        response = conn.create_server(
            "My Shiny Server",
            101,
            image_id,
            {
              'key_name' => "MyKeyPair1",
              'security_groups' => ["SecGroup1, SecGroup2"],
            }
        )
        server = response.body['server']
        server['id']                                # returns the id of the new server
        server['name']                              # => "My Shiny Server"
        server['status']                            # returns the state of the server e.g. BUILD

7. Create a server by passing in a network:

        response = conn.create_server(
            "My Shiny Server",
            101,
            image_id,
            {
              'networks' => ["My Network"]
            }
        )


8. Create a new Windows server and retrieve the encrypted password:

        # Make sure to use a Windows image
        response = conn.create_server("My Windows Server", "<flavor_id>", "<image_id>")
        win_server = response.body['server']
        server_id = win_server['id']                # returns the id of the new server
        # Retrieve the encrypted password
        conn.get_windows_password("<server_id>")
        # => "Im6ZJ8auyMRnkJ24KKWQvTgWDug1s ... y0uY1BcHLJ5OrkEPHhQoQntIKOoQ=\n"
    **Note**: You must retrieve the Windows password immediately after you create the Windows instance. Also, make sure you have a security rule defined to open RDP port 3389 so that you can connect to the Windows server.

9. Create a new Linux-based persistent server with a bootable volume

        conn.create_persistent_server(
              "MyBootableServer",
              103,
              [{ "volume_size"=>"",                 # ignored
                  "volume_id"=>"65904",
                  "delete_on_termination"=>"0",
                  "device_name"=>"vda"
              }] ,
              {
               'security_groups' => ["mysecgroup"],
               'key_name' => "mykey"
              }
        )
    **Note**: In *block_device_mapping*, *volume_size* is ignored; it is automatically retrieved from the specified bootable volume. To delete the bootable volume after the server instance is killed you can set  *delete_on_termination* to `1`.  To preserve the bootable volume, set it to `0` as shown above.

10. Create a new Linux-based server with advanced personalisation options:

        response = conn.create_server(
            "My Shiny Server",
            flavor_id,
            image_id,
            {
              'security_groups' => ["SecGroup1, SecGroup2"],
              'key_name' => "MyKeyPair1",
              'config_drive' => true,
              'user_data_encoded' => ["This is some encoded user data"].pack('m'),
              'personality' => [{
                                 'contents'  => File.read("/path/to/sample.txt"),
                                 'path'      => "/path/to/sample.txt"
                               }]
            }
        )
        server = response.body['server']
        server['id']                    # returns the id of the new server

    The personalization options are:

    *config_drive*
    : Disk accessible to the server that contains a FAT filesystem. If `config_drive` parameter is set to `true` at the time of server creation, the configuration drive is created.

    *user_data_encoded*
    : Allows additional metadata to be inserted during server creation by supplying a Base64-encoded string in the `user_data_encoded` parameter.

    *personality*
    : Allows files to be injected into the server instance after its creation. The file `contents` are Base64 encoded and injected into the location specified by `path`.

    **Note**: The above personalization options are not supported on Windows server instances.

11. Update the name for a server:

        address = conn.update_server("<server_id>", {'name' => "My Cool Server"})
        response = conn.get_server_details("<server_id>")
        response.body['server']['name']             # => "My Cool Server"

12. Reboot a server (SOFT):

        address = conn.reboot_server("<server_id>", "SOFT")

13. Reboot a server (HARD):

        address = conn.rebuild_server("<server_id>", "HARD")

14. Rebuild a server:

        address = conn.reboot_server("<server_id>", "MyRebuiltServer")

15. List both public and private addresses of a particular server:

        response = conn.list_server_addresses("<server_id>")

13. Display console output:

        response = conn.get_console_output("<server_id>", 10)
        # => 10 lines of console output are returned

14. Get the VNC console for a server:

        response = conn.get_vnc_console("<server_id>")
        # => Url to access the VNC console of a server from a browser

16. Delete an existing server:

        conn.delete_server("<server_id>")

## Request Server Metadata Operations

1. Create a server and pass it some metadata at creation:

        response = conn.create_server(
                        "myserver", 1, 2,
                        {'metadata' =>
                          {'Meta1' => 'MetaValue1', 'Meta2' => 'MetaValue2'}
                        }
                   )
        response.body['server']['metadata']
        # => {"Meta1"=>"MetaValue1", "Meta2"=>"MetaValue2"}

2. List the existing metadata:

        response = conn.list_metadata("servers", "<server_id>")
        response.body['metadata']
        # => {"Meta1"=>"MetaValue1", "Meta2"=>"MetaValue2"}

3. Set new values to the existing metadata:

        response = conn.set_metadata("servers", "<server_id>", {"MetaNew1" => "MetaNewValue1"})
        response.body['metadata']
        # => {"MetaNew1"=>"MetaNewValue1"}

4. Update the existing metadata:

        response = conn.update_metadata("servers", "<server_id>", {"Meta2" => "MetaValue2"})
        response.body['metadata']
        # => {"Meta2"=>"MetaValue2"}

5. Get a metadata item:

        response = conn.get_meta("servers", "<server_id>", "Meta1")
        response.body['meta']
        # => {"Meta1"=>"MetaValue1"}

6. Set a new metadata item or update an existing metadata item:

        response = conn.update_meta("servers", "<server_id>", "Meta1", "MetaUpdated1")
        response.body['meta']
        # => {"Meta1"=>"MetaUpdated1"}

7. Delete a metadata item:

        conn.delete_meta("servers", "<server_id>", "Meta1")

## Request Flavor Operations

1. List all available flavors:

        response = conn.list_flavors
        response.body['flavors']                    # returns an array of flavor hashes
        response.headers                            # returns the headers for the flavors
        response.body['flavors'][0]['name']         # returns the name of the flavor

2. List all available flavors with additional details:

        response = conn.list_flavors_detail
        response.body['flavors']                    # returns an array of flavor hashes

3. Obtain the details of a particular flavor:

        response = conn.get_flavor_details("<flavor_id>")
        flavor = response.body['flavor']
        flavor['name']                              # returns the name of the flavor
        flavor['disk']                              # returns the disk size of the flavor
        flavor['ram']                               # returns the ram size of the flavor

## Request Image Operations

1. List all available images:

        response = conn.list_images
        response.body['images']                     # returns an array of image hashes
        response.headers                            # returns the headers for the images
        response.body['images'][0]['name']          # returns the name of the image

2. List all available images with additional details:

        response = conn.list_images_detail
        response.body['images']                     # returns an array of image hashes
        response.body['images'][0]['name']          # returns the name of the image

3. Obtain the details of a particular image:

        response = conn.get_image_details("<image_id>")
        image = response.body['image']
        image['name']                               # returns name of the image
        image['status']                             # returns the state of the image e.g. ACTIVE
        image['created']                            # returns the creation date of the image
        image['updated']                            # returns the update date of the image

3. Create a new snapshot image based on an existing server:

        conn.create_image("<server_id>", "My Image")    # creates an snapshot image from the server referenced by "server_id"

4. Delete an existing snapshot image:

        conn.delete_image("<image_id>")

## Request Image Metadata Operations

1. Create an image and pass it some metadata at creation:

        conn.create_image("<server_id>", "myimage", {'Meta1' => 'MetaValue1', 'Meta2' => 'MetaValue2'})

2. List the existing metadata:

        response = conn.list_metadata("images", "<image_id>")
        response.body['metadata']
        #  => {"Meta1"=>"MetaValue1", "Meta2"=>"MetaValue2"}

3. Set new values to the existing metadata:

        response = conn.set_metadata("images", "<image_id>", {"MetaNew1" => "MetaNewValue1"})
        response.body['metadata']
        # => {"MetaNew1"=>"MetaNewValue1"}

4. Update the existing metadata:

        response = conn.update_metadata("images", "<image_id>", {"Meta2" => "MetaValue2"})
        response.body['metadata']
        # => {"Meta2"=>"MetaValue2"}

5. Get a metadata item:

        response = conn.get_meta("images", "<image_id>", "Meta1")
        response.body['meta']
        # => {"Meta1"=>"MetaValue1"}

6. Update a metadata item:

        response = conn.update_meta("images", "<image_id>", "Meta1", "MetaUpdated1")
        response.body['meta']
        # => {"Meta1"=>"MetaUpdated1"}

7. Delete a metadata item:

        conn.delete_meta("images", "<image_id>", "Meta1")

## Request Keypair Operations

1. List all available keypairs:

        response = conn.list_key_pairs
        response.body['keypairs']                   # returns an array of keypair hashes
        response.headers                            # returns the headers
        response.body['keypairs'][0]['keypair']['name']        # returns the name of the keypair

2. Create a new keypair:

        response = conn.create_key_pair("mykey")
        keypair = response.body['keypair']
        keypair['name']                             # returns the name of the keypair
        keypair['public_key']                       # returns the public key of the keypair
        keypair['private_key']                      # returns the private key of the keypair

3. Obtain a keypair:

        response = conn.get_key_pair("mykey")


4. Import a public key to create a new keypair:

        response = conn.create_key_pair("mykey", "public key material")
        keypair = response.body['keypair']
        keypair['name']                             # returns the name of the keypair

4. Delete an existing keypair:

        conn.delete_key_pair("<key_name>")

## Request Address Operations

1. List all available floating IP addresses:

        server = conn.servers.first
        response = conn.list_server_addresses(server.id)
        response.body['addresses']                  # returns an array of address hashes
        response.headers                            # returns the headers
      

2. List addresses by network for a server:

        server = conn.servers.first
        network = network_conn.networks.first.name
        response = conn.list_server_addresses_by_network(server.id, name)     # get the addresses (assumes server is in network)

3. Obtain the details of a particular address:

        response = conn.get_address("<address_id>")     # get the address
        response.body['address']['ip']              # returns the ip address

3. Create (allocate) a new address:

        response = conn.allocate_address            # allocates an ip address from the pool
        response.body['address']['ip']              # returns the ip address

4. Associate a server to an existing address:

        conn.associate_address("<server_id>", "<ip_address>")

5. Disassociate a server from an existing address:

        conn.disassociate_address("<server_id>", "<ip_address>")

6. Delete (release) an existing address:

        conn.release_address("<address_id>")            # releases the ip address to the pool

---------
[Documentation Home](https://github.com/fog/fog/blob/master/lib/fog/hp/README.md) | [Examples](https://github.com/fog/fog/blob/master/lib/fog/hp/examples/getting_started_examples.md)
