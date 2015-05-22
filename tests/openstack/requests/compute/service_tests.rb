Shindo.tests('Fog::Compute[:openstack] | service requests', ['openstack']) do

  @service_format = {
    "id"              => Integer,
    "binary"          => String,
    "host"            => String,
    "state"           => String,
    "status"          => String,
    "updated_at"      => String,
    "zone"            => String,
    'disabled_reason' => Fog::Nullable::String
  }

  tests('success') do
    tests('#list_services').data_matches_schema({'services' => [@service_format]}) do
      services = Fog::Compute[:openstack].list_services.body
      @service = services['services'].last
      services
    end

    tests('#disable_service').succeeds do
      Fog::Compute[:openstack].disable_service(@service['host'], @service['binary'])
    end

    tests('#disable_service_log_reason').succeeds do
      Fog::Compute[:openstack].disable_service_log_reason(@service['host'], @service['binary'], 'reason')
    end

    tests('#enable_service').succeeds do
      Fog::Compute[:openstack].enable_service(@service['host'], @service['binary'])
    end
  end
end
