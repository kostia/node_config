require "hash_with_struct_access"
require "yaml"

module NodeConfig
  def self.load_file(path)
    HashWithStructAccess.new(YAML.load_file(path))
  end
end
