[CmdletBinding()]
param (
    [string]$asmVersion
)

Write-Host "Starting PatchAssemblyInfo"
Write-Host "asmVersion = $asmVersion"

$asmFiles = Get-ChildItem -Filter "*AssemblyInfo.cs" -Recurse

$asmFiles | % {
    Write-Host ("Patching file '{0}'" -f $_.FullName)

    $content = Get-Content $_.FullName

    $content = $content -replace '(Assembly.+?Version)\(".+"\)\]', ('$1("{0}")]' -f $asmVersion)

    Set-Content $_.FullName $content
}

Write-Host "Finished PatchAssemblyInfo"