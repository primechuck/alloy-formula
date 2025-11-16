# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package' %}
{%- from tplroot ~ "/map.jinja" import mapdata as alloy with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

alloy-config-file-file-managed:
  file.managed:
    - name: {{ alloy.config_file }}
    - source: {{ files_switch(['config.alloy.jinja'],
                              lookup='alloy-config-file-file-managed'
                 )
              }}
    - mode: '0644'
    - user:  {{ alloy.user }}
    - group: {{ alloy.group }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        alloy: {{ alloy | json }}
