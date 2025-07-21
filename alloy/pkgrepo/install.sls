# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as alloy with context %}

{%- set os_family = salt['grains.get']('os_family') %}


alloy-repo-installed:
  pkgrepo.managed:
    {% if os_family == 'Debian' %}
    - name: deb [arch={{ alloy.arch }} signed-by={{ alloy.repo.signed_by }}] {{ alloy.repo.uri }} {{ alloy.repo.dist }} {{ alloy.repo.comps }}
    - uri: {{ alloy.repo.uri }}
    - dist: {{ alloy.repo.dist }}
    - comps: {{ alloy.repo.comps }}
    - file: {{ alloy.repo.file }}
    - arch: {{ alloy.arch }}
    - signed_by: {{ alloy.repo.signed_by }}
    - key_url: {{ alloy.repo.key_url }}
    - key_source_hash: {{ alloy.repo.key_source_hash }}
    - refresh_db: True
    - clean_file: True
    - gpgcheck: 1
    - aptkey: False
    {% elif os_family in ['RedHat', 'Fedora', 'Oracle', 'SUSE'] %}
    - humanname: {{ alloy.repo.humanname }}
    - name: {{ alloy.repo.name }}
    - file: {{ alloy.repo.file }}
    - baseurl: {{ alloy.repo.baseurl }}
    - gpgkey: {{ alloy.repo.gpgkey }}
    - gpgcheck: 1
    - enabled: 1
    
  {%- else %}
    {{- raise("Alloy formula (pkgrepo) is only supported on amd64/x86_64 and arm64/aarch64 Linux architectures. Current OS family: " ~ os_family ~ ", Current arch: " ~ raw_cpu_arch ~ ". Halting formula application for alloy.pkgrepo.") }}
  {%- endif %}