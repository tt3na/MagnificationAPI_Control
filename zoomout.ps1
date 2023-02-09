$pipe = New-Object System.IO.Pipes.NamedPipeClientStream ".", "np", InOut
$pipe.Connect()
$buf = New-Object byte[] 1024

$wb = [System.Text.Encoding]::Unicode.GetBytes("exit")
$pipe.Write($wb, 0, $wb.Length)


$pipe.Close()
