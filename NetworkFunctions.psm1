function Test-NetworkEndpoint {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Hostname,

        [Parameter(Mandatory=$true)]
        [int]$Port
    )

    $results = [PSCustomObject]@{
        Hostname     = $Hostname
        Port         = $Port
        PortOpen     = $false
        SSLValid     = $false
        Timestamp    = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        ErrorMessage = ""
    }

    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $connect = $tcpClient.BeginConnect($Hostname, $Port, $null, $null)
        $wait = $connect.AsyncWaitHandle.WaitOne(2000, $false)

        if ($wait -and $tcpClient.Connected) {
            $results.PortOpen = $true
            
            # Attempt SSL/TLS Handshake
            $stream = $tcpClient.GetStream()
            $sslStream = New-Object System.Net.Security.SslStream($stream, $false)
            $sslStream.AuthenticateAsClient($Hostname)
            $results.SSLValid = $sslStream.IsAuthenticated
            
            $sslStream.Close()
        } else {
            $results.ErrorMessage = "Connection timed out"
        }
        $tcpClient.Close()
    }
    catch {
        $results.ErrorMessage = $_.Exception.Message
    }

    return $results
}

function Get-SSHNegotiatedCipher {
    [CmdletBinding()]
    param (
        [string]$Hostname,
        [int]$Port = 22
    )

    try {
        # Capture verbose output, ignoring host key prompts
        $sshOutput = ssh -vv -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no -p $Port $Hostname 2>&1
        
        # Search for the lines where negotiation is finalized
        $kexMatch    = $sshOutput | Select-String "kex: host key algorithm: (.+)"
        $cipherMatch = $sshOutput | Select-String "kex: encryption algorithm: (.+)"

        # Fallback search if the output format differs
        if (-not $cipherMatch) {
            $cipherMatch = $sshOutput | Select-String "kex: client->server cipher: (.+)"
        }

        return @{
            Kex    = if ($kexMatch) { $kexMatch.Matches.Groups[1].Value.Trim() } else { "Unknown-KEX" }
            Cipher = if ($cipherMatch) { ($cipherMatch.Matches.Groups[1].Value -split " ")[0].Trim() } else { "Unknown-Cipher" }
        }
    }
    catch {
        return @{ Kex = "Error"; Cipher = "Error" }
    }
}