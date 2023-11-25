{ lib, ... }: {
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$all"
        "$fill"
        "$time"
        "$line_break"
        "$cmd_duration"
        "$character"
      ];
      add_newline = false;
      time = {
        disabled = false;
        format = "[$time]($style) ";
        time_format = "%v %R";
      };
      cmd_duration.format = "[$duration]($style) ";
      directory.truncation_length = 8;
      # Symbols
      git_branch.symbol = " ";
      git_status = {
        ahead = "";
        behind = "";
      };

      c.symbol = " ";
      docker_context.symbol = " ";
      golang.symbol = " ";
      memory_usage.symbol = " ";
      python.symbol = " ";
      rust.symbol = " ";
      nix_shell.symbol = " ";

      fill.symbol = " ";
      # Disabled
      package.disabled = true;
    };
};
}
