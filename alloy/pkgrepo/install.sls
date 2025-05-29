# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as alloy with context %}


alloy-repo-installed:
  pkgrepo.managed:
    {% if salt['grains.get']('os_family') == 'Debian' %}
    - name: {{ alloy.repo.line }}
    - file: {{ alloy.repo.file }}
    - key_url: {{ alloy.repo.key_url }}
    - refresh_db: True
    - gpgcheck: 1

    {% elif salt['grains.get']('os_family') in ['RedHat', 'Fedora', 'Oracle', 'SUSE'] %}
    - humanname: {{ alloy.repo.humanname }}
    - name: {{ alloy.repo.file }}
    - baseurl: {{ alloy.repo.baseurl }}
    - gpgkey: {{ alloy.repo.gpgkey }}
    - gpgcheck: 1
    - enabled: 1
    {% endif %}

