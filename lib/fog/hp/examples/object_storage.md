# Examples for working with HP Cloud Object Storage Service

The HP Cloud Extensions to Ruby Fog libary provides Object Storage services support using two abstractions: a model layer and a request layer. Executing commands in both layers are detailed in this page.

The examples on this page can be executed from within a Ruby console (IRB):

        irb

This page discusses the following topics:

* [Connecting to the Service](https://github.com/fog/fog/blob/master/lib/fog/hp/docs/connect.md)
* [Using the Model Abstraction](#using-the-model-abstraction)
* [Using the Request Abstraction](#using-the-request-abstraction)


## Using the Model Abstraction

1. List all directories/containers for the given account

        dirs = conn.directories
        dirs.size   # returns no. of directories

2. Create a new directory/container

        conn.directories.create(:key => "fog-rocks")

3. View a directory/container

        dir = conn.directories.get("fog-rocks")
        dir.key    # => fog-rocks

4. Apply ACLs on an existing directory/container

        dir = conn.directories.get("fog-rocks")
        dir.public = true
        dir.save
        dir.public?               # => true
        dir.public = false        # toggles between "private" and "public-read" acl on a directory
        dir.save
        dir.public?               # => false

5. Create a new file/object into an existing directory/container

        dir = conn.directories.get("fog-rocks")
        dir.files.create(:key => "sample.txt", :body => File.open("/path/to/sample.txt"))

6. View a file/object from an existing directory/container

        dir = conn.directories.get("fog-rocks")
        file = dir.files.get("sample.txt")
        file.key   # => sample.txt

7. Copy a file/object into an existing directory/container

        file = conn.directories.get("fog-rocks").files.get("sample.txt")
        other_file = file.copy("fog-rocks", "another-sample.txt")
        other_file.key   # => another-sample.txt

8. View the files/objects for a directory/container

        dir = conn.directories.get("fog-rocks")
        files = dir.files
        files.directory.key      # => fog-rocks
        files.size               # returns no. of files
        files[0].key             # key of the file in collection
        files[0].content_length  # content length of file
        files[0].last_modified   # last modified date in UTC

9. Generate a temporary URL for a file or object for sharing purposes

        dir = conn.directories.get("fog-rocks")
        file = dir.files.get("sample.txt")
        # creates a TempUrl to access sample.txt and access expires in 240 secs
        file.temp_signed_url(240, "GET")

10. Delete a file/object from an existing directory/container

        dir = conn.directories.get("fog-rocks")
        file = dir.files.get("sample.txt")
        file.destroy
        # chaining a series of calls to delete a file
        conn.directories.get("fog-rocks").files.get("another-sample.txt").destroy

11. Delete an existing directory/container

        # Note: directory needs to be empty before it can be deleted!
        conn.directories.get("fog-rocks").destroy

**Note**: You cannot use the create, update, or delete operations on a shared container.

### About using object ACLs

Object ACLs allow you to share containers and objects with other registered HP Public Cloud users.  The owner of a container or object can grant read, write, read/write access to other users.  The shared containers and objects can then be accessed based on the permissions granted by the owner.

### Using the object ACLs to grant access

To grant access to an object or a container:

        mydir = conn.directories.get('rgtest2')  # grant uses username
        mydir.grant("rw", ["someuser"])
        mydir.save                               # share the url for access to container
        mydir.public_url
        # => "https://objects.xxxx.hpcloud.net:443/v1/1111111/rgtest2"

        myfile = mydir.files.get("sample.txt")   # share the url for access to object
        myfile.public_url
        # => "https://objects.xxxx.hpcloud.net:443/v1/1111111/rgtest2/sample.txt"

### Using the object ACLs to access shared objects

1. Use the shared URLs to get the contents of a shared container:

        sd = conn.shared_directories.get(mydir.public_url)
        sd.url
        # => "https://objects.xxxx.hpcloud.net:443/v1/1111111/rgtest2"
        sd.files

  **Note**: If the grantee does not have access, the system generates an exception of type `Fog::HP::Errors::Forbidden`.

2. Use the shared URLs to get the metadata for a container:

        sd = conn.shared_directories.head(mydir.public_url)

  **Note**: If the grantee does not have access, the system generates an exception of type `Fog::HP::Errors::Forbidden`.

3. Use the shared URLs to get the contents of a shared object:

        sd = conn.shared_directories.get(mydir.public_url)
        sf = sd.files.get('sample.txt')

4. Use the shared URLs to get the metadata for a shared object:

        sd = conn.shared_directories.get(mydir.public_url)
        sf = sd.files.head('sample.txt')

5. Use the shared URLs to put a new object or file into a shared container:

        sd = conn.shared_directories.get(mydir.public_url)
        sf = sd.files.create(:key => 'tiny2.txt', :body => "This is another text file.")

  **Note**: If the grantee does not have access, the system generates an exception of type `Fog::HP::Errors::Forbidden`.

6. Use the shared URLs to update an existing object or file in a shared container:

        sd = conn.shared_directories.get(mydir.public_url)
        sf = sd.files.new(:key => 'sample.txt')
        sf.body = "This is another text file."
        sf.save

  **Note**: If the grantee does not have access, the system generates an exception of type `Fog::HP::Errors::Forbidden`.

7. Use the shared URLs to delete an existing object or file from a shared container:

        sd = conn.shared_directories.get(mydir.public_url)
        sd.destroy

### Synchronize containers across regions

Synchronizing containers creates a one-way association from containers to the sync objects. The sync operation is performed by a background process on the container server. You must perform a one-time setup to set the metadata on the containers for syncing.

1. One-Way sync of containers (from source to target only):

        # create source and target containers
        conn.directories.create(:key => 'imp_stuff')
        conn.directories.create(:key => 'sync_archive')
        dir = conn.directories.get('imp_stuff')
        target_dir = conn.directories.get('sync_archive')

        # create some objects in the source container
        dir.files.create(:key => 'imp_1.txt', :body => "This is a small file but it is very important.")
        dir.files.create(:key => 'imp_2.txt', :body => "This is another small file but it is very important as well.")

        # sync the source -> target
        dir.sync(target_dir, "boogieman")       # => true
        dir.save                                # => true

2. Two-Way sync of containers (from source to target and back):

        # Now, lets do a two way sync between dir and target containers
        dir = conn.directories.get('imp_stuff')
        target_dir = conn.directories.get('sync_archive')

        # sync the target -> source
        target_dir.sync(dir, "boogieman")       # => true
        target_dir.save                         # => true

3. One and two-way sync of containers across regions:

        # assuming source container exists in region-a
        dir_a = conn.directories.get('imp_stuff')          # Note: conn points to region-a
        # assuming target container exists in region-a
        target_dir_b = conn2.directories.get('arch_imp_stuff')  # Note: conn2 points to region-b

        # sync the source -> target
        dir_a.sync(target_dir_b, "boogieman") # => true
        dir_a.save # => true

        # sync the target -> source
        target_dir_b.sync(dir_a, "boogieman") # => true
        target_dir_b.save #=> true


## Using the Request Abstraction

1. List all container for the given account:

        response = conn.get_containers
        response.body               # returns an array of container hash objects
        response.body[0]["name"]    # returns the name of the container
        response.body[0]["count"]   # returns the number of objects in the container
        response.body[0]["bytes"]   # returns the total bytes for the objects in the container

2. Create a new container:

        container = conn.put_container("fog-rocks")   # creates the container
        container.headers                             # returns a hash of headers
        container.headers["Content-Length"]           # returns the content-length

3. View a container:

        container = conn.get_container("fog-rocks")
        container.body                                # returns an array of objects hash
        container.body[0]['name']                     # returns the name of the object
        container.headers                             # returns a hash of headers
        container.headers["Content-Length"]           # returns the content-length
        container.headers["Content-Type"]             # returns the content-type
        container.headers["X-Container-Object-Count"] # returns the number of objects in the container
        container.headers["X-Container-Bytes-Used"]   # returns the total bytes for the objects in the container
        container.status                              # HTTP status code for the operation

4. View the container's headers and metadata without getting the content:

        container = conn.head_container("fog-rocks")
        container.body                             # returns an empty body
        container.headers                          # returns a hash of headers
        container.headers["Content-Length"]        # returns the content-length
        container.headers["Content-Type"]          # returns the content-type
        container.status                           # HTTP status code for the operation

5. Create a new file into an existing container:

        file = conn.put_object("fog-rocks", "sample.txt", File.open('/path/to/file/sample.txt'))
        file.headers                            # returns a hash of headers
        file.headers["Content-Length"]          # returns the content-length

6. View a file from an existing container:

        file = conn.get_object("fog-rocks", "sample.txt")
        file.body                               # returns the contents of the file
        file.headers                            # returns a hash of headers
        file.headers["Content-Length"]          # returns the content-length
        file.headers["Content-Type"]            # returns the content-type
        file.status                             # HTTP status code for the operation

7. View the file's headers and metadata without getting the content:

        file = conn.head_object("fog-rocks", "sample.txt")
        file.body                               # returns the empty body
        file.headers                            # returns a hash of headers
        file.headers["Content-Length"]          # returns the content-length
        file.headers["Content-Type"]            # returns the content-type
        file.status                             # HTTP status code for the operation

8. Copy a file within the same container:

        # copy an object
        conn.put_object("fog-rocks", "another-sample.txt", nil, {'X-Copy-From' => "/fog-rocks/sample.txt" })
        # get the copied object
        other_file = conn.get_object("fog-rocks", "another-sample.txt")
        other_file.headers                            # returns a hash of headers
        other_file.headers["Content-Length"]          # returns the content-length

9. Copy a file from one container to another container:

        # create a new container
        conn.put_container("fog-rocks-2")             # creates the other new container
        # copy the object
        conn.put_object("fog-rocks-2", "sample.txt", nil, {'X-Copy-From' => "/fog-rocks/sample.txt" })
        # get the copied object
        other_file = conn.get_object("fog-rocks-2", "sample.txt")
        other_file.headers                            # returns a hash of headers
        other_file.headers["Content-Length"]          # returns the content-length

10. Generate a temporary URL for a file or object for sharing purposes:

        # creates a TempUrl to access sample.txt and access expires in 240 secs
        conn.get_object_temp_url("fog-rocks", "sample.txt", 240, "GET")

11. Delete a file from an existing container:

        conn.delete_object("fog-rocks", "sample.txt")
        conn.delete_object("fog-rocks", "another-sample.txt")

12. Delete an existing container:

        # Note: a container needs to be empty before it can be deleted!
        conn.delete_container("fog-rocks")

### Using Object ACLs

To use object ACLs in the request abstraction layer, you need to have already been granted permission to access the objects or containers.  (See the section on [Using Object ACLs](#UsingObjectACLsModelLayer) in the Model Layer section above for information on granting access.)

1. Use the shared URLs to get the contents of a shared container:

        conn.get_shared_container(mydir.public_url)

  **Note**: If the grantee does not have access, the system generates an exception of type `Fog::HP::Errors::Forbidden`.

2. Use the shared URLs to get the metadata of a shared container:

        conn.head_shared_container(mydir.public_url)

  **Note**: If the grantee does not have access, the system generates an exception of type `Fog::HP::Errors::Forbidden`.

3. Use the shared URLs to get the contents of a shared object:

        conn.get_shared_object(myfile.public_url)

4. Use the shared URLs to get the metadata for a shared object

        conn.head_shared_object(myfile.public_url)

5. Use the shared URLs to put a new object or file into a shared container:

        conn.put_shared_object(mydir.public_url, 'tiny.txt', File.read('tiny.txt'))

  **Note**: If the grantee does not have access, the system generates an exception of type `Fog::HP::Errors::Forbidden`.

6. Use the shared URLs to update an existing object or file in a shared container:

        conn.put_shared_object(mydir.public_url, 'sample.txt', "This text needed some update.")

  **Note**: If the grantee does not have access, the system generates an exception of type `Fog::HP::Errors::Forbidden`.

7. Use the shared URLs to delete an existing object or file from a shared container:

        conn.delete_shared_object(myfile.public_url)

### Synchronize containers across regions

Synchronizing containers creates a one-way association from containers to the sync objects. The sync operation is performed by a background process on the container server. You must perform a one-time setup to set the metadata on the containers for syncing.

1. One-Way sync of containers (from source to target only):

        # create source and target containers
        conn.put_container('imp_stuff')
        conn.put_container('sync_archive')

        # create some objects in the source container
        conn.put_object('imp_stuff', 'imp_1.txt', "This is a small file but it is very important.")
        conn.put_object('imp_stuff', 'imp_2.txt', File.open('/path/to/file/imp_2.txt'))

        # to sync we need to put some metadata on the source and target containers
        conn.put_container('imp_stuff',
                            {'X-Container-Sync-To'  => "/url/to/the/target/sync_archive",
                             'X-Container-Sync-Key' => 'boogieman'})
        conn.put_container('sync_archive',
                            {'X-Container-Sync-Key' => 'boogieman'})

2. Two-Way sync of containers (from source to target and visa-versa):

        # Now, lets do a two way sync between dir and target containers
        # to sync we need to put some metadata on the source and target containers
        conn.put_container('imp_stuff',
                            {'X-Container-Sync-To'  => "/url/to/the/target/sync_archive",
                             'X-Container-Sync-Key' => 'boogieman'})
        conn.put_container('sync_archive',
                            {'X-Container-Sync-To'  => "/url/to/the/source/imp_stuff",
                             'X-Container-Sync-Key' => 'boogieman'})

3. One and two-way sync of containers across regions:

        # assuming source container exists in region-a
        conn.get_container('imp_stuff')                         # Note: conn points to region-a
        # create a new container in region-b
        conn2.put_container('arch_imp_stuff')                   # Note: conn2 points to region-b

        # to sync we need to put some metadata on the source and target containers
        conn.put_container('imp_stuff',
                            {'X-Container-Sync-To'  => "/region-b/url/to/the/target/arch_imp_stuff",
                             'X-Container-Sync-Key' => 'boogieman'})
        conn2.put_container('arch_imp_stuff',
                              {'X-Container-Sync-To'  => "/region-a/url/to/the/source/imp_stuff",
                               'X-Container-Sync-Key' => 'boogieman'})

---------
[Documentation Home](https://github.com/fog/fog/blob/master/lib/fog/hp/README.md) | [Examples](https://github.com/fog/fog/blob/master/lib/fog/hp/examples/getting_started_examples.md)
