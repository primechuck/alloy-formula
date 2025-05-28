# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as alloy with context %}

alloy-service-clean-service-dead:
  service.dead:
    - name: {{ alloy.service.name }}
    - enable: False
