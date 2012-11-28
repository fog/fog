provider, config = :ecloud, compute_providers[:ecloud]
connection    = Fog::Compute[provider]
organization = connection.organizations.first
environment  = organization.environments.first
public_ips   = environment.public_ips
public_ip    = public_ips.first

Shindo.tests("Fog::Compute[:#{provider}] | internet_services", "queries") do
  @internet_services = public_ip.internet_services

  tests('#all').succeeds do
    returns(false, "has services") { @internet_services.all.empty? }
  end

  tests('#get').succeeds do
    service = @internet_services.first
    fetched_service = connection.internet_services.get(service.href)
    returns(false, "service is not nil") { fetched_service.nil? }
    returns(true, "is an InternetService") { fetched_service.is_a?(Fog::Compute::Ecloud::InternetService) }
  end
end
