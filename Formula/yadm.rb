class Yadm < Formula
  desc "Yet Another Dotfiles Manager"
  homepage "https://yadm.io/"
  url "https://github.com/TheLocehiliosan/yadm/archive/2.3.0.tar.gz"
  sha256 "421c357a240b5ac4e6b971bb2d33414e9551a337993116bf0ea4f411952aab87"

  bottle :unneeded

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "completion/yadm.bash_completion"
    zsh_completion.install  "completion/yadm.zsh_completion" => "_yadm"
  end

  test do
    system bin/"yadm", "init"
    assert_predicate testpath/".config/yadm/repo.git/config", :exist?, "Failed to init repository."
    assert_match testpath.to_s, shell_output("#{bin}/yadm gitconfig core.worktree")

    # disable auto-alt
    system bin/"yadm", "config", "yadm.auto-alt", "false"
    assert_match "false", shell_output("#{bin}/yadm config yadm.auto-alt")

    (testpath/"testfile").write "test"
    system bin/"yadm", "add", "#{testpath}/testfile"

    system bin/"yadm", "gitconfig", "user.email", "test@test.org"
    system bin/"yadm", "gitconfig", "user.name", "Test User"

    system bin/"yadm", "commit", "-m", "test commit"
    assert_match "test commit", shell_output("#{bin}/yadm log --pretty=oneline 2>&1")
  end
end
