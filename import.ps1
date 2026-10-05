# Načtení uživatelských jmen ze souboru (ignoruje prázdné řádky)
$usernames = Get-Content -Path "d:\a.txt" |
    Where-Object { $_.Trim() -ne "" } |
    ForEach-Object { $_.Trim() }

$batchSize   = 5
$maxTotal    = 1000   # tvrdý limit pro testování
$total       = [Math]::Min($usernames.Count, $maxTotal)

Write-Host "Celkem jmen v souboru: $($usernames.Count), otevřu max: $total" -ForegroundColor Cyan

for ($i = 0; $i -lt $total; $i += $batchSize) {
    $end   = [Math]::Min($i + $batchSize - 1, $total - 1)
    $batch = $usernames[$i..$end]

    Write-Host "`nOtevírám dávku $([Math]::Floor($i / $batchSize) + 1) / $([Math]::Ceiling($total / $batchSize))  (jmena $($i+1)-$($end+1))" -ForegroundColor Cyan

    foreach ($user in $batch) {
        $url = "https://www.x.com/$user"
        Write-Host "  -> $url"
        Start-Process $url
    }

    # Pokud existuje další dávka, čekej na Enter
    if (($i + $batchSize) -lt $total) {
        Write-Host "Stiskni ENTER pro pokracovani (nebo Ctrl+C pro ukonceni)..." -ForegroundColor Yellow
        Read-Host | Out-Null
    }
}

Write-Host "`nHotovo. Otevreno $total odkazu." -ForegroundColor Green
