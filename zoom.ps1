Add-Type @"

	using System;
	using System.Runtime.InteropServices;

	public class MagnifyApi {

		[DllImport("Magnification.dll")]
		public static extern bool MagSetFullscreenTransform(float magLevel,int xOffset,int yOffset);

		[DllImport("Magnification.dll")]
		public static extern bool MagInitialize();

		[DllImport("Magnification.dll")]
		public static extern bool MagUninitialize();
    }
"@

$pipe = New-Object System.IO.Pipes.NamedPipeServerStream "np", InOut, 1
if ($pipe -eq $null){
 exit
}

[MagnifyApi]::MagInitialize();

# MagSetFullscreenTransform(zoom_level,XOffset,YOffset);
# 例: 
# 1Pの場合: 
# [magnifyapi]::magsetfullscreentransform(1.5,0,138);
# 2Pの場合
# [magnifyapi]::magsetfullscreentransform(1.5,410,138);

[magnifyapi]::magsetfullscreentransform(1.5,0,138);

$pipe.WaitForConnection()
$buf = New-Object byte[] 1024
$loop = $true

while($loop) {
	$len = $pipe.Read($buf, 0, $buf.Length)
	$cmd = [System.Text.Encoding]::Unicode.GetString($buf, 0, $len)

	if($cmd -match '^exit|^quit') {
		$loop = $false
	}

}

$pipe.Close()

[MagnifyApi]::MagSetFullscreenTransform(1.0,0,0);
[MagnifyApi]::MagUninitialize();

exit
