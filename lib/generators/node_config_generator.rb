require "rails/generators"

class NodeConfigGenerator < Rails::Generators::Base
  desc("Install NodeConfig")
  source_root(File.expand_path("../templates", __FILE__))

  def generate_initializer
    @both_app_modules = Rails.application.class.name
    template("config/initializers/node_config.rb.erb", "config/initializers/node_config.rb")
  end

  def generate_loader
    @top_level_app_module = Rails.application.class.name.split("::").first
    template("config/node_config.rb.erb", "config/node_config.rb")
  end

  def create_rakefile
    rakefile("node_config.rake") do
      %Q{task :node_config do
  require File.expand_path("../../../config/node_config", __FILE__)
end}
    end
  end

  def create_configuration
    create_file("config/node_config.yml")
  end
end
