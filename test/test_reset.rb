require File.dirname(__FILE__) + '/helper'

class ResetTest < Test::Unit::TestCase
  def setup
    setup_git_repo
    @repo = Git::Repo.new(@working_dir, :is_bare => true)
  end

  def teardown
    teardown_git_repo
  end

  def test_should_reset_hard_with_no_affect
    ref = @repo.commits.first.id

    @repo.reset "hard", "HEAD"
    assert_equal ref, @repo.commits.first.id
  end

  def test_should_reset_hard_with_current_ref_with_no_affect
    ref = @repo.commits.first.id

    @repo.reset "hard", ref
    assert_equal ref, @repo.commits.first.id
  end

  def test_should_reset_hard_with_ref_changing_head
    previous_ref = @repo.commits.last.id

    @repo.reset "hard", previous_ref
    assert_equal previous_ref, @repo.commits.first.id
  end

  def test_should_reset_hard_to_previous_revision_with_head_caret
    previous_ref = @repo.commits[1].id

    @repo.reset "hard", "HEAD^"
    assert_equal previous_ref, @repo.commits.first.id
  end

  def test_should_not_allow_invalid_mode
    assert_raise Reset::InvalidMode do
      @repo.reset "foo", "HEAD"
    end
  end

  def test_should_allow_mixed_mode
    assert_nothing_raised do
      @repo.reset "mixed", "HEAD"
    end
  end

  def test_should_allow_soft_mode
    assert_nothing_raised do
      @repo.reset "soft", "HEAD"
    end
  end

  def test_should_allow_merge_mode
    assert_nothing_raised do
      @repo.reset "merge", "HEAD"
    end
  end

  def test_should_pass_in_correct_mode_to_git_reset
    @repo.git.expects(:reset).with({}, "--soft", "HEAD")
    @repo.reset "soft", "HEAD"
  end

  def test_should_default_to_reset_head
    ref = @repo.commits.first.id

    @repo.reset "hard"
    assert_equal ref, @repo.commits.first.id
  end

  def test_should_default_to_reset_mixed
    @repo.git.expects(:reset).with({}, "--mixed", "HEAD")
    @repo.reset
  end

private

  def setup_git_repo
    @original_working_dir = Dir.getwd

    @current_path = File.expand_path(File.dirname(__FILE__))
    @prestine_dir = File.join(@current_path, "two_commit_repo")
    @working_dir  = File.join(@current_path, "tmp_git")

    FileUtils.cp_r(@prestine_dir, @working_dir)
    FileUtils.mv(File.join(@working_dir, "dot_git"), File.join(@working_dir, ".git"))

    Dir.chdir @working_dir
  end

  def teardown_git_repo
    Dir.chdir @original_working_dir
    FileUtils.rm_rf(@working_dir)
  end
end
