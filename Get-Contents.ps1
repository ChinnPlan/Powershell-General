PARAM (
  [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
  [string]$text,	
  [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
  [string]$Path
  )

Get-ChildItem -Path $Path -Recurse | Select-String $text -List | Select Path