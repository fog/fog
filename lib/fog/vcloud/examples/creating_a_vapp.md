# Creating a vApp

      connection.servers.create(
        :vdc_uri            => vdc-uuid,
        :catalog_item_uri   => catalog-uuid,
        :name               => vApp-name,
        :network_uri        => network-uri,
        :network_name       => network-name,
        :connection_options => {
          :ssl_verify_peer   => false,
          :omit_default_port => true
        }
      )

- Not most of the uris can be found by understanding the vcloud api
  eg various network information can be retrieved by
  `connection.servers.service.networks`
