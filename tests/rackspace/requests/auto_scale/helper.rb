### FORMATS

LIST_GROUPS_FORMAT =
  { "groups_links"=>[],
    "groups"=> [
      {
        "state" => {
          "paused"=> Fog::Boolean,
          "desiredCapacity"=> Integer,
          "active"=>[],
          "pendingCapacity"=> Integer,
          "activeCapacity"=> Integer,
          "name"=> String
        }
      }
    ]
  }

GROUP_STATE_FORMAT =  {
  "group" => {
    "paused"=> Fog::Boolean,
    "desiredCapacity" => Integer,
    "active"=>[],
    "pendingCapacity" => Integer,
    "activeCapacity" => Integer,
    "name"=> String
    }
  }

GET_GROUP_HEADERS_FORMAT = {
  "Content-Type"=>String,
  "Via"=>String,
  "x-response-id"=>String,
  "Date"=>String,
  "Transfer-Encoding"=>String,
  "Server"=>String
}

GROUP_DELETE_DATA_FORMAT = {
  :headers=> {
    "Content-Type"=>String,
    "Via"=>String,
    "x-response-id"=>String,
    "Date"=>String,
    "Server"=>String
  },
  :status=>Integer,
  :remote_ip=>String
}

LAUNCH_CONFIG_FORMAT = {
  "args" => {
      "loadBalancers" => [
        {
          "port" => Integer,
          "loadBalancerId" => Integer
        }
      ],
      "server" => {
        "name" => String,
        "imageRef" => String,
        "flavorRef" => String,
        "OS-DCF =>diskConfig" => String,
        "metadata" => {
          "build_config" => String,
          "meta_key_1" => String,
          "meta_key_2" => String
        },
        "networks" => [
          {
            "uuid" => String
          },
          {
            "uuid" => String
          }
        ],
        "personality" => [
          {
            "path" => String,
            "contents" => String
          }
        ]
      }
    },
    "type" => String
}

GROUP_CONFIG_FORMAT = {
  "maxEntities" => Integer,
  "cooldown" => Integer,
  "name" => String,
  "minEntities" => Integer,
  "metadata" => {
    "gc_meta_key_2" => String,
    "gc_meta_key_1" => String
  }
}

POLICY_FORMAT = {
    "name"=> String,
    "links"=> Array,
    "cooldown"=>Integer,
    "type"=>String,
    "id"=>String,
    "change"=>Integer
  }

POLICIES_FORMAT = [POLICY_FORMAT]

GROUP_FORMAT = {
  "group" => {
    "launchConfiguration" => LAUNCH_CONFIG_FORMAT,
    "groupConfiguration" => GROUP_CONFIG_FORMAT,
    "scalingPolicies" => POLICIES_FORMAT,
    "links" => [
      {
        "href" => String,
        "rel" => String
      }
    ],
    "id" => String
  }
}

WEBHOOK_FORMAT = {
    "id" => String,
    "name" => String,
    "metadata" => Hash,
    "links" => Array
}

LIST_WEBHOOKS_FORMAT = [
  {
    "id" => String,
    "name" => String,
    "links"=>[{"href" => String, "rel" => String }],
    "metadata"=>{}
  }
]

### OPTIONS

LAUNCH_CONFIG_OPTIONS = {
	"args" => {
      "loadBalancers" => [
        {
          "port" => 8080,
          "loadBalancerId" => 9099
        }
      ],
      "server" => {
        "name" => "autoscale_server",
        "imageRef" => "0d589460-f177-4b0f-81c1-8ab8903ac7d8",
        "flavorRef" => "2",
        "OS-DCF =>diskConfig" => "AUTO",
        "metadata" => {
          "build_config" => "core",
          "meta_key_1" => "meta_value_1",
          "meta_key_2" => "meta_value_2"
        },
        "networks" => [
          {
            "uuid" => "11111111-1111-1111-1111-111111111111"
          },
          {
            "uuid" => "00000000-0000-0000-0000-000000000000"
          }
        ],
        "personality" => [
          {
            "path" => "/root/.csivh",
            "contents" => "VGhpcyBpcyBhIHRlc3QgZmlsZS4="
          }
        ]
      }
    },
    "type" => "launch_server"
}

GROUP_CONFIG_OPTIONS = {
	"maxEntities" => 3,
	"cooldown" => 360,
	"name" => "testscalinggroup198547",
	"minEntities" => 0,
	"metadata" => {
	  "gc_meta_key_2" => "gc_meta_value_2",
	  "gc_meta_key_1" => "gc_meta_value_1"
	}
}

POLICIES_OPTIONS = [
    {
      "cooldown" => 0,
      "type" => "webhook",
      "name" => "scale up by 1",
      "change" => 1
    }
  ]

POLICY_OPTIONS = {
  "cooldown" => 0,
  "type" => "webhook",
  "name" => "FOOBAR",
  "change" => 1
}

GROUP_OPTIONS = {
    "launchConfiguration" => LAUNCH_CONFIG_OPTIONS,
    "groupConfiguration" => GROUP_CONFIG_OPTIONS,
    "scalingPolicies" => POLICIES_OPTIONS
}

WEBHOOK_OPTIONS = {
    "name" => "webhook name",
    "metadata" => {'foo' => 'bar'}
}

def deactive_auto_scale_group(group)
  return unless group
  config = group.group_config
  config.min_entities = 0
  config.max_entities = 0
  config.save
end
