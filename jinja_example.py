#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import jinja2

scriptdir = os.path.dirname(os.path.realpath(__file__))

tmpl = scriptdir + "/mytemplate.j2"
dest = scriptdir + "/outputfile.txt"


def render(tpl_path, context):
    """
    call render with the template filename and the variables the template requires
    """
    path, filename = os.path.split(tpl_path)
    return (
        jinja2.Environment(loader=jinja2.FileSystemLoader(path or "./"))
        .get_template(filename)
        .render(context)
    )


# template variables
data = dict(var1="val1", var2="val2")

# combine the variables with the template and write to destination file
with open(dest, "w") as f:
    f.write(render(tmpl, data))
