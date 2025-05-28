# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana__alloy with context %}

grafana-alloy-package-install-pkg-installed:
  pkg.installed:
    - name: {{ grafana__alloy.pkg.name }}
