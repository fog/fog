#!/bin/sh

# for each service
grep -lr "< Fog::Service$" lib/fog | sed -e 's/lib\///' -e 's/.rb$//' |
  # trigger rubygem cost then benchmark the load time
  xargs -I{} ruby -Ilib -rbenchmark -e 'Gem::Specification._all; puts "{}: #{Benchmark.realtime{ require "{}" }}"'
