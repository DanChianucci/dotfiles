#!/usr/bin/env python
from __future__ import print_function
import argparse
import os
import sys


def cwd(p="-L"):
    cmd = "pwd {}".format(p)
    value = os.popen(cmd).read().strip('\n')
    return value


parser = argparse.ArgumentParser()
parser.add_argument("param", help="", nargs="?")
parser.add_argument("-p", "--parent",   action="store_true", help="cd to the parent directory of the specified item")
parser.add_argument("-P", "--physical", action="store_true", help="cd through physical directory structure")
args = parser.parse_args()

param = args.param
try:
    param = int(param)
except (ValueError, TypeError):
    pass


p = "-P" if args.physical else "-L"
orig_dir = cwd(p)


if param is None:
    param = os.path.basename(orig_dir)

target = None
if isinstance(param, int):
    if param > 0:
        target = os.path.normpath(os.path.join(orig_dir, "../"*param))


if target is None:
    SEARCHDIRS = os.getenv("UPDIRS")
    if SEARCHDIRS:
        SEARCHDIRS = SEARCHDIRS.split(os.pathsep)
        for S in SEARCHDIRS:
            searchdir = os.path.expanduser(os.path.expandvars(S))
            check_path = os.path.join(searchdir, param)
            if os.path.exists(check_path):
                if os.path.isdir(check_path) and not args.parent:
                    target = check_path
                else:
                    target = searchdir


if target is None:
    currdir = orig_dir
    while os.path.dirname(currdir) != currdir:  # check if its root
        check_path = os.path.join(currdir, param)
        if os.path.exists(check_path):
            if os.path.isdir(check_path) and not args.parent:
                target = check_path
            else:
                target = currdir
            break
        else:
            currdir = os.path.normpath(os.path.join(currdir, ".."))


if target is None:
    exit(101)


print(target)