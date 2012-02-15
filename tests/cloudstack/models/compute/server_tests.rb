Shindo.tests("Fog::Compute[:cloudstack]") do

  options = {
    :provider => "cloudstack",
    :cloudstack_scheme => "http",
    :cloudstack_host => "10.29.1.7",
    :cloudstack_path => "/client/api",
    :cloudstack_port => "8080",
    :cloudstack_api_key => "NO9tGPmwnsqsPPROzYlC66jSBdFwJ9kT6t-seN4WcGbwcjVp--zIVdQ7xvIUDGpM-jo2H8Yg1lFqMjh8CtbBLA",
    :cloudstack_secret_access_key => "4akkQ4e-Hm_GXYB7xMPibQUkU_WEdwNAWlNq-abDqo6TOMtZlZPdTVpivZKrtvHB7Z4BSQ9VgeYp_8hCS86DCg"
  }

  compute = Fog::Compute.new options

  @instance = compute.servers.new

  # [:addresses, :flavor, :key_pair, :key_pair=, :volumes].each do |association|
  #   responds_to(association)
  # end

  @instance.save

  @instance.wait_for { ready? }

  @instance.destroy

end
