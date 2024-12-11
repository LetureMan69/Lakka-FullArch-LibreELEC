# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

import xbmc
import xbmcvfs
import xbmcaddon
from os import system


class MyMonitor(xbmc.Monitor):
    def __init__(self, *args, **kwargs):
        xbmc.Monitor.__init__(self)
    
    def onSettingsChanged(self):
        writeconfig()

            
# addon
__addon__ = xbmcaddon.Addon(id='service.net-snmp')
__addonpath__ = xbmcvfs.translatePath(__addon__.getAddonInfo('path'))
__addonhome__ = xbmcvfs.translatePath(__addon__.getAddonInfo('profile'))
if not xbmcvfs.exists(xbmcvfs.translatePath(f'{__addonhome__}share/snmp/')):
    xbmcvfs.mkdirs(xbmcvfs.translatePath(f'{__addonhome__}share/snmp/'))
config = xbmcvfs.translatePath(f'{__addonhome__}share/snmp/snmpd.conf')
persistent = xbmcvfs.translatePath(f'{__addonhome__}snmpd.conf')


def writeconfig():
    system("systemctl stop service.net-snmp.service")
    community = __addon__.getSetting("COMMUNITY")
    location = __addon__.getSetting("LOCATION")
    contact = __addon__.getSetting("CONTACT")
    snmpversion = __addon__.getSetting("SNMPVERSION")
    cputemp = __addon__.getSetting("CPUTEMP")
    gputemp = __addon__.getSetting("GPUTEMP")

    if xbmcvfs.exists(persistent):
        xbmcvfs.delete(persistent)

    file = xbmcvfs.File(config, 'w')
    file.write(f'com2sec local default {community}\n')
    file.write(f'group localgroup {snmpversion} local\n')
    file.write('access localgroup "" any noauth exact all all none\n')
    file.write('view all included .1 80\n')
    file.write(f'syslocation {location}\n')
    file.write(f'syscontact {contact}\n')
    file.write('dontLogTCPWrappersConnects yes\n')

    if cputemp == "true":
        file.write('extend cputemp "/usr/bin/cputemp"\n')

    if gputemp == "true":
        file.write('extend gputemp "/usr/bin/gputemp"\n')

    if snmpversion == "v3":
        file.write('includeFile ../../snmpd.conf\n')
        snmppassword = __addon__.getSetting("SNMPPASSWORD")
        snmpuser = __addon__.getSetting("SNMPUSER")
        system("net-snmp-config --create-snmpv3-user -a MD5 -A {0} {1}".format(snmppassword,snmpuser))

    file.close()
    system("systemctl start service.net-snmp.service")


if not xbmcvfs.exists(config):
    writeconfig()

monitor = MyMonitor()
while not monitor.abortRequested():
    if monitor.waitForAbort():
        break

