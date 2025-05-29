# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as alloy with context %}


alloy-repo-installed:
  pkg.managed:
    {% if salt['grains.get']('os_family') == 'Debian' %}
    - name: {{ alloy_map.repo.line }}
    - file: {{ alloy_map.repo.file }}
    - key_url: {{ alloy_map.repo.key_url }}
    - refresh_db: True
    - gpgcheck: 1

    {% elif salt['grains.get']('os_family') in ['RedHat'] %}
    - humanname: {{ alloy_map.repo.humanname }}
    - name: {{ alloy_map.repo.file }}
    - baseurl: {{ alloy_map.repo.baseurl }}
    - gpgkey: {{ alloy_map.repo.gpgkey }}
    - gpgcheck: 1
    - enabled: 1
    {% endif %}
    - name: {{ alloy.pkgrepo.name }}

