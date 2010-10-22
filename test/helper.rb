require 'test/unit'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'madrox'

class MadroxTest < Test::Unit::TestCase
  def fork_git_fixture(name, dest = :test)
    old_path = File.join(File.dirname(__FILE__), "fixtures/#{name}.git")
    new_path = File.join(File.dirname(__FILE__), "#{dest}.git")
    repo = Grit::Repo.new(old_path).fork_bare(new_path)
    Madrox::Repo.new(repo.path)
  end

  def clear_git_fixtures(*fixtures)
    (fixtures << :test).each do |name|
      FileUtils.rm_rf File.join(File.dirname(__FILE__), "#{name}.git")
    end
  end

  def default_test
  end
end