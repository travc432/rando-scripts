#This script is designed to find a device online, 
#search for a file and return it's hash
#Author: Travis Crotteau
#Date: 8/11/2022


#First, look for specified device

$computername = Read-Host "Which computer are we looking at?"
$file = Read-Host "What file are you looking for?"

DO
  {
  $alive = Test-Connection -ComputerName $computername -Count 1 -Quiet
  Wait -Seconds 120
  }
Until ($alive = True)

if ($alive = False)
  {"\\$computername\c$" | Get-Childitem -recurse -filter $file | Get-FileHash

