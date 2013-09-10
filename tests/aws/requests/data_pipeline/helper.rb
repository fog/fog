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

      QUERY_OBJECTS = {
        "hasMoreResults" => Fog::Nullable::Boolean,
        "marker" => Fog::Nullable::String,
        "ids" => Fog::Nullable::Array,
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

      GET_PIPELINE_DEFINITION = {
        "pipelineObjects" => [
          {
            "id" => String,
            "name" => String,
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

    end
  end
end
