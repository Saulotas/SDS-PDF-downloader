Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath("Desktop")
    Filter = "TXT (*.txt)| *.txt"
}
$null = $FileBrowser.ShowDialog()
$sourcefile = $FileBrowser.FileName
$sourcepath = Split-Path -Path $FileBrowser.FileName
cd $sourcepath 
New-Item -Name "PDF" -ItemType "directory"
cd..
$workpath = $sourcepath +'\PDF\'
foreach($line in [System.IO.File]::ReadLines($sourcefile))
{
   If (-not [string]::IsNullOrWhiteSpace($line) ) 
    {
            $filename = $line.Substring($line.LastIndexOf('=')+1)+'.pdf'
			[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-WebRequest $line -OutFile $workpath$filename
     }   
}
Invoke-item $workpath