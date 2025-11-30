function Enable-Proxy {
    $env:HTTP_PROXY = "http://127.0.0.1:3067"
    $env:HTTPS_PROXY = "http://127.0.0.1:3067"
    $env:NO_PROXY = "localhost,127.0.0.1,192.168.1.0/24"
    Get-ChildItem Env:HTTP_PROXY
    Get-ChildItem Env:HTTPS_PROXY
    Write-Host "Proxy enabled (http://127.0.0.1:3067)"
}

function Disable-Proxy {
    $env:HTTP_PROXY = ""
    $env:HTTPS_PROXY = ""
    Write-Host "Proxy disabled"
}

# 默认不启用代理
# Disable-Proxy
