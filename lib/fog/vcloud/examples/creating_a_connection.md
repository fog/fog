# Creating a connection

      connection = Fog::Compute.new(
        :provider           => :vcloud,
        :vcloud_username    => "username@org-name",
        :vcloud_password    => password,
        :vcloud_host        => vendor-api-endpoint-host,
        :vcloud_default_vdc => default_vdc_uri,
        :connection_options => {
          :ssl_verify_peer   => false,
          :omit_default_port => true
        }
      )

- Refer to links in [vcloud/examples/README.md](/lib/fog/vcloud/examples/REAME.md)
  for find various different uris
- connection_options are passed down to `excon`, which is used by fog to make
  http requests.
    - We using `omit_default_port`, as currently excon adds port to host entry
      in headers, which might not be compatible with various vendors.
