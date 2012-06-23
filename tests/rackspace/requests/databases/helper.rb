LINKS_FORMAT = [{
  'href' => String,
  'rel' => String
}]

GET_FLAVOR_FORMAT = {
  'flavor' => {
    'id' => Integer,
    'name' => String,
    'ram' => Integer,
    'vcpus' => Integer,
    'links' => LINKS_FORMAT
  }
}

LIST_FLAVORS_FORMAT = {
  'flavors' => [
    'id' => Integer,
    'name' => String,
    'links' => LINKS_FORMAT
  ]
}

INSTANCE_FORMAT = {
  'id' => String,
  'name' => String,
  'status' => String,
  'links' => LINKS_FORMAT,
}

INSTANCE_DETAILS_FORMAT = INSTANCE_FORMAT.merge({
  'created' => String,
  'updated' => String,
  'hostname' => String,
  'flavor' => {
    'id' => String,
    'links' => LINKS_FORMAT
  },
  'volume' => {
    'size' => Integer
  }
})

CREATE_INSTANCE_FORMAT = {
  'instance' => INSTANCE_DETAILS_FORMAT
}

GET_INSTANCE_FORMAT = {
  'instance' => INSTANCE_DETAILS_FORMAT.merge({
    'rootEnabled' => Fog::Boolean,
    'volume' => {
      'size' => Integer,
      'used' => Float
    }
  })
}

LIST_INSTANCES_FORMAT = {
  'instances' => [
    INSTANCE_FORMAT
  ]
}

CHECK_ROOT_USER_FORMAT = {
  'rootEnabled' => Fog::Boolean
}

ENABLE_ROOT_USER_FORMAT = {
  'user' => {
    'name' => String,
    'password' => String
  }
}

LIST_DATABASES_FORMAT = {
  'databases' => [{
    'name' => String
  }]
}

LIST_USERS_FORMAT = {
  'users' => [{
    'name' => String,
    'databases' => [{
      'name' => String
    }]
  }]
}
