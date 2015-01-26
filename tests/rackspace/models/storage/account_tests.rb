Shindo.tests('Fog::Rackspace::Storage | account', ['rackspace']) do

  @account = Fog::Storage[:rackspace].account

  tests('load') do
    headers = @account.service.head_containers.headers

    returns(headers['X-Account-Meta-Temp-Url-Key']) { @account.meta_temp_url_key }
    returns(headers['X-Account-Container-Count'].to_i) { @account.container_count }
    returns(headers['X-Account-Bytes-Used'].to_i) { @account.bytes_used }
    returns(headers['X-Account-Object-Count'].to_i) { @account.object_count }
  end

  tests('reload') do
    @account.reload
  end

  tests('save') do
    key = "testing-update-#{Time.now.to_i}"
    @account.meta_temp_url_key = "testing-update-#{Time.now.to_i}"
    @account.save

    headers = @account.service.head_containers.headers
    returns(key) { headers['X-Account-Meta-Temp-Url-Key'] }
  end
end
