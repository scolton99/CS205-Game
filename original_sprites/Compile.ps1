$iviewpath = "C:\Program Files\IrfanView"
$dir = $PSScriptRoot + "\bmp"

$files = Get-ChildItem $dir -Filter *.bmp | ForEach-Object {
    Write-Host "Converting bmp\$_ to PPM..."

    $cmd = "$iviewpath\i_view64.exe"

    $arg1 = "$dir\$_"
    $arg2 = "/convert=$PSScriptRoot\ppm\$($_.BaseName).ppm"
    $arg3 = "/bpp=8"
    
    Start-Process -FilePath $cmd -ArgumentList $arg1,$arg2,$arg3 -NoNewWindow -Wait
    Write-Host "Saved bmp\$_ as ppm\$($_.BaseName).ppm"

    Write-Host "Converting ppm\$($_.BaseName).ppm to ASM..."

    $cmd2 = "$PSScriptRoot\ppm2asm.exe"
    $arg2_1 = "$PSScriptRoot\ppm\$($_.BaseName).ppm"
    $arg2_2 = "$PSScriptRoot\asm\$($_.BaseName).asm"

    $rep = ("$arg2_2" -split "\\")[0]

    & $cmd2 $arg2_1 $arg2_2
    Write-Host "Saved ppm\$($_.BaseName).ppm as asm\$($_.BaseName).asm"

    Write-Host "Modifying ASM for compatibility..."
    $old = Get-Content $arg2_2 -Raw

    $old_r = $old -replace $rep,$_.BaseName
    

    $header = @'
.586
.MODEL FLAT,STDCALL
.STACK 4096
option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc
include game.inc

.DATA


'@

    $footer = "END"

    $full = "$header $old_r $footer"

    Set-Content -Path $arg2_2 -Value $full
    Copy-Item -Path $arg2_2 -Destination "$PSScriptRoot\..\$($_.BaseName).asm"
}
