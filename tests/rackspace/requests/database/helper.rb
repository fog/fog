
LINK_FORMAT = [{'href' => String, 'rel' => String}]

DATABASE_INSTANCE_FORMAT = {
    'created' => String,
    'flavor' => {
      'id' => String,
      'links' => LINK_FORMAT
    },
    'hostname' => String,
    'id' => String,
    'links' => LINK_FORMAT,
    'name' => String,
    'status' => String,
    'updated' => String,
    'volume' => { 'size' => Integer},
  }
DATABASE_CREATE_INSTANCE_FORMAT = {
  'instance' => DATABASE_INSTANCE_FORMAT
}

DATABASE_GET_INSTANCE_FORMAT = {
  'instance' => DATABASE_INSTANCE_FORMAT.merge({'rootEnabled' => Fog::Boolean, 'volume' => {'size' => Integer, 'used' => Float}})
}

DATABASE_LIST_INSTANCES_FORMAT = {
  'instances' => [
    DATABASE_INSTANCE_FORMAT
  ]
}

DATABASE_FLAVORS_FORMAT = {
  'flavors' => [
    {
      'id' => Integer,
      'vcpus' => Integer,
      'ram' => Integer,
      'links' => LINK_FORMAT,
      'name' => String
    }
  ]
}
