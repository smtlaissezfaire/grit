module Grit
  class Reset
    class InvalidMode < StandardError; end

    VALID_MODES = [
      "mixed",
      "hard",
      "soft",
      "merge"
    ]

    DEFAULT_MODE = "mixed"
    DEFAULT_REF  = "HEAD"

    def self.reset(repo, mode, ref)
      new(repo).reset(mode, ref)
    end

    def initialize(repo)
      @repo = repo
    end

    def reset(mode = DEFAULT_MODE, ref = DEFAULT_REF)
      check_mode(mode)
      @repo.git.reset({}, "--#{mode}", ref)
    end

  private

    def check_mode(mode)
      unless VALID_MODES.include?(mode)
        raise InvalidMode, "mode must be one of #{VALID_MODES.join(", ")}"
      end
    end
  end
end