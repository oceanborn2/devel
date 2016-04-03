@echo off
echo configuration des interfaces réseaux, passerelles et DNS
netsh < setstatic_noproxy.netsh

ping 192.168.1.254 4 12

ping 192.168.1.1 4 12

D:\software\firefox\firefox.exe http://www.google.fr

pause
