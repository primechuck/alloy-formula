# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as alloy with context %}

include:
  - {{ sls_config_clean }}

alloy-package-clean-pkg-removed:
  pkg.removed:
    - name: {{ alloy.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}

#If FreeBSD
{# Construct the full path to the binary using values from alloy #}
{# These values would originate from defaults.yaml, OS-specific params, or Pillar #}
{% set binary_install_dir = alloy.binary.install_dir | default('/usr/local/bin') %}
{% set binary_name = alloy.binary.name | default('alloy') %}
{% set final_binary_path = binary_install_dir ~ '/' ~ binary_name %}

alloy_service_cleanup:
  service.dead:
    - name: {{ alloy.service.name }}
    - enable: False # Ensures the service is also disabled
    - onlyif: salt['service.available']('{{ alloy.service.name }}')
    - order: 10 # Run early

alloy_binary_removed:
  file.absent:
    - name: {{ final_binary_path }}
    - order: 20 # Run after service stop

alloy_config_dir_removed:
  file.absent:
    - name: {{ alloy.configpath }} # e.g., /etc/alloy
    - order: 30