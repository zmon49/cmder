function Ensure-Exists ($path) {
    if (-not (Test-Path $path)) {
        Write-Error "Missing required $path! Ensure it is installed"
        exit 1
    }
    return $true > $null
}

function Ensure-Executable ($command) {
    try { Get-Command $command -ErrorAction Stop > $null }
    catch {
        if( ($command -eq "7z") -and (Ensure-Exists "$env:programfiles\7-zip\7z.exe") ){
            set-alias -Name "7z" -Value "$env:programfiles\7-zip\7z.exe" -Scope script
        } else {
            Write-Error "Missing $command! Ensure it is installed and on in the PATH"
            exit 1
        }
    }
}

function Delete-Existing ($path) {
    Write-Verbose "Remove $path"
    Remove-Item -Recurse -force $path -ErrorAction SilentlyContinue
}

function Extract-Archive ($source, $target) {
    Invoke-Expression "7z x -y -o$($target) $source"
    if ($lastexitcode -ne 0) {
        Write-Error "Extracting of $source failed"
    }
    Remove-Item $source
}

function Create-Archive ($source, $target, $params) {
    $command = "7z a -t7z -mmt=4 -mx9 -x@`"$source\packignore`" $params $target $source" 
    Write-Verbose "Running: $command"
    Invoke-Expression $command
    if ($lastexitcode -ne 0) {
        Write-Error "Compressing $source failed"
    }
}

# If directory contains only one child directory
# Flatten it instead
function Flatten-Directory ($name) {
    $child = (Get-Childitem $name)[0]
    Rename-Item $name -NewName "$($name)_moving"
    Move-Item -Path "$($name)_moving\$child" -Destination $name
    Remove-Item -Recurse "$($name)_moving"
}

function Digest-MD5 ($path) {
    return Invoke-Expression "md5sum $path"
}