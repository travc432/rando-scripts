#A Pomodoro timer/task tracker for powershell.

$cycle = [PSCustomObject]@{
    name = 'cycle'
    stage = 'null'
    event = 'null'
}
$stopwatch = New-Object -TypeName System.Diagnostics.Stopwatch
$time_remaining = 0
$pom_timer = New-Object -TypeName System.Timers.Timer -Property @{ 
    AutoReset = $false;
    Enabled = $true;
    Interval = 1500000 
} 
$five_min_timer = New-Object -TypeName System.Timers.Timer -Property @{ 
    AutoReset = $false;
    Enabled = $true;
    Interval = 300000 #5 min
} 
$fifteen_min_timer = New-Object -TypeName System.Timers.Timer -Property @{ 
    AutoReset = $false;
    Enabled = $true;
    Interval = 900000 #15 minutes
} 
    
function Start-PomTimer {
    $script:stopwatch.Start()
    $script:cycle.stage = 'pomodoro'
    Register-ObjectEvent -InputObject $script:pom_timer -EventName Elapsed -SourceIdentifier Pomodoro -Action {
        Write-Host "Pomodoro Complete!" -fore Green
        Get-EventSubscriber | Unregister-Event
        Remove-Event -SourceIdentifier Pomodoro
        $global:cycle.stage = 'pom_complete'
        $global:stopwatch.Reset()
    }
    $script:time_remaining = 1500000
    $pom_timer.Start()
    $global:cycle.event = "Pomodoro"
}

function Start-FiveMinTimer {
    $script:stopwatch.Start()
    $script:cycle.stage = 'five_min_break'
    Register-ObjectEvent -InputObject $five_min_timer -EventName Elapsed -SourceIdentifier five_min_break -Action {
        Write-Host "Five minute break complete!" -ForegroundColor Green
        Get-EventSubscriber | Unregister-Event
        Remove-Event -SourceIdentifier five_min_break
        $global:cycle.stage = 'five_min_break_complete'
        $global:stopwatch.Reset()
    }
    $script:time_remaining = 300000
    $five_min_timer.Start()
    $global:cycle.event = "five_min_break"
}

function Start-FifteenMinTimer {
    $script:stopwatch.Start()
    $script:cycle.stage = 'fifteen_min_break'
    Register-ObjectEvent -InputObject $fifteen_min_timer -EventName Elapsed -SourceIdentifier fifteen_min_break -Action {
        Write-Host "Fifteen minute break complete!" -ForegroundColor Green
        Get-EventSubscriber | Unregister-Event
        Remove-Event -SourceIdentifier fifteen_min_break
        $global:cycle.stage = 'fifteen_min_complete'
        $global:stopwatch.Reset()
    }
    $script:time_remaining = 900000
    $fifteen_min_timer.Start()
    $global:cycle.event = "fifteen_min_break"
}

function Stop-Timer {
    $script:stopwatch.stop()
    $script:time_remaining = ($script:time_remaining - $script:stopwatch.ElapsedMilliseconds) 
    $time_remaining_min = [timespan]::FromMilliseconds($script:time_remaining)
    Write-Host $time_remaining_min.ToString("mm' minutes and 'ss' seconds remaining.'")
}
function Resume-Timer {
    Unregister-Event -SourceIdentifier $script:cycle.event
    if ($script:cycle.stage = 'pomodoro') {
        $pom_timer = New-Object -TypeName System.Timers.Timer -Property @{ 
            AutoReset = $false;
            Enabled = $true;
            Interval = $time_remaining
        }
        Register-ObjectEvent -InputObject $pom_timer -EventName Elapsed -SourceIdentifier Pomodoro -Action {
            Write-Host "Pomodoro Complete!" -ForegroundColor Green
            Get-EventSubscriber | Unregister-Event
            Remove-Event -SourceIdentifier Pomodoro
            $global:cycle.stage = 'pom_complete'
            $global:stopwatch.Reset()
        }
        $pom_timer.Start() 
        $stopwatch.Start() 
    }
    elseif ($script:cycle.stage = 'five_min_break') {
        $five_min_timer = New-Object -TypeName System.Timers.Timer -Property @{ 
            AutoReset = $false;
            Enabled = $true;
            Interval = $time_remaining
        }
        Register-ObjectEvent -InputObject $five_min_timer -EventName Elapsed -SourceIdentifier five_min_break -Action {
            Write-Host "Five minute break complete!" -ForegroundColor Green
            Get-EventSubscriber | Unregister-Event
            Remove-Event -SourceIdentifier five_min_break
            $global:cycle.stage = 'five_min_break_complete'
            $global:stopwatch.Reset()
        }
        $five_min_timer.Start()
        $stopwatch.Start() 
    }    
    elseif ($script:cycle.stage = 'fifteen_min_break') {
        $fifteen_min_timer = New-Object -TypeName System.Timers.Timer -Property @{ 
            AutoReset = $false;
            Enabled = $true;
            Interval = $time_remaining
        }
        Register-ObjectEvent -InputObject $fifteen_min_timer -EventName Elapsed -SourceIdentifier five_min_break -Action {
            Write-Host "Fifteen minute break complete!" -ForegroundColor Green
            Get-EventSubscriber | Unregister-Event
            Remove-Event -SourceIdentifier fifteen_min_break
            $global:cycle.stage = 'fifteen_min_break_complete'
            $global:stopwatch.Reset()
        }
        $fifteen_min_timer.Start()
        $stopwatch.Start() 
    }
    else {
        Write-Host "Ah man, I don't know where we left off...." -ForegroundColor Red
    }
}

function Check-Timer {
    $script:time_left = ($script:time_remaining - $script:stopwatch.ElapsedMilliseconds) 
    $time_left_min = [timespan]::FromMilliseconds($time_left)
    Write-Host $time_left_min.ToString("mm' minutes and 'ss' seconds remaining.'")
}