# Shortcut for Fog::Compute[:digitalocean]
def compute
  Fog::Compute[:tutum]
end

def create_test_app
  compute.applications.create(fog_test_application_attributes)
end

def create_test_container
  compute.servers.create(fog_test_container_attributes)
end

def fog_test_application_attributes
  name = fog_application_name
  {
    :name => name,
    :container_size => "XS",
    :target_num_containers => 1,
    :web_public_dns => "#{name}.example.com",
    :image => "tutum/hello-world"
  }
end

def fog_test_container_attributes
  name = fog_application_name
  {
    :name => name,
    :container_size => "XS",
    :web_public_dns => "#{name}.example.com",
    :image => "tutum/hello-world"
  }
end

def wait_for_application(uuid, state)
  unless Fog.mocking?
    response = {}
    sleep 5
    10.times do
      return true if state == compute.application_get(uuid)["state"]
      sleep 1
    end
    return false
  end
end

def wait_for_container(uuid, state)
  unless Fog.mocking?
    response = {}
    sleep 5
    10.times do
      sleep 1
      return true if state == compute.container_get(uuid)["state"]
    end
    return false
  end
end

def fog_application_name
  "fog-test-#{Time.now.to_i}"
end

at_exit do
  unless Fog.mocking? || Fog.credentials[:tutum_api_key].nil?
    puts "Cleaning up tutum objects"
    test_applications = []
    compute.applications.each { |a| test_applications << a if a.name =~ /fog-test-*/}
    test_applications.each { |a| a.stop if a.state == "Running" } 
    test_applications.each do |a|
      a.reload
      wait_for_application(a.uuid, "Stopped") unless ["Init", "Stopped", "Terminated"].include? a.state
      if a.state != "Terminated"
        puts "Terminating application #{a.name} (#{a.uuid})"
        a.destroy 
      end
    end

    test_containers = []
    compute.servers.each { |c| test_containers << c if c.name =~ /fog-test-*/}
    test_containers.each { |c| c.stop if c.state == "Running" } 
    test_containers.each do |c|
      c.reload
      wait_for_container(c.uuid, "Stopped") unless ["Init", "Stopped", "Terminated"].include? c.state
      if c.state != "Terminated"
        puts "Terminating container #{c.name} (#{c.uuid})"
        c.destroy 
      end
    end
  end
end