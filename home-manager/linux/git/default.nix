{ ... }: {
  home = {
    # TODO: Maybe there is a better way to configure aliases? Research on that
    shellAliases = {
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gd = "git diff";
      gp = "git push";
      gl = "git log --oneline";
      gco = "git checkout";
    };
  };

  programs = {
    git = {
      enable = true;
      delta.enable = true;

      userName = "Nikita Kudinov";
      userEmail = "kudinov.nikita@gmail.com";
      ignores = [
        ".env"
        "*.py[cod]"
	"__pycache__/"
	"dist/"
	"build/"
        "node_modules/"
      ];
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
  };
}
