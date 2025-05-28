# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana__alloy with context %}

include:
  - {{ sls_config_clean }}

grafana-alloy-package-clean-pkg-removed:
  pkg.removed:
    - name: {{ grafana__alloy.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
