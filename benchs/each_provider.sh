#!/bin/sh

# for each provider
grep -lr "< Fog::Service$" lib/fog | xargs -L1 dirname | sort | uniq | sed -e 's/lib\///' |
  # trigger rubygem cost then benchmark the load time
  xargs -I{} ruby -Ilib -rbenchmark -e 'Gem::Specification._all; puts "{}: #{Benchmark.realtime{require "{}" }}"'
