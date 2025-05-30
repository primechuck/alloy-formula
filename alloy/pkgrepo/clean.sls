# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as alloy with context %}

include:
  - {{ sls_config_clean }}

alloy-repo-installed:
  pkgrepo.absent:
    {% if salt['grains.get']('os_family') == 'Debian' %}
    - name: {{ alloy.repo.line }}
    {% elif salt['grains.get']('os_family') in ['RedHat', 'Fedora', 'Oracle', 'SUSE'] %}
    - name: {{ alloy.repo.file }}
    {% endif %}
    - require:
      - sls: {{ sls_config_clean }}