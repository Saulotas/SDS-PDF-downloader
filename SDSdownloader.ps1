Add-Type -AssemblyName System.Windows.Forms

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath("Desktop")
    Filter = "TXT (*.txt)| *.txt"
}
$null = $FileBrowser.ShowDialog()
$sourcefile = $FileBrowser.FileName
$sourcepath = Split-Path -Path $FileBrowser.FileName


if (-not (Test-Path -LiteralPath $sourcepath\PDF))
{
New-Item -path "$sourcepath\PDF" -ItemType "directory"
}

$workpath = $sourcepath +'\PDF\'



foreach  ($line in  [System.IO.File]::ReadLines($sourcefile)| Where-Object { $_.Trim() -ne ''})
{
    if ($line -contains ("https"))
        {
            $filename = $workpath+$line.Substring($line.LastIndexOf('=')+1)+'.pdf'
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            #Invoke-WebRequest 
            Invoke-RestMethod $line -OutFile $filename
        }
    else
        {
            $filename = $workpath+$line.Substring($line.LastIndexOf('%3D')+3)+'.pdf'
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            #Invoke-WebRequest 
            Invoke-RestMethod $line -OutFile $filename
        }
}

Invoke-item $workpath
