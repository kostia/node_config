require "./test/test_helper"

require "generators/node_config_generator"

module PetShop
  class Application
    def self.config
    end
  end
end

class NodeConfigGeneratorTest < Rails::Generators::TestCase
  tests(NodeConfigGenerator)
  destination("/tmp")
  setup(:prepare_destination)

  # Stub application module
  def Rails.application
    ::PetShop::Application.new
  end

  test "should create YAML config file" do
    run_generator
    assert_file("config/node_config.yml")
  end

  test "should create rakefile" do
    run_generator
    assert_file("lib/tasks/node_config.rake") do |rakefile|
      rakefile.squeeze(" ").must_equal(%Q{task :node_config do
  load File.expand_path("../../../config/node_config.rb", __FILE__)
end}.squeeze(" "))
    end
  end

  test "should generate loader" do
    run_generator
    assert_file("config/node_config.rb") do |loader|
      loader.must_match(/^require "node_config"/)
      eval(loader)
      Proc.new { PetShop.node_config }.must_raise(Errno::ENOENT)
    end
  end

  test "should generate initializer" do
    run_generator
    assert_file("config/initializers/node_config.rb") do |initializer|
      Proc.new { eval(initializer) }.must_raise(Errno::ENOENT)
    end
  end
end
