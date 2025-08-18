{%- if grains['os_family'] == 'Windows' %}
  {%- set li_config_location = 'C:\\ProgramData\\VMware\\Log Insight Agent\\liagent.ini' %}
  {%- set pkg_name = 'li-agent' %}
  {%- set service_name = 'LogInsightAgentService' %}
  {%- set config = 'liagent-win.ini' %}


{% elif grains['os_family'] == 'Debian' %}
  {%- set li_config_location = '/etc/liagent.ini' %}
  {%- set pkg_name = 'vmware-log-insight-agent' %}
  {%- set service_name = 'liagentd' %}
  {%- set pkg_source = 'salt://packages/vmware-log-insight-agent_8.18.3-24507632.deb' %}
  {%- set config = 'liagent-deb.ini' %}
{% endif -%}

li_package:
  pkg.installed:
    {% if pkg_source is defined %}
    - sources:
      - {{ pkg_name }}: {{ pkg_source }}
    - skip_verify: True
    {% else %}
    - name: {{ pkg_name }}
    {% endif %}

li_config:
  file.managed:
    - name: {{ li_config_location }}
    - source: salt://states/software/li-agent/configurations/{{ config }}

# Restart service if changes were made to log insight configuration
li_service:
  service.running:
    - name: {{ service_name }}
    - enable: True
    - watch:
      - pkg: li_package
      - file: li_config