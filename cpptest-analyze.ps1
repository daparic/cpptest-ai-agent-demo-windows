# This script should run the C/C++test static analysis with additional build and verification steps.
# It should be located in the root of the project. It is intended to be executed by C/C++test skills.
#
# Adjust the build and analysis steps as needed for your project.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-Step {
    param([Parameter(Mandatory)][ScriptBlock]$Command)
    & $Command
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

# == Makefile project ==

# Build
Invoke-Step { cpptesttrace mingw32-make clean all }

# Analyze
Invoke-Step { cpptestcli -quiet -compiler gcc_9-64 -config "builtin://Recommended Rules" -module . -input cpptestscan.bdf }

# == CMake project ==

# Configure
# Invoke-Step { cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -S . -B .build }

# Build
# Invoke-Step { cmake --build .build }

# Analyze
# Invoke-Step { cpptestcli -quiet -compiler gcc_9-64 -config "builtin://Recommended Rules" -module . -input .build/compile_commands.json }
