# Powershell-script
#URL health check Monotoring
$URLListFile = "U:\Powershell\websites.txt"
$URLList = Get-Content $URLListFile -ErrorAction SilentlyContinue
 $Result = @()

  Foreach($URL in $URLList)
{
 $time = try
 {
   $request = $null
   ## Request the URL and measure how long the response book.
   $result1 = Measure.command {$request = Invoke-WebRequest -Url $URL}
   $result1.TotalMilliseconds
 }
 catch
 {
   <#if the request genrated an exception (i.e.: 500 server error or 400 server error found),we can pull the status code from the property #>
    $request = $_.Exception.Response
    $time = -1
 }
 $result +=[PSCustomObject] @{
  Time = Get-Date;
  Url = $Url;
  StatusCode = [int] $request.StatusCode;
  StatusDescription = $request.StatusDescription;
  ResponseLength = $request.RawContentLength;
  TimeTaken = $Time;
  }
}
$result | Export-Csv U:\Powershell\CSVOutput.csv -NoTypeInformation
