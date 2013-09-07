#!/usr/bin/env python2

import re
import os
import subprocess
import tempfile
import ConfigParser


def DirectoryOfThisScript():
    return os.path.dirname(os.path.abspath(__file__))


def ParamArray(prefix, args):
    # given a list of tuples (parameters and their values), return
    # a flattened list generator of items with prefix string prepended
    # to the first element of each tuple
    return (arg for t in args for arg in [prefix + t[0], t[1]])


def FilterOut(keys, args):
    # take a list of tuples as second argument and return a list
    # generator of tuples that does not contain any tuples whose
    # first element matches any element fo the key list
    pattern = '^(' + '|'.join(re.escape(key) for key in keys) + ')$'
    return (t for t in args if not re.match(pattern, t[0]))


def main():
    # read config file
    executable = 'xcodebuild'
    derivedDataPath_option = 'derivedDataPath'
    scheme_option = 'scheme'
    workspace_option = 'workspace'
    workspace_suffix = '.xcworkspace'
    skip_keys = ['target', 'project', 'product']
    script_dir = DirectoryOfThisScript()

    config_path = os.path.join(script_dir, '.ycm_extra_conf.cfg')
    defaults = {'configuration': 'Debug', 'sdk': 'iphonesimulator'}
    config = ConfigParser.ConfigParser(defaults)
    config.optionxform = str  # do not convert to lower-case
    config.read(config_path)

    tmpdir = None
    for section in config.sections():
        # 1: create a temporary directory for derived data if one
        # is not set already:
        if (not config.has_option(section, derivedDataPath_option)):
            if tmpdir is None:
                workspace = config.get(section, workspace_option)
                tmpdir = tempfile.mkdtemp(prefix=workspace + ".")
            config.set(section, derivedDataPath_option, tmpdir)

        # 2: set scheme to section name if one is not given already
        if (not config.has_option(section, scheme_option)):
            config.set(section, scheme_option=section)

    # save config file
    with open(config_path, 'w') as fp:
        config.write(fp)

    # perform build
    for section in config.sections():
        if config.has_option(section, workspace_option):
            options = dict(config.items(section))
            workspace_name = options[workspace_option]
            options[workspace_option] = workspace_name + workspace_suffix
            param = ParamArray('-', FilterOut(skip_keys, options.items()))
            subprocess.call([executable] + list(param))


if __name__ == '__main__':
    main()
