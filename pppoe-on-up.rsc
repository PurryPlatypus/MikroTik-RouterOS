:global pppoeOnUpRun
:if ($pppoeOnUpRun = true) do={
    :log info "pppoe-on-up: another instance is running; skipping"
} else={
    :set pppoeOnUpRun true
    :onerror err in={
    
        :local wanIP ""
        :for i from=1 to=10 do={
            :if ([/ip address print count-only where interface="pppoe-out1" and dynamic=yes] > 0) do={
                :set wanIP [/ip address get [/ip address find where interface=pppoe-out1] address]
                :break
            }
            :delay 500ms
        }

        :if ($wanIP != "") do={
            /system leds set [find where leds=user-led] type=on
            /tool e-mail send to="yourmom@example.com" subject=("pppoe-on-up") body=("pppoe-out1 WAN address: " . $wanIP)
        }
    
    } do={
        :set pppoeOnUpRun false
        :log error ("pppoe-on-up failed: " . $err)
    }
    :set pppoeOnUpRun false
}
