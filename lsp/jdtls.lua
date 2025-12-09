local home = os.getenv("HOME")
local lombok = home .. "/Binaries/lombok/lombok.jar"

---@type vim.lsp.Config
return {
	cmd = {
		"java",
		"-javaagent:" .. lombok,
		"-Xbootclasspath/a:" .. lombok,
		"-jar",
		vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		home .. "/.local/share/nvim/mason/packages/jdtls/config_mac",
		"-data",
		home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
	},
	filetypes = { "java" },
	root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
}
