require File.expand_path('../helper', __FILE__)

class RepoTest < MadroxTest
  def test_repo_exists
    assert !Madrox::Repo.new("foo").exist?
    assert  Madrox::Repo.new(
              File.join(File.dirname(__FILE__), "fixtures/simple.git")).exist?
  end
end
