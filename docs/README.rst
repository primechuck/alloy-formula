.. _readme:

grafana-alloy-formula
=====================

|img_travis| |img_sr| |img_pc|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/grafana-alloy-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/grafana-alloy-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

A SaltStack formula that is empty. It has dummy content to help with a quick
start on a new formula and it serves as a style guide.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

Special notes
-------------

None

Available states
----------------

.. contents::
   :local:

``grafana-alloy``
^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This installs the grafana-alloy package,
manages the grafana-alloy configuration file and then
starts the associated grafana-alloy service.

``grafana-alloy.package``
^^^^^^^^^^^^^^^^^^^^^^^^^

This state will install the grafana-alloy package only.

``grafana-alloy.config``
^^^^^^^^^^^^^^^^^^^^^^^^

This state will configure the grafana-alloy service and has a dependency on ``grafana-alloy.install``
via include list.

``grafana-alloy.service``
^^^^^^^^^^^^^^^^^^^^^^^^^

This state will start the grafana-alloy service and has a dependency on ``grafana-alloy.config``
via include list.

``grafana-alloy.clean``
^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

this state will undo everything performed in the ``grafana-alloy`` meta-state in reverse order, i.e.
stops the service,
removes the configuration file and
then uninstalls the package.

``grafana-alloy.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will stop the grafana-alloy service and disable it at boot time.

``grafana-alloy.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the configuration of the grafana-alloy service and has a
dependency on ``grafana-alloy.service.clean`` via include list.

``grafana-alloy.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the grafana-alloy package and has a depency on
``grafana-alloy.config.clean`` via include list.

``grafana-alloy.subcomponent``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This state installs a subcomponent configuration file before
configuring and starting the grafana-alloy service.

``grafana-alloy.subcomponent.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will configure the grafana-alloy subcomponent and has a
dependency on ``grafana-alloy.config`` via include list.

``grafana-alloy.subcomponent.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the configuration of the grafana-alloy subcomponent
and reload the grafana-alloy service by a dependency on
``grafana-alloy.service.running`` via include list and ``watch_in``
requisite.

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``grafana-alloy`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.
