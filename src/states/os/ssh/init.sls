{% if grains['os_family'] == 'Debian' %}
ssh_package:
  pkg.installed:
    - name: openssh-server
    - refresh: True

ssh_config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://states/os/ssh/debian_hardened_sshd_config
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: ssh_package

ssh_banner:
  file.managed:
    - name: /etc/ssh/sshd_banner
    - source: salt://states/os/ssh/debian_ssh_banner
    - user: root
    - group: root
    - mode: 600
    - attrs: i
    - require:
      - pkg: ssh_package

ssh_service:
  service.running:
    - name: sshd
    - enable: True
    - watch:
      - file: ssh_config
      - file: ssh_banner
{% endif %}