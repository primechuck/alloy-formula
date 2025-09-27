# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as alloy with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- set os_family = salt['grains.get']('os_family') %}
{%- set arch = salt['grains.get']('arch') %}

# deb [arch=amd64 signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main

alloy-repo-installed:
  pkgrepo.managed:
    {% if os_family == 'Debian' %}
    - name: deb [signed-by={{ alloy.pkg.repo.signed_by }}]  {{ alloy.pkg.repo.url }}
    - key_url: {{ alloy.pkg.repo.key_url }}
    - aptkey: False
    {% elif os_family in ['RedHat', 'Fedora', 'Oracle', 'SUSE'] %}
    - humanname: {{ alloy.pkg.repo.humanname }}
    - name: {{ alloy.pkg.repo.name }}
    - file: {{ alloy.pkg.repo.file }}
    - baseurl: {{ alloy.pkg.repo.baseurl }}
    - gpgkey: {{ alloy.pkg.repo.gpgkey }}
    - gpgcheck: 1
    - enabled: 1
    
  {%- else %}
    {{- raise("Alloy formula (pkgrepo) is only supported on amd64/x86_64 and arm64/aarch64 Linux architectures. Current OS family: " ~ os_family ~ ", Current arch: " ~ raw_cpu_arch ~ ". Halting formula application for alloy.pkgrepo.") }}
  {%- endif %}