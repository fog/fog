MINIMAL_HEADERS_FORMAT = {
  'X-RateLimit-Window' => String,
  'X-RateLimit-Limit' => String,
  'X-RateLimit-Type' => String,
  'Content-Type' => String,
  'Date' => String,
}
DELETE_HEADERS_FORMAT = MINIMAL_HEADERS_FORMAT.merge({
  'Content-Length' => String
})
HEADERS_FORMAT = MINIMAL_HEADERS_FORMAT.merge({
  'Content-Length' => String,
  'X-Object-ID' => String,
  'Location' => String
})
LIST_HEADERS_FORMAT = MINIMAL_HEADERS_FORMAT.merge({
  'X-RateLimit-Remaining' => String,
  'X-Response-Id' => String,
  'Transfer-Encoding' => String,
  'X-LB' => String,
  'Vary' => String
})

DATA_FORMAT = {
  :status => Integer,
  :body => String,
  :headers => HEADERS_FORMAT,
  :remote_ip => String
}
DELETE_DATA_FORMAT = {
  :status => Integer,
  :body => String,
  :headers => DELETE_HEADERS_FORMAT,
  :remote_ip => String
}

CHECK_CREATE_OPTIONS = {
  :details => {
    :url => 'http://www.rackspace.com',
    :method => 'GET',
  },
  :type => 'remote.http',
  :monitoring_zones_poll => ['mzdfw'],
  :target_hostname => 'rackspace.com',
  :timeout => 30,
  :period => 100
}

OVERVIEW_FORMAT = {
  :status => Integer,
  :body=> {
    :values => [
      {
        :entity => {
          :id => String,
          :label => String,
          :ip_addresses => { },
          :metadata => String
        },
        :checks => [
        ],
        :alarms => [
        ],
        :latest_alarm_states => [
        ]
      }
    ],
    :metadata => {
      :count => Integer,
      :limit => Integer,
      :marker => String,
      :next_marker => String,
      :next_href => String 
    }
  },
  :headers => LIST_HEADERS_FORMAT,
  :remote_ip => String
}
