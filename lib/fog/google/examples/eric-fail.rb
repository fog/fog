require 'fog'
def test
 # connection = Fog::Compute.new({ :provider => "Google" })
connection = Fog::Compute.new({ :provider => "google",
            :google_project => "graphite-demos",
            :google_client_email => "982735739546-c1gpjgnpih237338tn1top6768fp7st2@developer.gserviceaccount.com",
            :google_key_location => "~/8061ef9c47ff9f5801ef49b710337808dce88d5d-privatekey.p12"
              })

  name = "fog-smoke-test-#{Time.now.to_i}"
  zone = "us-central1-a"

  disk = connection.disks.create({
    :name => name,
    :size_gb => 10,
    :zone_name => zone,
    :source_image => 'debian-7-wheezy-v20140318',
  })

  disk.wait_for { disk.ready? }

  scopes = [
    "https://www.googleapis.com/auth/compute",
    "devstorage.full_control",
    "userinfo.email"
  ]

  server = connection.servers.create({
    :name => name,
    :disks => [disk],
    :machine_type => "n1-standard-1",
    :zone_name => zone,
    :metadata => {'foo' => 'bar'},
    :tags => ["t1", "t2", "t3"],
    :servce_accounts => scopes
  })
  sleep(90)

  raise "Could not reload created server." unless server.reload
  raise "Could not create sshable server." unless server.ssh("whoami")
  raise "Could not delete server." unless server.destroy
end
test
