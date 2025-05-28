# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as alloy with context %}

alloy-package-install-pkg-installed:
  pkg.installed:
    - name: {{ alloy.pkg.name }}
