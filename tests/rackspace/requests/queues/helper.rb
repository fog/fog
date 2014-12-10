VALID_TTL = 300
VALID_GRACE = 300

METADATA_FORMAT = {
}

QUEUE_FORMAT = {
  'metadata' => METADATA_FORMAT
}

LIST_QUEUES_FORMAT = {
  'queues' => [
    QUEUE_FORMAT.merge({
      'name' => String,
      'href' => String,
    })
  ],
  'links' => LINKS_FORMAT
}

MESSAGE_FORMAT = {
  'href' => String,
  'ttl' => Integer,
  'age' => Integer,
  'body' => Hash
}

LIST_MESSAGES_FORMAT = {
 'messages' => [MESSAGE_FORMAT],
 'links' => LINKS_FORMAT
}

CREATE_CLAIM_FORMAT = [
  MESSAGE_FORMAT
]

CLAIM_FORMAT = {
  'ttl' => Integer,
  'age' => Integer,
  'messages' => [
    MESSAGE_FORMAT
  ]
}

QUEUE_STATS_FORMAT = {
  'messages' => {
    'free' => Integer,
    'claimed' => Integer
  }
}
