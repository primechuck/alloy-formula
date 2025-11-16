# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as alloy with context %}

{% set arch = salt['grains.get']('cpuarch') %}

{%- set os_family = salt['grains.get']('os_family') %}
{%- set raw_cpu_arch = salt['grains.get']('cpuarch') %}

{%- if os_family in ['Debian', 'RedHat', 'Fedora', 'Oracle', 'SUSE'] %}
{# Normalize architecture for Grafana's supported amd64/arm64 #}
{%- set target_arch = '' %}
{%- if raw_cpu_arch in ['amd64', 'x86_64'] %}
  {%- set target_arch = 'amd64' %}
{%- elif raw_cpu_arch in ['arm64', 'aarch64'] %}
  {%- set target_arch = 'arm64' %}
{%- endif %}
alloy-package-install-pkg-installed:
  pkg.installed:
    - name: {{ alloy.pkg.name }}
    - require:
      - pkgrepo: alloy-repo-installed
{%- endif %}