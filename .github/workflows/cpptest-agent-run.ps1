# This script should run AI Agent for C/C++test Static Analysis with AI Autofix.
# It is intended to be executed by 'cpptest-autofix-github.yml' but can also be run manually.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Locate the C/C++test installation from cpptestcli on PATH (required by cpptest-analyze.ps1
# anyway), rather than assuming a fixed install path.
$cpptestRoot = Split-Path -Parent (Get-Command cpptestcli).Source
$mcpServerPath = Join-Path $cpptestRoot 'integration\mcp\cpptestmcp.exe'

# == Codex ==

# Register C/C++test MCP server
codex mcp add cpptest-std-mcp -- $mcpServerPath
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# Execute the prompt with Codex - be sure to adjust sandbox permissions as needed for your prompt
$promptPath = Join-Path $PSScriptRoot 'cpptest-agent-prompt.md'
codex exec -s danger-full-access --config allow_login_shell=false (Get-Content -Raw $promptPath)
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# == Copilot ==

# Register C/C++test MCP server
# copilot mcp get cpptest-std-mcp *> $null
# if ($LASTEXITCODE -ne 0) { copilot mcp add cpptest-std-mcp -- $mcpServerPath }

# Execute the prompt with Copilot - be sure to adjust sandbox permissions as needed for your prompt
# copilot --allow-all --no-ask-user -s -p (Get-Content -Raw $promptPath)
