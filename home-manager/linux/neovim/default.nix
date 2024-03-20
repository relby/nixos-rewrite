{ pkgs, ... }: {
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins =
      let
        toLua = str: "lua << EOF\n${str}\nEOF\n";
        toLuaFile = filePath: "lua << EOF\n${builtins.readFile filePath}\nEOF\n";
      in
      with pkgs.vimPlugins; [
        # Colorschemas
        tokyonight-nvim
        catppuccin-nvim
        # Development
        neo-tree-nvim
        (nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-vim
            p.tree-sitter-lua
            p.tree-sitter-python
            p.tree-sitter-rust
            p.tree-sitter-javascript
            p.tree-sitter-typescript
            p.tree-sitter-go
            p.tree-sitter-c
            p.tree-sitter-cpp
          ])
        )
        nvim-treesitter-context
        telescope-nvim
        telescope-ui-select-nvim
        telescope-file-browser-nvim
        zen-mode-nvim
        comment-nvim
        toggleterm-nvim
        # LSP
        nvim-lspconfig
        rust-tools-nvim
        # Completion
        nvim-cmp
        cmp-buffer
        cmp-path
        cmp-nvim-lua
        cmp-nvim-lsp
        cmp_luasnip
        lspkind-nvim
        cmp-tabnine
        luasnip
        # UI
        lualine-nvim
        nvim-web-devicons
        gitsigns-nvim
        fidget-nvim
        undotree
        # Additional stuff
        plenary-nvim
        nui-nvim
      ];

    extraPackages = with pkgs; [
      # General
      wl-clipboard
      # Essential
      tree-sitter
      nodejs
      # Telescope
      ripgrep
      fd
      # Language servers
      rnix-lsp
      pyright
      nodePackages.typescript-language-server
      rust-analyzer
      gopls
    ];
  };

  xdg.configFile.nvim = {
    source = ./nvim;
    recursive = true;
  };
}
