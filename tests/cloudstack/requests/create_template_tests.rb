Shindo.tests('Fog::Compute[:cloudstack] | create template requests', ['cloudstack']) do

  @create_template_format = {
    'createtemplateresponse' => {
      'id'                => Integer,
      'clusterid'         => Fog::Nullable::Integer,
      'clustername'       => Fog::Nullable::String,
      'created'           => Fog::Nullable::Time,
      'disksizeallocated' => Fog::Nullable::Integer,
      'disksizetotal'     => Fog::Nullable::Integer,
      'ipaddress'         => Fog::Nullable::String,
      'jobid'             => Fog::Nullable::Integer,
      'jobstatus'         => Fog::Nullable::String,
      'name'              => Fog::Nullable::String,
      'path'              => Fog::Nullable::String,
      'podid'             => Fog::Nullable::Integer,
      'podname'           => Fog::Nullable::String,
      'state'             => Fog::Nullable::String,
      'tags'              => Fog::Nullable::Array,
      'type'              => Fog::Nullable::String,
      'zoneid'            => Fog::Nullable::Integer,
      'zonename'          => Fog::Nullable::String
    }
  }

  tests('success') do

    tests('#create_template').formats(@create_template_format) do
      Fog::Compute[:cloudstack].create_template('FogTest', 'FogTest', 112, {'volumeid' => 1})
    end

  end

end