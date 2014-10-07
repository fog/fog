Shindo.tests('Fog::Google[:sql] | ssl_cert requests', ['google']) do
  @sql = Fog::Google[:sql]
  @instance_id = Fog::Mock.random_letters(16)
  @instance = @sql.instances.create(:instance => @instance_id, :tier => 'D1')
  @instance.wait_for { ready? }

  @get_ssl_cert_format = {
    'sha1Fingerprint' => String,
    'cert' => String,
    'certSerialNumber' => String,
    'commonName' => String,
    'createTime' => String,
    'expirationTime' => Fog::Nullable::String,
    'instance' => String,
    'kind' => String,
  }

  @insert_ssl_cert_format = {
    'kind' => String,
    'serverCaCert' => @get_ssl_cert_format,
    'clientCert' => {
      'certInfo' => @get_ssl_cert_format,
      'certPrivateKey' => String,
    },
  }

  @list_ssl_certs_format = {
    'kind' => String,
    'items' => [@get_ssl_cert_format],
  }

  @delete_ssl_cert_format = {
    'kind' => String,
    'operation' => String,
  }

  tests('success') do

    tests('#insert_ssl_cert').formats(@insert_ssl_cert_format) do
      @sql.insert_ssl_cert(@instance_id, Fog::Mock.random_letters(16)).body
    end

    tests('#list_ssl_certs').formats(@list_ssl_certs_format) do
      @sql.list_ssl_certs(@instance_id).body
    end

    tests('#get_ssl_cert').formats(@get_ssl_cert_format) do
      sha1_fingerprint = @sql.ssl_certs.all(@instance_id).first.sha1_fingerprint
      @sql.get_ssl_cert(@instance_id, sha1_fingerprint).body
    end

    tests('#delete_ssl_cert').formats(@delete_ssl_cert_format) do
      sha1_fingerprint = @sql.ssl_certs.all(@instance_id).first.sha1_fingerprint
      @sql.delete_ssl_cert(@instance_id, sha1_fingerprint).body
    end

  end

  @instance.destroy

end
