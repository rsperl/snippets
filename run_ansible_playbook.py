#!/usr/bin/env python3
"""
How to programatically run a playbook
(adapted from http://docs.ansible.com/ansible/dev_guide/developing_api.html#python-api-2-0)

Note that example from URL above only supports a single play per run, while actual playbooks
contain a list of plays. A playbook cannot be read in and run, but read in, and each play
run one at at time, and evaulate the result of each play separately (see below)

Also note that this is not a general purpose playbook runner, but one specifically suited to
run validation for our playbooks. A general purpose runner would require far more options
than allowed for here.
"""

import yaml
from collections import namedtuple
from ansible.parsing.dataloader import DataLoader
from ansible.vars import VariableManager
from ansible.inventory import Inventory
from ansible.playbook.play import Play
from ansible.executor.task_queue_manager import TaskQueueManager
from ansible.plugins.callback.json import CallbackModule as JsonCallback
import os

cwd = os.path.dirname(os.path.realpath(__file__))
repodir = cwd + "/../../playbooks/ansible-itd"
module_path = repodir + "/library"


class Runner(object):
    def __init__(self):
        self.results = []

    def get_results(self):
        return self.results

    def run(self, state, extra_vars={}, vaultpassword=None):
        Options = namedtuple(
            "Options",
            [
                "connection",
                "module_path",
                "forks",
                "become",
                "become_method",
                "become_user",
                "check",
            ],
        )
        # initialize needed objects
        variable_manager = VariableManager()
        loader = DataLoader()
        options = Options(
            connection="local",
            module_path=module_path,
            forks=100,
            become=None,
            become_method=None,
            become_user=None,
            check=False,
        )
        passwords = dict(vault_pass=vaultpassword)

        # Instantiate our ResultCallback for handling results as they come in
        results_callback = JsonCallback()

        # create inventory and pass to var manager
        inventory = Inventory(
            loader=loader,
            variable_manager=variable_manager,
            # host_list='localhost'
        )
        variable_manager.set_inventory(inventory)

        variable_manager.set_extra_vars = extra_vars

        # create play with tasks
        play_source = dict(
            name="validate user vars",
            hosts="localhost",
            gather_facts="no",
            tasks=[
                dict(
                    action=dict(
                        module="include_vars", args=repodir + "/vars/vault_itdeploy.yml"
                    )
                ),
                dict(
                    action=dict(
                        module="include_vars", args=repodir + "/vars/itdeploy.yml"
                    )
                ),
                dict(
                    action=dict(
                        module="playbook_validation",
                        args=dict(state=state, vars=extra_vars),
                    )
                ),
            ],
        )

        play = Play().load(
            play_source, variable_manager=variable_manager, loader=loader
        )

        # actually run it
        tqm = None
        try:
            tqm = TaskQueueManager(
                inventory=inventory,
                variable_manager=variable_manager,
                loader=loader,
                options=options,
                passwords=passwords,
                # Use our custom callback instead of the ``default`` callback plugin
                stdout_callback=results_callback,
            )
            tqm.run(play)
        finally:
            if tqm is not None:
                tqm.cleanup()
        return results_callback.results


def do_validate(state, extra_vars):
    r = Runner()
    results = r.run(state, extra_vars)
    try:
        validated = results[0]["tasks"][0]["hosts"]["localhost"]["validated"]
        errors = results[0]["tasks"][0]["hosts"]["localhost"]["errors"]
    except KeyError:
        raise Exception("error running validation: {}".format(results))
    return (validated, errors)
