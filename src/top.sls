base:
#  '*':
#    - states.software.li-agent
#    - states.software.salt-minion
#    - states.software.telegraf-agent
  'G@os_family:Debian':
#    - states.os.crypto.fips
#    - states.os.crypto.policies
#    - states.security.pw
    - states.os.ssh
    - states.software.li-agent