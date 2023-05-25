$URLListFile = "U:\Powershell\websites.txt" 
$URLList = Get-Content $URLListFile -ErrorAction SilentlyContinue

  $Result = @() #Create result as an empty array 
  
  Foreach($Uri in $URLlist) {
  $time = TRY{
  $request = $null
  #Request the URI, and measure how long the response took.
  $result1 = Measure-Command { $request = Invoke-WebRequest -Uri $uri }
  $result1.TotalMilliseconds
  } 
  CATCH {
  <# If the request generated an exception (i.e.: 500 server
  error or 404 not found), we can pull the status code from the
  Exception.Response property #>
  $request = $_.Exception.Response
  $time = -1
  }  

  $result += [PSCustomObject] @{
  Time = Get-Date ;
  Uri = $uri;
  StatusCode = [int] $request.StatusCode;
  StatusDescription = $request.StatusDescription;
  ResponseLength = $request.RawContentLength;
  TimeTaken =  $time; 
  }

}

$today =  Get-Date -format "dd-MMM-yyyy HH:mm:ss"
 
$dateObject = [PSCustomObject]@{
  Date = $today
 }

 if(!(Test-Path $csvFilepath))
{
 $result | Export-Csv U:\Powershell\CSVOutput.csv -NoTypeInformation
}
 else
{
 $result | Export-Csv U:\Powershell\CSVOutput.csv -NoTypeInformation -Append
}





 

  

 