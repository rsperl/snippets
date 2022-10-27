## Variable Templates

Variables in `defaults/` cannot be conditionally included. Instead place variable files in `vars/filename.yml` for conditional including. For example, given

    % tree roles/testvars
    .
    ├── defaults/
    ├── tasks/
    │   └── main.yml
    └── vars/
        ├── t1.yml
        └── t2.yml

`vars/t1.yml` and `vars/t2.yml` each define `myvar`:

    ---
    # vars/t1.yml
    myvar: t1

    ---
    # vars/t2.yml
    myvar: t2

`tasks/main.yml` contains

    ---
    # tasks/main.yml

    - name: check myvar
      set_fact:
        isdefined: "{{ myvar is defined }}"

    - name: show whether myvar is defined
      debug:
        msg: "myvar is defined: {{ isdefined }}"

    - name: include myvar file
      include_vars: "{{ whichfile }}.yml"

    - name: dump myvar
      debug:
        msg: "{{ myvar }}"

and the playbook `cond_vars.yml` contains

    ---
    - name: test var includes
      hosts: 127.0.0.1
      connection: local

      roles:
          - name: testvars
            file: "{{ whichfile }}"

Applying the role by specifying `whichfile` allows you to conditionally include varariables.

For instance, calling

    ansible-play -e whichfile=t1 ```cond_vars.yml``` .yml

will include `t1.yml` and set `myvar=t1`, and `t2.yml` never gets included.

Alternatively, calling

    ansible-play -e whichfile=t2 cond_vars.yml

will instead include `t2.yml` rather than t1.yml, `myvar=t2`, and `t1.yml` never gets included.

** I also added /vars/common_var.yml that sets common_var, which is overridden by the role vars **
