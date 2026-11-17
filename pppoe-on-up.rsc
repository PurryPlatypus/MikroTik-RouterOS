# the on-up hook fires twice during pppoe connection setup,
# resulting in two running instances of this script, which is undesired.
# the script intentionally has a few delays, to make sure it's still running
# when the second/undesired instance executes
:if ([/system script job print count-only as-value where script=[:jobname]] > 1) do={
    :log info "pppoe-on-up: not Singleton; exiting"
    :exit
}
:log info "pppoe-on-up: Singleton achieved; continuing"

:delay 1s
:local wanIP ""
:for i from=1 to=10 do={
    :if ([/ip address print count-only where interface="pppoe-out1" and dynamic=yes] > 0) do={
        :set wanIP [/ip address get [/ip address find where interface=pppoe-out1] address]
        :break
    }
    :delay 500ms
}

:if ($wanIP != "") do={
    :log info ("WAN IP address " . $wanIP)
    /system leds set [find where leds=user-led] type=on
    :delay 5s
    /tool e-mail send to="yourmom@example.com" subject=("pppoe-on-up") body=("pppoe-out1 WAN address: " . $wanIP . "  https://duckduckgo.com/?q=my+ip+address")
}
