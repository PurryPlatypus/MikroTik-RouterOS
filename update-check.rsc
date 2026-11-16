/system package update check-for-updates once
:delay 15s
:if ([/system package update get status] = "New version is available") do={
    :local latest [/system package update get latest-version]
    :log warning ("RouterOS " . $latest . " is available")
    /tool e-mail send to=yourmom@example.com subject=("RouterOS " . $latest . " is available") body=("RouterOS " . $latest . " is available to install - https://mikrotik.lan/webfig/#System:Packages.Check_For_Updates")
}
