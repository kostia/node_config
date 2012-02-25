# NodeConfig

Simple "node" configuration solution for Rails applications.

## Prelude

"node" is a single machine, which your Rails application is running on.
So "node" configuration is the configuration for that specific machine. For example:

* Your development laptop is also a "node" and needs a local configuration for _development_.
* Your server is also a "node", but it needs a different configuration for _production_.

## Purpose

We need to maintain lots of configuration keys specific for a "node", like AWS access keys,
Google-Analytics keys and much more...

Also:

* We want all of this keys to be defined in a _single_ _file_
* We want all of this keys to be _loaded_ _automatically_ on Rails startup
* We want all of this keys to be available inside Rails application
* We want that a missing key results in a _descriptive_ _error_
* We want this keys to be loaded into a process, which doesn't load the whole application

This is what `NodeConfig` tries to simplify.

## Installation

```ruby
# Gemfile
gem("node_config")
```

```bash
$ bundle install # Install the gem
$ rails generate node_config # Generate configuration files
```

## Usage

Put your node configuration into generated `RAILS_ROOT/config/node_config.yml`.


### Within a loaded Rails application

Your node configuration is available in Rails application config.
This is done by the generated initializer `config/initializers/node_config.rb`.

```yaml
# config/node_config.yml
foo:
  bar: :baz
```

```ruby
# rails console
Rails.application.config.node_config.foo #=> {"bar" => :baz}
Rails.application.config.node_config.foo.bar #=> :baz
```

In a Rake task:

```ruby
# Rakefile
task :my_task do
  puts(Rails.application.config.node_config.foo.bar) #=> baz
end
```

### Using without loading Rails

Outside the Rails you can access the node configuration through the top
level module named as your Rails application:

```ruby
PetShop.node_config.foo.bar #=> :baz
```

This is done by loading the generated `RAILS_ROOT/config/node_config.rb`.

If you have a Rake task for which the node configuration should be available
_without_ loading whole Rails, use the generated shortcut task.

```ruby
# lib/tasks/my_task_which_doesnt_need_rails.rake
load File.expand_path("../node_config.rake", __FILE__)

task :my_task_which_doesnt_need_rails => :node_config do
  puts(PetShop.node_config.foo.bar) #=> baz
end
```

Or as command line in your `Procfile` (https://github.com/ddollar/foreman)
for a worker (https://github.com/defunkt/resque):

```ruby
# Rakefile
load File.expand_path("../lib/tasks/node_config.rake", __FILE__)
```

```
worker: bundle exec rake node_config resque:work
```

If you have a script for which the node configuration should be available
_without_ loading whole Rails, be aware that the process _has_ to be bundled.
Otherwise it may not find the gem.

For example in your backup script (https://github.com/meskyanichi/backup):

```ruby
# config/backup.rb
require File.expand_path("../node_config", __FILE__)

PetShop.node_config.foo.bar #=> :baz
```

Same when deploying with Capistrano (https://github.com/capistrano/capistrano):

```ruby
# config/deploy.rb
require File.expand_path("../node_config", __FILE__)

PetShop.node_config.foo.bar #=> :baz
```

Or even in an external Ruby script:

```ruby
# foo.rb
require "/srv/www/pet_shop/current/config/node_config"

PetShop.node_config.foo.bar #=> :baz
```

If you have a process, which isn't bundled, then require the gem manually:

```ruby
# foo.rb
require "rubygems"
require "node_config"

require "/srv/www/pet_shop/current/config/node_config"

PetShop.node_config.foo.bar #=> :baz
```

## Errors

Under the hood `NodeConfig` uses `HashWithStructAccess`,
so a missing key will result in appropriate `NoMethodError`
(see https://github.com/kostia/hash_with_struct_access for details).


## Using with Git

Of course you have instruct Git to ignore `config/node.yml`.

But it's a good practice to maintain a configuration template with the list of required keys,
for example in `config/node.yml.template`.
