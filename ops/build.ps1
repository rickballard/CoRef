param([string[]]$Repos=@("rickballard/CoCache"))
$ErrorActionPreference="Stop"; Set-StrictMode -Version Latest
$agg=@()
foreach($r in $Repos){
  try{
    $raw = gh api repos/$r/contents/index/va_manifest.json?ref=main --jq ".download_url"
    if($raw){
      $json = Invoke-RestMethod $raw
      $json | % { $_ | Add-Member repo $r -Force; $agg += $_ }
    }
  } catch {}
}
($agg | ConvertTo-Json -Depth 8) | Set-Content -Encoding UTF8 "index.json"
Write-Host "Wrote index.json with $($agg.Count) records"
