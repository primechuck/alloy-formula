# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as alloy with context %}

{%- set os_family = salt['grains.get']('os_family') %}
{%- set raw_cpu_arch = salt['grains.get']('cpuarch') %}

{# Normalize architecture for Grafana's supported amd64/arm64 #}
{%- set target_arch = '' %}
{%- if raw_cpu_arch in ['amd64', 'x86_64'] %}
  {%- set target_arch = 'amd64' %}
{%- elif raw_cpu_arch in ['arm64', 'aarch64'] %}
  {%- set target_arch = 'arm64' %}
{%- endif %}

{%- if os_family in ['Debian', 'RedHat', 'Fedora', 'Oracle', 'SUSE'] %}  
  {%- if target_arch in ['amd64', 'arm64'] %}  
    {%- if os_family == 'Debian' %}
      {%- set keyring_dir = salt['file.dirname'](alloy.repo.keyring_path) %}

ensure_alloy_keyring_directory_exists:
  file.directory:
    - name: {{ keyring_dir }}
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True

download_alloy_gpg_key:
  file.managed:
    - name: {{ alloy.repo.keyring_path }}
    - source: {{ alloy.repo.key_url }}
    - source_hash: {{ alloy.repo.key_source_hash }}
    - dearmor: True
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: False
    - require:
      - file: ensure_alloy_keyring_directory_exists
    {%- endif %}

alloy-repo-installed:
  pkgrepo.managed:
    {% if os_family == 'Debian' %}
    - name: deb [arch={{ target_arch }} signed-by={{ alloy.repo.keyring_path }}] {{ alloy.repo.line }}
    - file: {{ alloy.repo.file }}
    - refresh_db: True
    - gpgcheck: 1
    - aptkey: False
    - require:
      - file: download_alloy_gpg_key
    - watch:
      - file: download_alloy_gpg_key
    {% elif os_family in ['RedHat', 'Fedora', 'Oracle', 'SUSE'] %}
    - humanname: {{ alloy.repo.humanname }}
    - name: {{ alloy.repo.file }}
    - baseurl: {{ alloy.repo.baseurl }}
    - gpgkey: {{ alloy.repo.gpgkey }}
    - gpgcheck: 1
    - enabled: 1
    {% endif %}

  {%- else %}
    {{- raise("Alloy formula (pkgrepo) is only supported on amd64/x86_64 and arm64/aarch64 Linux architectures. Current OS family: " ~ os_family ~ ", Current arch: " ~ raw_cpu_arch ~ ". Halting formula application for alloy.pkgrepo.") }}
  {%- endif %}

{%- else %}
  {#- For other OS families not explicitly handled (e.g. Windows, MacOS),
      or if os_family grain is not one of the Linux ones we check,
      this SLS file will not define any states.
      This results in a graceful skip. #}
{%- endif %}
