# -*- encoding: utf-8 -*-

require File.expand_path("../lib/node_config/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name = "node_config"
  gem.version = NodeConfig::VERSION
  gem.description = %q{Simple "node" configuration solution for Rails applications}
  gem.summary = %q{
    Simple "node" configuration solution for Rails applications.

    We need to maintain lots of configuration keys specific for a "node", like AWS access keys,
    Google-Analytics keys and much more.

    This is what this gem tries to simplify.
  }
  gem.homepage = "https://github.com/kostia/node_config"
  gem.authors = ["Kostiantyn Kahanskyi"]
  gem.email = %w(kostiantyn.kahanskyi@googlemail.com)
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- test/*`.split("\n")
  gem.require_paths = %w(lib)
  gem.required_ruby_version = ">= 1.9.2"
  gem.add_dependency("hash_with_struct_access")
  gem.add_dependency("rails", ">= 3.2.1")
  gem.add_development_dependency("minitest")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("turn")
end
