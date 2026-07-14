$Name=$env:VM_NAME

$Memory=$env:MEMORY

$CPU=$env:CPU

$Switch=$env:SWITCH

$Template=$env:TEMPLATE

$VHDLocation=$env:VHD_LOCATION

Write-Host "Creating VM $Name"

Copy-Item `
    "$Template\Base.vhdx" `
    "$VHDLocation\$Name.vhdx"

New-VM `
    -Name $Name `
    -Generation 2 `
    -MemoryStartupBytes (${Memory}MB) `
    -VHDPath "$VHDLocation\$Name.vhdx" `
    -SwitchName $Switch

Set-VMProcessor `
    -VMName $Name `
    -Count $CPU

Start-VM $Name
