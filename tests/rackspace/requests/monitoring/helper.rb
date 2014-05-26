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

LIST_MONITORING_ZONE = {
    "values"=>
      [{"id"=>String,
        "label"=> Fog::Nullable::String,
        "country_code"=> String,
        "source_ips"=>[String, String]}],
     "metadata"=>
      {"count"=>Integer,
       "limit"=>Integer,
       "marker"=>Fog::Nullable::String,
       "next_marker"=>Fog::Nullable::String,
       "next_href"=>Fog::Nullable::String
     }
}

GET_MONITORING_ZONE = {
    "id" => String,
    "label" => String,
    "country_code" => String,
    "source_ips" => [String]
}

# {"values"=>
#   [{"id"=>"ch4GimHQsQ",
#     "label"=>nil,
#     "type"=>"remote.http",
#     "details"=>
#      {"url"=>"http://www.rackspace.com",
#       "method"=>"GET",
#       "follow_redirects"=>true,
#       "include_body"=>false},
#     "monitoring_zones_poll"=>["mzdfw"],
#     "timeout"=>30,
#     "period"=>100,
#     "target_alias"=>nil,
#     "target_hostname"=>"rackspace.com",
#     "target_resolver"=>"IPv4",
#     "disabled"=>false,
#     "collectors"=>["coeT7x1iF3"],
#     "metadata"=>nil,
#     "created_at"=>1377803830760,
#     "updated_at"=>1377803830760}],
#  "metadata"=>
#   {"count"=>1,
#    "limit"=>100,
#    "marker"=>nil,
#    "next_marker"=>nil,
#    "next_href"=>nil}}

# {"values"=>
#   [{"id"=>String,
#     "label"=>String,
#     "country_code"=>String,
#     "source_ips"=>[String, String]}],
#  "metadata"=>
#   {"count"=>Integer,
#    "limit"=>Integer,
#    "marker"=>nil,
#    "next_marker"=>nil,
#    "next_href"=>nil}}

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
