{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.misc.git;
in {
  options.misc.git = {
    enable = mkEnableOption "git default config";

    username = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "git username";
    };

    email = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "git email";
    };

    editor = mkOption {
      type = types.nullOr types.str;
      default = "vi";
      description = "The default editor for git";
    };

    defaultBranch = mkOption {
      type = types.str;
      default = "master";
      description = "The default branch for git";
      example = "main";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.username;
      userEmail = cfg.email;

      extraConfig = {
        init.defaultBranch = cfg.defaultBranch;
        pull.rebase = true;
        core.editor = cfg.editor;
        push.autoSetupRemote = true;

        color = {
          ui = "auto";
          branch = "auto";
          diff = "auto";
          interactive = "auto";
          status = "auto";
        };

        commit.verbose = true;
        branch.autosetuprebase = "always";
        push.default = "simple";
        rebase = {
          autoSquash = true;
          autoStash = true;
        };
      };
    };
  };
}
