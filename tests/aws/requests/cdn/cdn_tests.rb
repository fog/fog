Shindo.tests('Fog::CDN[:aws] | CDN requests', ['aws', 'cdn']) do

  @cf_connection = Fog::CDN[:aws]

  tests('success') do

    test('get current ditribution list count') do
      pending if Fog.mocking?

      @count= 0
      response = @cf_connection.get_distribution_list
      if response.status == 200
        @distributions = response.body['DistributionSummary']
        @count = @distributions.count
      end

      response.status == 200
    end

    test('create distribution') {
      pending if Fog.mocking?

      result = false

      response = @cf_connection.post_distribution('S3Origin' => { 'DNSName' => 'test_cdn.s3.amazonaws.com'}, 'Enabled' => true)
      if response.status == 201
        @dist_id = response.body['Id']
        @etag = response.headers['ETag']
        @caller_reference = response.body['DistributionConfig']['CallerReference']
        if (@dist_id.length > 0)
          result = true
        end
      end

      result
    }

    test("get info on distribution #{@dist_id}") {
      pending if Fog.mocking?

      result = false

      response = @cf_connection.get_distribution(@dist_id)
      if response.status == 200
        @etag = response.headers['ETag']
        status = response.body['Status']
        if ((status == 'Deployed') or (status == 'InProgress')) and not @etag.nil?
          result = true
        end
      end

      result
    }

    test('list distributions') do
      pending if Fog.mocking?

      result = false

      response = @cf_connection.get_distribution_list
      if response.status == 200
        distributions = response.body['DistributionSummary']
        if (distributions.count > 0)
          dist = distributions[0]
          dist_id = dist['Id']
        end
        max_items = response.body['MaxItems']

        if (dist_id.length > 0) and (max_items > 0)
          result = true
        end

      end

      result
    end

    test("invalidate paths") {
      pending if Fog.mocking?

      response = @cf_connection.post_invalidation(@dist_id, ["/test.html", "/path/to/file.html"])
      if response.status == 201
        @invalidation_id = response.body['Id']
      end

      response.status == 201
    }

    test("list invalidations") {
      pending if Fog.mocking?

      result = false

      response = @cf_connection.get_invalidation_list(@dist_id)
      if response.status == 200
        if response.body['InvalidationSummary'].find { |f| f['Id'] == @invalidation_id }
          result = true
        end
      end

      result
    }

    test("get invalidation information") {
      pending if Fog.mocking?

      result = false

      response = @cf_connection.get_invalidation(@dist_id, @invalidation_id)
      if response.status == 200
        paths = response.body['InvalidationBatch'].sort
        status = response.body['Status']
        if status.length > 0 and paths == [ '/test.html', '/path/to/file.html' ].sort
          result = true
        end
      end

      result
    }

    test("disable distribution #{@dist_id}") {
      pending if Fog.mocking?

      result = false

      response = @cf_connection.put_distribution_config(@dist_id, @etag, 'S3Origin' => { 'DNSName' => 'test_cdn.s3.amazonaws.com'}, 'Enabled' => false, 'CallerReference' => @caller_reference)
      if response.status == 200
        @etag = response.headers['ETag']
        unless @etag.nil?
          result = true
        end
      end

      result
    }

    test("remove distribution #{@dist_id}") {
      pending if Fog.mocking?

      result = true

      # unfortunately you can delete only after a distribution becomes Deployed
      first = Time.now
      catch(:deployed) do
        loop do 
          response = @cf_connection.get_distribution(@dist_id)
          return false if response.status != 200
          return false if (Time.now - first) > 20 * 60 # abort after 20 minutes

          if response.status == 200 and response.body['Status'] == 'Deployed'
            @etag = response.headers['ETag']
            throw :deployed
          end
          sleep 15
        end
      end

      response = @cf_connection.delete_distribution(@dist_id, @etag)
      if response.status != 204
        result = false
      end

      result
    }
  end
end
