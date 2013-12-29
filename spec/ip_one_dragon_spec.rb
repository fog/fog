require 'fog/cloudstack'
require 'fog/compute'

describe "My behaviour" do

  it "should do something" do

    #To change this template use File | Settings | File Templates.
    cloudstack = Fog::Compute.new(
        :provider =>           'Cloudstack',
        :cloudstack_host=>     '172.17.13.188',
        :cloudstack_port=>     '8080',
        :cloudstack_scheme=>   'http',
        :cloudstack_api_key=>  'C1aCo8A5J_fqiTbTv9Tj9MlU-8tTO2aOJeb4XFYciDl9TK9OGAHE71Yb9ZXsp8L9-Lt3OBWiF9chEDEjQEI74Q',
        :cloudstack_secret_access_key=> 'worQERQsTaor80zPdJGvxlPoLSrHJiPefftpZut_OYJkaQ6ygCB03aiK1ahqqKTXBNUEQml-rSLU-n-5hnL5ag'
    )
    vlan = cloudstack.vlans.new(
        :zone_id => '745c3088-4d8d-4198-8b1b-053658596cb9',
        #:gateway => '172.17.13.254',
        :netmask => '255.255.255.0',
        :start_ip => '172.17.13.232',
        :end_ip => '172.17.13.232',
        :vlan => 'untagged'
    )
    vlan.create_vlan_ip_range
    puts(vlan.id)
    ipaddress = cloudstack.ipaddresses.new(options={'network_id' => "eeb3f852-5b68-4793-a5c6-f243d8858172"})
    ipaddressjob = ipaddress.associate
    ipaddressjob.wait_for { ready? }
    nat = cloudstack.nats.new(
        'ip_address_id'        => ipaddress.id,
        'virtual_machine_id'     => 'b5b4c2c1-d4be-4638-a5f2-a9fdb9191c58'
    )
    nat.enable
  end
end