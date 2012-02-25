require "./test/test_helper"

require "node_config"

describe NodeConfig do
  describe "#load_config" do
    before do
      @config_path = File.expand_path("../fixtures/node_config.yml", __FILE__)
    end

    it "should load and parse YAML file with given path" do
      node_config = NodeConfig.load_file(@config_path)
      node_config.must_equal({"foo" => {"bar" => :baz}})
    end

    it "should create a hash with struct access from loaded data" do
      node_config = NodeConfig.load_file(@config_path)
      node_config.must_be_kind_of(HashWithStructAccess)
      node_config.foo.bar.must_equal(:baz)
    end
  end
end
