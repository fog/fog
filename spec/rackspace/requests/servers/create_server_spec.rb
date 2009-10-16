require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Rackspace::Servers.create_server' do
  describe 'success' do

    it "should return proper attributes" do
      # flavor 1 = 256
      # image 3 = gentoo 2008.0
      data = servers.create_server(1, 3)
      p data
      while true do
        sleep(1)
        details = servers.list_servers_details.body
        p details['servers'].first['progress']
        break if details['servers'].first['status'] == 'ACTIVE'
      end
      servers.delete_server(data.body['server']['id'])
    end

  end
end