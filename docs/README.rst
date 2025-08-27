.. _readme:

alloy-formula
=====================

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

``alloy``
^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This installs the alloy package,
manages the alloy configuration file and then
starts the associated alloy service.

``alloy.package``
^^^^^^^^^^^^^^^^^^^^^^^^^

This state will install the alloy package only.

``alloy.config``
^^^^^^^^^^^^^^^^^^^^^^^^

This state will configure the alloy service and has a dependency on ``alloy.install``
via include list.

``alloy.service``
^^^^^^^^^^^^^^^^^^^^^^^^^

This state will start the alloy service and has a dependency on ``alloy.config``
via include list.

``alloy.clean``
^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

this state will undo everything performed in the ``alloy`` meta-state in reverse order, i.e.
stops the service,
removes the configuration file and
then uninstalls the package.

``alloy.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will stop the alloy service and disable it at boot time.

``alloy.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the configuration of the alloy service and has a
dependency on ``alloy.service.clean`` via include list.

``alloy.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the configuration of the alloy subcomponent
and reload the alloy service by a dependency on
``alloy.service.running`` via include list and ``watch_in``
requisite.
