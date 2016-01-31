[CmdletBinding()]
param (
	[string]$onlyGlobal,
    [string]$asmVersion,
	[string]$asmFileVersion
)

function Patch-File {
	param ($file)

	Write-Host ("Patching file '{0}'" -f $file.FullName)

	$content = Get-Content $file

	if ($asmVersion) {
		$content = $content -replace '(AssemblyVersion)\(".+"\)\]', ('$1("{0}")]' -f $asmVersion)
	}

	if ($asmFileVersion) {
		$content = $content -replace '(AssemblyFileVersion)\(".+"\)\]', ('$1("{0}")]' -f $asmFileVersion)
	}

	Set-Content $file $content
}


#
# Script
#
$ErrorActionPreference = "Stop"
Write-Host "Starting PatchAssemblyInfo"

$filter = "*AssemblyInfo.cs"
if ([bool]::Parse($onlyGlobal) -eq $true) {
	$filter = "GlobalAssemblyInfo.cs"
}

Get-ChildItem -Filter $filter -Recurse | % {
	Patch-File $_
}

Write-Host "Finished PatchAssemblyInfo"