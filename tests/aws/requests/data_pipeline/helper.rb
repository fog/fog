class AWS
  module DataPipeline
    module Formats

      BASIC = {
        'pipelineId' => String,
      }

      LIST_PIPELINES = {
        "hasMoreResults" => Fog::Nullable::Boolean,
        "marker" => Fog::Nullable::String,
        "pipelineIdList" => [
          {
            "id" => String,
            "name" => String,
          }
        ]
      }

      DESCRIBE_PIPELINES = {
        "pipelineDescriptionList" => [
          {
            "description" => Fog::Nullable::String,
            "name" => String,
            "pipelineId" => String,
            "fields" => [
              {
                "key" => String,
                "refValue" => Fog::Nullable::String,
                "stringValue" => Fog::Nullable::String,
              }
            ]
          }
        ]
      }

      PUT_PIPELINE_DEFINITION = {
        "errored" => Fog::Boolean,
        "validationErrors" => Fog::Nullable::Array,
      }
	
    end
  end
end
