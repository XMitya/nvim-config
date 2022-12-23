-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  require('jdtls').setup_dap({ hotcodereplace = 'auto' })

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  -- ACTION mappings
  --buf_set_keymap('n', '<leader>la', "<Cmd>lua require'jdtls'.code_action()<CR>", opts)
  --buf_set_keymap('v', '<leader>la', "<Esc><Cmd>lua require'jdtls'.code_action(true)<CR>", opts)
  --buf_set_keymap('n', '<leader>lA', "<Cmd>lua require'jdtls'.code_action(false, 'refactor')<CR>", opts)
  --buf_set_keymap('n', '<leader>lR',  '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- Few language severs support these three
  --buf_set_keymap('n', '<leader>fF',  '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  -- Diagnostics mapping
  buf_set_keymap('n', '<leader>ll', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  -- buf_set_keymap('n', '<leader>ln', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- buf_set_keymap('n', '<leader>lN', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)

  buf_set_keymap("n", "<leader>uo", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
  buf_set_keymap("n", "<leader>ut", "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
  buf_set_keymap("n", "<leader>uT", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
  buf_set_keymap("v", "<leader>ue", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
  buf_set_keymap("n", "<leader>ue", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
  buf_set_keymap("v", "<leader>um", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
  buf_set_keymap("n", "<leader>uu", "<Esc><Cmd>lua require('jdtls').super_implementation()<CR>", opts)
  buf_set_keymap("n", "<leader>ur", "<Esc><Cmd>lua require('jdtls').update_project_config()<CR>", opts)
  --[[
  require "lsp_signature".on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      floating_window = true,
      floating_window_above_cur_line = true,
      floating_window_off_x = 20,
      doc_lines = 10,
      hint_prefix = '👻 '
    }, bufnr)  -- Note: add in lsp client on-attach
  --]]
end

-- This bundles definition is the same as in the previous section (java-debug installation)
local bundles = {
  vim.fn.glob("/Users/dkarachentsev/work/pub_repos/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1),
};

-- This is the new part
vim.list_extend(bundles, vim.split(vim.fn.glob("/Users/dkarachentsev/work/pub_repos/vscode-java-test/server/*.jar", 1), "\n"))

-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

--local workspace_dir = '/Users/dkarachentsev/work/repos/' .. project_name
local workspace_dir = '/Users/dkarachentsev/work/repos/workspace'
--                                               ^^
--                                               string concattenation in Lua
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  on_attach = on_attach,
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    '/Users/dkarachentsev/apps/jdk-17.jdk.rc1/Contents/Home/bin/java', -- or '/path/to/java17_or_newer/bin/java'
            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '-javaagent:/Users/dkarachentsev/.config/nvim/dependencies/lombok.jar',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    '-jar', '/Users/dkarachentsev/language_servers/jdt-language-server-1.9.0-202203031534/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
         -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
         -- Must point to the                                                     Change this to
         -- eclipse.jdt.ls installation                                           the actual version


    -- 💀
    '-configuration', '/Users/dkarachentsev/language_servers/jdt-language-server-1.9.0-202203031534/config_mac',
                    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                    -- Must point to the                      Change to one of `linux`, `win` or `mac`
                    -- eclipse.jdt.ls installation            Depending on your system.


    -- 💀
    -- See `data directory configuration` section in the README
    '-data', workspace_dir
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = bundles
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
