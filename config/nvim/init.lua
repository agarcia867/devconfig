-- [[ Leader keys ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Font configuration ]]
vim.g.have_nerd_font = true

-- [[ Options ]]
vim.opt.number = true
-- vim.opt.relativenumber = true

vim.opt.mouse = ""
vim.opt.showmode = false

-- Clipboard sync
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true
vim.opt.undofile = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Whitespace display (disabled)
-- vim.opt.list = true
-- vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

-- [[ Keymaps ]]
-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostics
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
end, { desc = "Toggle inline diagnostics" })

vim.keymap.set("n", "<leader>ts", function()
	vim.wo.spell = not vim.wo.spell
end, { desc = "Toggle spell check" })

-- Git Conflict resolution
vim.keymap.set("n", "<leader>co", "<Plug>(git-conflict-ours)", { desc = "Git Conflict [O]urs" })
vim.keymap.set("n", "<leader>ct", "<Plug>(git-conflict-theirs)", { desc = "Git Conflict [T]heirs" })
vim.keymap.set("n", "<leader>cb", "<Plug>(git-conflict-both)", { desc = "Git Conflict [B]oth" })
vim.keymap.set("n", "<leader>c0", "<Plug>(git-conflict-none)", { desc = "Git Conflict [0] None" })
vim.keymap.set("n", "[x", "<Plug>(git-conflict-prev-conflict)", { desc = "Git Conflict Previous Conflict" })
vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)", { desc = "Git Conflict Next Conflict" })

-- Terminal mode escape
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Arrow key training (disabled)
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Window movement (disabled - terminal compatibility issues)
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

vim.keymap.set("n", "q", "<Nop>")

-- [[ Autocommands ]]
-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Utility functions ]]
local function get_lsp_workspace_dir()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		return nil
	end

	local client = clients[1]
	local workspace_folders = client.workspace_folders

	if workspace_folders and #workspace_folders > 0 then
		return vim.uri_to_fname(workspace_folders[1].uri)
	end

	return client.config.root_dir
end

-- [[ Lazy.nvim setup ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
require("lazy").setup({
	-- Auto-detect indentation
	"tpope/vim-sleuth",

	-- [[ Git integration ]]
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- [[ Which-key ]]
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},
			spec = {
				{ "<leader>s", group = "Search" },
				{ "<leader>t", group = "Toggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
				{ "<leader>f", group = "File" },
				{ "<leader>b", group = "Buffer" },
				{ "<leader>g", group = "Git" },
				{ "<leader>c", group = "Code Actions/Git Conflict" },
			},
		},
	},

	-- [[ Telescope ]]
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable extensions
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- Keymaps
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	-- [[ LSP ]]
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "●",
							package_pending = "○",
							package_uninstalled = "○",
						},
					},
				},
			},
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- LSP keymaps
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					-- Version compatibility helper
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- Document highlighting
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- Inlay hints toggle
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic configuration
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- LSP servers configuration
			local servers = {
				pyrefly = {},
				dockerls = {},
				pylsp = {},
				ruff = {},
				neocmakelsp = {},
				bashls = {},
				clangd = {
					cmd = {
						"clangd",
						"--enable-config",
						"--clang-tidy",
						"--background-index",
						"--query-driver=/home/dev/.local/opt/petalinux/2022.2/sysroots/x86_64-petalinux-linux/usr/bin/aarch64-xilinx-linux/aarch64-xilinx-linux-gcc,/usr/bin/gcc/usr/bin/gcc",
					},
				},
				ginko_ls = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = { enable = false, url = "" },
							schemas = {
								["https://raw.githubusercontent.com/siemens/kas/refs/tags/4.8.2/kas/schema-kas.json"] = "/.config.yaml",
								["https://raw.githubusercontent.com/jesseduffield/lazygit/refs/heads/master/schema/config.json"] = "/lazygit/config.yml",
							},
						},
					},
				},
				bitbake_ls = {
					cmd = { vim.fn.stdpath("data") .. "/mason/bin/language-server-bitbake", "--stdio" },
					filetypes = { "bitbake" },
					single_file_support = false,
					root_markers = { ".git" },
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"shfmt",
				"shellcheck",
				"oelint-adv",
				"cmakelint",
			})

			-- Setup all LSP servers using vim.lsp.config
			for server_name, server_config in pairs(servers) do
				server_config.capabilities =
					vim.tbl_deep_extend("force", {}, capabilities, server_config.capabilities or {})
				vim.lsp.config(server_name, server_config)
			end

			-- Replace bitbake_ls with the actual Mason package name
			for i, name in ipairs(ensure_installed) do
				if name == "bitbake_ls" then
					ensure_installed[i] = "language-server-bitbake"
					break
				end
			end

			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
				auto_update = true,
				integrations = {
					["mason-lspconfig"] = true,
				},
			})
			require("mason-lspconfig").setup()

			-- local registry = require("mason-registry")
			--
			-- local installed = {}
			-- for _, pkg in ipairs(registry.get_all_packages()) do
			-- 	if pkg:is_installed() then
			-- 		table.insert(installed, pkg.name)
			-- 	end
			-- end

			-- print(vim.inspect(installed))

			-- Ensure bitbake LSP starts automatically
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "bitbake",
				callback = function(ev)
					vim.lsp.start({
						name = "bitbake_ls",
						cmd = { vim.fn.stdpath("data") .. "/mason/bin/language-server-bitbake", "--stdio" },
						root_dir = vim.fs.dirname(vim.fs.find(".git", { path = ev.file, upward = true })[1]),
						capabilities = capabilities,
					})
				end,
			})
		end,
	},

	-- [[ Formatting ]]
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>F",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				xml = { "prettier" },
				bitbake = { "oelint_adv" },
			},
			formatters = {
				prettier = {
					env = {
						NODE_PATH = vim.fn.system("npm root -g"):gsub("\n", ""),
					},
					prepend_args = {
						"--plugin=/home/dev/.local/share/fnm/node-versions/v22.11.0/installation/lib/node_modules/@prettier/plugin-xml/src/plugin.js",
						"--config",
						"/home/dev/.prettierrc",
					},
				},
				oelint_adv = {
					command = vim.fn.stdpath("data") .. "/mason/bin/oelint-adv",
					args = { "--fix", "--nobackup", "$FILENAME" },
					stdin = false,
				},
			},
		},
	},

	-- [[ Linting ]]
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			-- Custom oelint-adv linter
			lint.linters.oelint_adv = {
				name = "oelint-adv",
				cmd = vim.fn.stdpath("data") .. "/mason/bin/oelint-adv",
				stdin = false,
				args = { "--quiet", "--mode", "all", "--messageformat", "{path}:{line}:{severity}:{msg}" },
				stream = "stderr",
				ignore_exitcode = true,
				parser = function(output, bufnr, cwd)
					local diagnostics = {}
					local severities = {
						error = vim.diagnostic.severity.ERROR,
						warning = vim.diagnostic.severity.WARN,
						info = vim.diagnostic.severity.INFO,
					}

					for line in output:gmatch("[^\r\n]+") do
						local file, line_nr, severity, message = line:match("([^:]+):(%d+):([^:]+):(.+)")
						if file and line_nr and severity and message then
							table.insert(diagnostics, {
								lnum = tonumber(line_nr) - 1,
								col = 0,
								end_lnum = tonumber(line_nr) - 1,
								end_col = -1,
								severity = severities[severity] or vim.diagnostic.severity.INFO,
								message = message,
								source = "oelint-adv",
							})
						end
					end
					return diagnostics
				end,
			}

			lint.linters_by_ft = {
				bitbake = { "oelint_adv" },
				cmake = { "cmakelint" },
			}

			-- Auto-lint on events
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					local ft = vim.bo.filetype
					if ft == "bitbake" or ft == "cmake" then
						lint.try_lint()
					end
				end,
			})
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			preset = "obsidian",
			render_modes = { "n", "c", "v" },
			heading = {
				enabled = true,
				icons = {},
				position = "inline",
				width = "block",
			},
			bullet = {
				enabled = true,
				icons = { "•", "•", "•", "•" },
			},
		},
	},

	-- [[ Autocompletion ]]
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			"mikavilpas/blink-ripgrep.nvim",
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
				config = function()
					require("luasnip").setup({})
					require("luasnip").filetype_extend("c", { "cpp", "cdoc" })
					require("luasnip").filetype_extend("cmake", {})
					require("luasnip").filetype_extend("cpp", { "c", "cppdoc" })
					require("luasnip").filetype_extend("lua", { "luadoc" })
					require("luasnip").filetype_extend("python", { "pydoc" })
					require("luasnip").filetype_extend("ruby", { "rdoc" })
					require("luasnip").filetype_extend("sh", { "bash", "shelldoc" })
				end,
			},
			"folke/lazydev.nvim",
		},
		opts = {
			keymap = {
				preset = "default",
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},
			sources = {
				default = { "lsp", "path", "snippets", "lazydev", "buffer", "ripgrep" },
				providers = {
					lsp = { score_offset = 1000 },
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
					ripgrep = {
						module = "blink-ripgrep",
						name = "Ripgrep",
						score_offset = -1,
						opts = {},
					},
				},
			},
			snippets = { preset = "luasnip" },
			fuzzy = {
				implementation = "prefer_rust_with_warning",
				sorts = {
					"score",
					"sort_text",
				},
			},
			signature = { enabled = true },
		},
	},

	-- [[ Themes ]]
	{
		"EdenEast/nightfox.nvim",
		priority = 1000,
		config = function()
			require("nightfox").setup({
				options = {
					transparent = false,
					styles = {
						comments = "italic",
					},
				},
			})
			vim.cmd.colorscheme("duskfox")
		end,
	},

	-- [[ UI Components ]]
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "duskfox",
					component_separators = "",
					section_separators = { left = "", right = "" },
				},
			})
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		lazy = false,
		cmd = "Neotree",
		keys = {
			{
				"<leader>fe",
				function()
					require("neo-tree.command").execute({
						toggle = true,
						dir = get_lsp_workspace_dir(),
						position = "right",
					})
				end,
				desc = "Explorer NeoTree (Root Dir)",
			},
			{
				"<leader>fE",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd(), position = "right" })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
			{ "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
			{ "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
			{
				"<leader>ge",
				function()
					require("neo-tree.command").execute({
						source = "git_status",
						toggle = true,
						position = "float",
					})
				end,
				desc = "Git Explorer",
			},
			{
				"<leader>be",
				function()
					require("neo-tree.command").execute({ source = "buffers", toggle = true, position = "float" })
				end,
				desc = "Buffer Explorer",
			},
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		opts = {},
	},

	-- [[ Additional Plugins ]]
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"johmsalas/text-case.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("textcase").setup({})
			require("telescope").load_extension("textcase")
		end,
		keys = {
			"ga",
			{ "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
		},
		cmd = {
			"Subs",
			"TextCaseOpenTelescope",
			"TextCaseOpenTelescopeQuickChange",
			"TextCaseOpenTelescopeLSPChange",
			"TextCaseStartReplacingCommand",
		},
		lazy = false,
	},
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		event = "LspAttach",
		config = function()
			require("tiny-code-action").setup({})
		end,
		keys = {
			{
				"<leader>ca",
				function()
					require("tiny-code-action").code_action({})
				end,
				mode = { "n" },
				desc = "Trigger Tiny Code Action",
			},
		},
	},
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = function()
			require("git-conflict").setup({
				default_mappings = false,
				default_commands = true,
			})
		end,
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			-- Text objects
			require("mini.ai").setup({ n_lines = 500 })
			-- Surround actions
			require("mini.surround").setup()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
	},
	{
		"saxon1964/neovim-tips",
		version = "*",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"MeanderingProgrammer/render-markdown.nvim",
		},
		opts = {
			daily_tip = 1,
		},
		init = function()
			local map = vim.keymap.set
			map("n", "<leader>nto", ":NeovimTips<CR>", { desc = "Neovim tips", noremap = true, silent = true })
			map(
				"n",
				"<leader>nte",
				":NeovimTipsEdit<CR>",
				{ desc = "Edit your Neovim tips", noremap = true, silent = true }
			)
			map(
				"n",
				"<leader>nta",
				":NeovimTipsAdd<CR>",
				{ desc = "Add your Neovim tip", noremap = true, silent = true }
			)
			map(
				"n",
				"<leader>nth",
				":help neovim-tips<CR>",
				{ desc = "Neovim tips help", noremap = true, silent = true }
			)
			map(
				"n",
				"<leader>ntr",
				":NeovimTipsRandom<CR>",
				{ desc = "Show random tip", noremap = true, silent = true }
			)
			map(
				"n",
				"<leader>ntp",
				":NeovimTipsPdf<CR>",
				{ desc = "Open Neovim tips PDF", noremap = true, silent = true }
			)
		end,
	},
	{
		"Bekaboo/dropbar.nvim",
		-- optional, but required for fuzzy finder support
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		config = function()
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},

	-- [[ Extension points ]]
	-- Additional plugins can be added here
	-- { import = 'custom.plugins' },
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- vim: ts=2 sts=2 sw=2 et
