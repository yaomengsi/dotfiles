# Start-Transcript -Path "D:\scripts\IPv6_Export.log" -Append

$ipv6 = (Get-NetIPAddress -AddressFamily IPv6 | Where-Object { 
    $_.IPAddress -match '^2409' -and $_.PrefixOrigin -eq "RouterAdvertisement"
}).IPAddress
Set-Content -Path "D:\scripts\ipv6.txt" -Value $ipv6


$ipv6 = (Get-NetIPAddress -AddressFamily IPv6 | Where-Object {
    $_.PrefixOrigin -eq "RouterAdvertisement" -and $_.SuffixOrigin -eq "Random"
}).IPAddress
Set-Content -Path "D:\scripts\ipv6.txt" -Value $ipv6

# Stop-Transcript

# 公网 ipv4
curl -4 ifconfig.co
# 公网 ipv6
curl -6 ifconfig.co
