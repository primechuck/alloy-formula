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


{%- elif os_family in ['FreeBSD'] %}
  {%- if arch in ['amd64'] %}

{%- set full_binary_path = "{}/{}".format(
                        alloy.paths.install_dir,
                        alloy.binary.name
                      ) %}
{% set binary_filename = "{}-{}-{}".format(
                                alloy.pkg.name,
                                os_family,
                                arch
).lower() %}
# https://github.com/grafana/alloy/releases/download/v1.9.1/alloy-freebsd-amd64.zip
  {% set binary_url = "{}/{}/{}.{}".format(
                          alloy.dl.base_url,
                          alloy.dl.version_prefix,
                          binary_filename,
                          alloy.dl.archive_type
                        ) %}
install_alloy_from_archive:
  archive.extracted:
    - name: {{ alloy.paths.install_dir }}
    - enforce_toplevel: False
    - source: {{ binary_url }}
    - source_hash: {{ alloy.dl.checksum }}
    - archive_format: {{ alloy.dl.archive_type }}
    - if_missing: {{ alloy.paths.install_dir }}/{{ alloy.pkg.name }}
    - user: {{ alloy.user }}
    - group: {{ alloy.group }}
    - unless: test -f {{ alloy.paths.install_dir }}/{{ alloy.pkg.name }} --version 2>/dev/null | grep {{ alloy.dl.version_prefix }}

{% if alloy.dl.component_name != alloy.binary.name %}
alloy_binary_renamed:
  file.rename:
    - name: {{ full_binary_path }}
    - source: {{ alloy.paths.install_dir }}/{{ binary_filename }}
    - force: True
    - require:
      - archive: install_alloy_from_archive
    - onlyif:
      - test -f {{ alloy.paths.install_dir }}/{{ binary_filename }}

alloy_binary_attributes:
  file.managed:
    - name: {{ full_binary_path }}
    - user: {{ alloy.user }}
    - group: {{ alloy.group }}
    - mode: '0755'
    - onlyif:
      - test -f {{ full_binary_path }}

{% endif %}

  {%- endif %}
    {%- endif %}



