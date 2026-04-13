-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    terminal = {
      enabled = true,
      win = {
        keys = {
          -- nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
          -- nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
          -- nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
          -- nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
          -- hide_slash = { "<C-/>", "hide", desc = "Hide Terminal", mode = "t" },
          -- hide_underscore = { "<c-_>", "hide", desc = "which_key_ignore", mode = "t" },
        },
      },
    },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      }
    }
  },
  keys = {
    { "<c-/>",      function() require("snacks").terminal() end, desc = "Toggle Terminal"},
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          require("snacks").debug.inspect(...)
        end
        _G.bt = function()
          require("snacks").debug.backtrace()
        end

          -- Override print to use snacks for `:=` command
          if vim.fn.has("nvim-0.11") == 1 then
            vim._print = function(_, ...)
              dd(...)
            end
          else
            vim.print = _G.dd 
          end

          -- Create some toggle mappings
          require("snacks").toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          require("snacks").toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          require("snacks").toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          require("snacks").toggle.diagnostics():map("<leader>ud")
          require("snacks").toggle.line_number():map("<leader>ul")
          require("snacks").toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          require("snacks").toggle.treesitter():map("<leader>uT")
          require("snacks").toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          require("snacks").toggle.inlay_hints():map("<leader>uh")
          require("snacks").toggle.indent():map("<leader>ug")
          require("snacks").toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
  { -- further customize the options set by the community
    "catppuccin",
    opts = {
      integrations = {
        sandwich = false,
        noice = true,
        mini = true,
        leap = true,
        markdown = true,
        neotest = true,
        cmp = true,
        overseer = true,
        lsp_trouble = true,
        rainbow_delimiters = true,
      },
    },
  },
  {
    "alexpasmantier/tv.nvim",
    config = function()
      -- built-in niceties
      local h = require("tv").handlers

      require("tv").setup({
        -- global window appearance (can be overridden per channel)
        window = {
          width = 0.8, -- 80% of editor width
          height = 0.8, -- 80% of editor height
          border = "none",
          title = " tv.nvim ",
          title_pos = "center",
        },
        -- per-channel configurations
        channels = {
          -- `files`: fuzzy find files in your project
          files = {
            keybinding = "<leader>ff", -- Launch the files channel
            -- what happens when you press a key
            handlers = {
              ["<CR>"] = h.open_as_files, -- default: open selected files
              ["<C-q>"] = h.send_to_quickfix, -- send to quickfix list
              ["<C-s>"] = h.open_in_split, -- open in horizontal split
              ["<C-v>"] = h.open_in_vsplit, -- open in vertical split
              ["<C-y>"] = h.copy_to_clipboard, -- copy paths to clipboard
            },
          },

          -- `text`: ripgrep search through file contents
          text = {
            keybinding = "<leader>fw",
            handlers = {
              ["<CR>"] = h.open_at_line, -- Jump to line:col in file
              ["<C-q>"] = h.send_to_quickfix, -- Send matches to quickfix
              ["<C-s>"] = h.open_in_split, -- Open in horizontal split
              ["<C-v>"] = h.open_in_vsplit, -- Open in vertical split
              ["<C-y>"] = h.copy_to_clipboard, -- Copy matches to clipboard
            },
          },

          -- `git-log`: browse commit history
          ["git-log"] = {
            keybinding = "<leader>gl",
            handlers = {
              -- custom handler: show commit diff in scratch buffer
              ["<CR>"] = function(entries, config)
                if #entries > 0 then
                  vim.cmd("enew | setlocal buftype=nofile bufhidden=wipe")
                  vim.cmd("silent 0read !git show " .. vim.fn.shellescape(entries[1]))
                  vim.cmd("1delete _ | setlocal filetype=git nomodifiable")
                  vim.cmd("normal! gg")
                end
              end,
              -- copy commit hash to clipboard
              ["<C-y>"] = h.copy_to_clipboard,
            },
          },

          -- `git-branch`: browse git branches
          ["git-branch"] = {
            keybinding = "<leader>gb",
            handlers = {
              -- checkout branch using execute_shell_command helper
              -- {} is replaced with the selected entry
              ["<CR>"] = h.execute_shell_command("git checkout {}"),
              ["<C-y>"] = h.copy_to_clipboard,
            },
          },

          -- `docker-images`: browse images and run containers
          ["docker-images"] = {
            keybinding = "<leader>di",
            window = { title = " Docker Images " },
            handlers = {
              -- run a container with the selected image
              ["<CR>"] = function(entries, config)
                if #entries > 0 then
                  vim.ui.input({
                    prompt = "Container name: ",
                    default = "my-container",
                  }, function(name)
                      if name and name ~= "" then
                        local cmd = string.format("docker run -it --name %s %s", name, entries[1])
                        vim.cmd("!" .. cmd)
                      end
                    end)
                end
              end,
              -- copy image name
              ["<C-y>"] = h.copy_to_clipboard,
            },
          },

          -- `env`: search environment variables
          env = {
            keybinding = "<leader>ev",
            handlers = {
              ["<CR>"] = h.insert_at_cursor, -- Insert at cursor position
              ["<C-l>"] = h.insert_on_new_line, -- Insert on new line
              ["<C-y>"] = h.copy_to_clipboard,
            },
          },

          -- `aliases`: search shell aliases
          alias = {
            keybinding = "<leader>al",
            handlers = {
              ["<CR>"] = h.insert_at_cursor,
              ["<C-y>"] = h.copy_to_clipboard,
            },
          },
        },
        -- path to the tv binary (default: 'tv')
        tv_binary = "tv",
        global_keybindings = {
          channels = "<leader>tv", -- opens the channel selector
        },
        quickfix = {
          auto_open = true, -- automatically open quickfix window after populating
        },
      })
    end,
  },
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    cond = vim.g.neovide == nil,
    opts = {
      hide_target_hack = true,
      cursor_color = "none",
    },
    specs = {
      -- disable mini.animate cursor
      {
        "nvim-mini/mini.animate",
        optional = true,
        opts = {
          cursor = { enable = false },
        },
      },
    },
  },
  { "ldelossa/litee.nvim", lazy = true },
  {
    "ldelossa/gh.nvim",
    opts = {},
    config = function(_, opts)
      require("litee.lib").setup()
      require("litee.gh").setup(opts)
    end,
    keys = {
      { "<leader>G", "", desc = "+Github" },
      { "<leader>Gc", "", desc = "+Commits" },
      { "<leader>Gcc", "<cmd>GHCloseCommit<cr>", desc = "Close" },
      { "<leader>Gce", "<cmd>GHExpandCommit<cr>", desc = "Expand" },
      { "<leader>Gco", "<cmd>GHOpenToCommit<cr>", desc = "Open To" },
      { "<leader>Gcp", "<cmd>GHPopOutCommit<cr>", desc = "Pop Out" },
      { "<leader>Gcz", "<cmd>GHCollapseCommit<cr>", desc = "Collapse" },
      { "<leader>Gi", "", desc = "+Issues" },
      { "<leader>Gip", "<cmd>GHPreviewIssue<cr>", desc = "Preview" },
      { "<leader>Gio", "<cmd>GHOpenIssue<cr>", desc = "Open" },
      { "<leader>Gl", "", desc = "+Litee" },
      { "<leader>Glt", "<cmd>LTPanel<cr>", desc = "Toggle Panel" },
      { "<leader>Gp", "", desc = "+Pull Request" },
      { "<leader>Gpc", "<cmd>GHClosePR<cr>", desc = "Close" },
      { "<leader>Gpd", "<cmd>GHPRDetails<cr>", desc = "Details" },
      { "<leader>Gpe", "<cmd>GHExpandPR<cr>", desc = "Expand" },
      { "<leader>Gpo", "<cmd>GHOpenPR<cr>", desc = "Open" },
      { "<leader>Gpp", "<cmd>GHPopOutPR<cr>", desc = "PopOut" },
      { "<leader>Gpr", "<cmd>GHRefreshPR<cr>", desc = "Refresh" },
      { "<leader>Gpt", "<cmd>GHOpenToPR<cr>", desc = "Open To" },
      { "<leader>Gpz", "<cmd>GHCollapsePR<cr>", desc = "Collapse" },
      { "<leader>Gr", "", desc = "+Review" },
      { "<leader>Grb", "<cmd>GHStartReview<cr>", desc = "Begin" },
      { "<leader>Grc", "<cmd>GHCloseReview<cr>", desc = "Close" },
      { "<leader>Grd", "<cmd>GHDeleteReview<cr>", desc = "Delete" },
      { "<leader>Gre", "<cmd>GHExpandReview<cr>", desc = "Expand" },
      { "<leader>Grs", "<cmd>GHSubmitReview<cr>", desc = "Submit" },
      { "<leader>Grz", "<cmd>GHCollapseReview<cr>", desc = "Collapse" },
      { "<leader>Gt", "", desc = "+Threads" },
      { "<leader>Gtc", "<cmd>GHCreateThread<cr>", desc = "Create" },
      { "<leader>Gtn", "<cmd>GHNextThread<cr>", desc = "Next" },
      { "<leader>Gtt", "<cmd>GHToggleThread<cr>", desc = "Toggle" },
    },
  },
  {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      prompts = {
        generate_commit = "Generate commit with staged changes",
        create_branch_and_generate_commit = "Create branch and generate commit with staged changes",
        review_commit= "Can you review latest commit for any issues or improvements?"
        -- security = "Review {file} for security vulnerabilities",
        -- custom = function(ctx)
        --   return "Current file: " .. ctx.buf .. " at line " .. ctx.row
        -- end,
      },
      mux = {
        enabled = true,
        backend = "tmux", -- or "zellij"
      },
    },
  },
  -- stylua: ignore
  keys = {
    -- nes is also useful in normal mode
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    {
      "<c-.>",
      function() require("sidekick.cli").focus() end,
      desc = "Sidekick Focus",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select() end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").close() end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
  },
}
}
