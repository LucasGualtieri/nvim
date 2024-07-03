local home = os.getenv("HOME")
local jdtls_path = home .. '/.local/share/eclipse.jdt.ls/bin/jdtls'

local config = {
    cmd = {jdtls_path},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}

require('jdtls').start_or_attach(config)

