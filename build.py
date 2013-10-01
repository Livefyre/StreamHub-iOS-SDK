#!/usr/bin/env python2

import re
import os
import subprocess
import tempfile
import ConfigParser


def DirectoryOfThisScript():
    return os.path.dirname(os.path.abspath(__file__))


def PrefixAllKeys(prefix, args):
    # given a list of tuples where 1st element is a key and 2nd elment is a
    # value, prefix all keys with a particular prefix string
    return (arg for t in args for arg in [prefix + t[0], t[1]])


def DropPairs(forKeys, args):
    # given a list of tuples where 1st element is a key and 2nd element is a
    # value, drop all tuples whose keys match thos in the dropKeys list
    pattern = '^(' + '|'.join(re.escape(key) for key in forKeys) + ')$'
    return (t for t in args if not re.match(pattern, t[0]))


def PrefixPaths(forKeys, root, args):
    # given a list of tuples where 1st element is a key and 2nd element is a
    # value, prefix those values which correspond to keys in forKeys list
    pattern = '^(' + '|'.join(re.escape(key) for key in forKeys) + ')$'
    for t in args:
        if (re.match(pattern, t[0]) and not os.path.isabs(t[1])):
            yield (t[0], os.path.join(root, t[1]))
        else:
            yield t


def main():
    # read config file
    executable = 'xcodebuild'
    derivedDataPath_option = 'derivedDataPath'
    scheme_option = 'scheme'
    workspace_option = 'workspace'
    workspace_suffix = '.xcworkspace'
    skip_keys = ['target', 'project', 'product']
    path_keys = ['workspace', 'derivedDataPath']
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
            param = PrefixAllKeys('-',
                        PrefixPaths(path_keys, os.path.join(script_dir, ''),
                            DropPairs(skip_keys, options.items())))
            subprocess.call([executable] + list(param))


if __name__ == '__main__':
    main()
