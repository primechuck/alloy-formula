# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as grafana__alloy with context %}

grafana-alloy-service-clean-service-dead:
  service.dead:
    - name: {{ grafana__alloy.service.name }}
    - enable: False
