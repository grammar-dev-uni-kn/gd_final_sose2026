# Windows equivalent of the macOS setup.sh 

$ErrorActionPreference = "Stop"
$XleDir = $PSScriptRoot

# Locate XLE
$XleExe = Get-ChildItem -Path $XleDir -Filter "*xle*.exe" -File -ErrorAction SilentlyContinue |
    Select-Object -First 1
if (-not $XleExe) {
    Write-Error "No *.exe matching 'xle' found in $XleDir. Place this script next to your XLE binary, or set `$XleExe by hand and re-run the rest of this script."
    exit 1
}

# Locate  Tcl/Tk
$TclDir = Get-ChildItem -Path $XleDir -Directory -Filter "tcl8*" -ErrorAction SilentlyContinue | Select-Object -First 1
$TkDir  = Get-ChildItem -Path $XleDir -Directory -Filter "tk8*"  -ErrorAction SilentlyContinue | Select-Object -First 1

# Environment variables for the current user
[Environment]::SetEnvironmentVariable("XLEPATH", $XleDir, "User")

$CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($CurrentPath -notlike "*$XleDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$XleDir;$CurrentPath", "User")
}
if ($TclDir) {
    [Environment]::SetEnvironmentVariable("TCL_LIBRARY", $TclDir.FullName, "User")
}
if ($TkDir) {
    [Environment]::SetEnvironmentVariable("TK_LIBRARY", $TkDir.FullName, "User")
}

# Thai script
$ProfilePath = $PROFILE.CurrentUserAllHosts
$ChcpLine = "chcp 65001 > `$null  # UTF-8 console, for Thai output (added by setup.ps1)"
if (-not (Test-Path $ProfilePath)) {
    New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
}
if (-not (Select-String -Path $ProfilePath -Pattern "added by setup.ps1" -Quiet -ErrorAction SilentlyContinue)) {
    Add-Content -Path $ProfilePath -Value "`n$ChcpLine"
}

Write-Host "XLE configured:"
Write-Host "  XLEPATH      = $XleDir"
Write-Host "  Executable   = $($XleExe.Name)"
if ($TclDir) { Write-Host "  TCL_LIBRARY  = $($TclDir.FullName)" } else { Write-Host "  TCL_LIBRARY  = (none found -- ensure Tcl/Tk is otherwise on PATH)" }
if ($TkDir)  { Write-Host "  TK_LIBRARY   = $($TkDir.FullName)" }  else { Write-Host "  TK_LIBRARY   = (none found -- ensure Tcl/Tk is otherwise on PATH)" }
Write-Host ""
Write-Host "Open a NEW PowerShell window (environment variables apply to future sessions), then:"
Write-Host "  cd 'path\to\Thai\Auxiliary Stacking'"
Write-Host "  & `"$XleDir\$($XleExe.Name)`""
Write-Host "  create-parser thai_grammar.lfg"
Write-Host "  parse `"เขาควรทำ`""
Write-Host ""
Write-Host "pythainlp is still required (Report.pdf Section 2): pip install pythainlp"
