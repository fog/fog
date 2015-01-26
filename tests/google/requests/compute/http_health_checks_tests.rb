Shindo.tests('Fog::Compute[:google] | HTTP health checks requests', ['google']) do

  @google = Fog::Compute[:google]

  @insert_http_health_check_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'zone' => String,
      'insertTime' => String,
      'startTime' => String,
      'operationType' => String
  }

  @get_http_health_check_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'host' => String,
      'requestPath' => String,
      'port' => Integer,
      'checkIntervalSec' => Integer,
      'timeoutSec' => Integer,
      'unhealthyThreshold' => Integer,
      'healthyThreshold' => Integer
  }

  @delete_http_health_check_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'targetId' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'insertTime' => String,
      'zone' => String,
      'startTime' => String,
      'operationType' => String
  }

  @list_http_health_checks_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'items' => Array
  }

  tests('success') do

    http_health_check_name = 'test-http-health-check'

    # These will all fail if errors happen on insert
    tests("#insert_http_health_check").formats(@insert_http_health_check_format) do
      response = @google.insert_http_health_check(http_health_check_name).body
      wait_operation(@google, response)
      response
    end

    tests("#get_http_health_check").formats(@get_http_health_check_format) do
      @google.get_http_health_check(http_health_check_name).body
    end

    tests("#list_http_health_checks").formats(@list_http_health_checks_format) do
      @google.list_http_health_checks.body
    end

    tests("#delete_http_health_check").formats(@delete_http_health_check_format) do
      @google.delete_http_health_check(http_health_check_name).body
    end

  end

end
