# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as alloy with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- set os_family = salt['grains.get']('os_family') %}

include:
  - {{ sls_config_file }}

{% if os_family in ['RedHat', 'Fedora', 'Oracle', 'SUSE'] %}

alloy-service-running-service-running:
  service.running:
    - name: {{ alloy.service.name }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}

{% elif grains.os_family == 'FreeBSD' %}

# Ensure the directory for rc.d scripts exists, though it usually does.
# /usr/local/etc/rc.d is standard on FreeBSD for add-on packages.
freebsd_rc_d_directory_exists:
  file.directory:
    - name: /usr/local/etc/rc.d
    - user: root
    - group: wheel
    - mode: '0755'
    - makedirs: True

alloy_rc_script:
  file.managed:
    - name: /usr/local/etc/rc.d/{{ alloy.service.name }}
    - source: {{ files_switch(
                    source_files=[
                      "usr/local/etc/rc.d/" ~ alloy.service.name ~ ".jinja",
                    ],
                    lookup="alloy_freebsd_rc_script"
                  )
              }}
    - user: {{ alloy.user }}
    - group: {{ alloy.group }}
    - mode: '0755'
    - template: jinja
    - context:
        alloy_binary_path: "{{ alloy.paths.install_dir | default(alloy.binary.install_dir, true) }}/{{ alloy.binary.name }}"
        alloy_config_file: "{{ alloy.config_file }}"
        alloy_user: "{{ alloy.user }}"
    - require:
      - file: freebsd_rc_d_directory_exists
    - watch_in:
      - service: alloy_service_running

alloy_service_running:
  service.running:
    - name: {{ alloy.service.name }}
    - enable: {{ alloy.service.enable }}
    - watch:
      - file: {{ alloy.config_file }}
      - file: alloy_rc_script

{% endif %}
