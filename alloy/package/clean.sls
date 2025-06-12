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

{#
Removing users and groups can be destructive if they own files
outside the managed paths or are used by other services.
In a production formula, this would typically be guarded by a Pillar flag:
e.g., if salt['pillar.get']('alloy:remove_user_group', False)
#}
alloy_user_removed:
  user.absent:
    - name: {{ alloy.user }}
    - require: # Ensure files are removed first
      - file: alloy_config_dir_removed
      - file: alloy_binary_removed
    - order: 40

alloy_group_removed:
  group.absent:
    - name: {{ alloy.group }}
    - require: # Ensure user is removed first (if they were the only member)
      - user: alloy_user_removed
    - order: 50

# Add other cleanup tasks as needed, e.g., log directories if managed.