require File.join(File.dirname(__FILE__), 'helper')

class RepoTest < MadroxTest
  def test_repo_exists
    assert !Madrox::Repo.new("foo").exist?
    assert  Madrox::Repo.new(
              File.join(File.dirname(__FILE__), "fixtures/simple.git")).exist?
  end
end