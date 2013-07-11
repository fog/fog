DELETE_HEADERS_FORMAT = {
  'X-LB' => String,
  'X-Response-Id' => String,
  'X-RateLimit-Remaining' => String,
  'X-RateLimit-Window' => String,
  'X-RateLimit-Type' => String,
  'Content-Type' => String,
  'Date' => String,
  'X-RateLimit-Limit' => String,
  'Content-Length' => String
}
HEADERS_FORMAT = DELETE_HEADERS_FORMAT.merge({
  'X-Object-ID' => String,
  'Location' => String,
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
