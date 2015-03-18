Role Name
========

Installs PostgreSQL 9.3 from the postgres website. Includes some tailoring.

Requirements
------------

python-psycopg2 for checking postgresql user passwords

Role Variables
--------------

    postgres:
        listenon:
        datadir:

Variables that are used to create the data directory, and define what IP to
listen on. Ends up in templates.

Dependencies
------------


Example Playbook
-------------------------

    - hosts: servers
      roles:
         - postgres

License
-------

BSD

Author Information
------------------

Mark Phillips <mark@vntx.cc>
http://vntx.cc
