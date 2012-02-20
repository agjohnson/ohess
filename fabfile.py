'''
Deploy Environment and Site
'''

from fabric.api import *
from contextlib import contextmanager

import os.path

env.www_host = "a.app.ohess.org"
env.build_path = "www/ohess"
env.env_path = "%(build_path)s/local" % env
env.shell = "/bin/bash -l -c"

@task
@hosts(env.www_host)
def bootstrap():
    '''Bootstrap environment'''
    if not exists(env.build_path):
        run("mkdir -p %(build_path)s" % env)
    if not exists(env.env_path):
        run("mkdir -p %(env_path)s/{lib,bin}" % env)
    with cd(env.build_path):
        if not exists('local/bin/cpanm'):
            run("curl -Lko local/bin/cpanm 'http://cpanmin.us'")
            run("chmod +x local/bin/cpanm")
        run("local/bin/cpanm -l local App::cpanminus")
        run("local/bin/cpanm -l local App::local::lib::helper")
        run("local/bin/cpanm -l local Module::Install Carton")

@task
@hosts(env.www_host)
def deploy():
    '''Deploy master'''
    with cd(env.build_path):
        run('git pull')
    with localenv():
        run('local/bin/cpanm https://github.com/agjohnson/avocado/tarball/master')
        run('local/bin/carton install')

@contextmanager
def localenv():
    '''Context manager for local::lib'''
    with cd(env.env_path):
        with prefix('bin/localenv'):
            yield

def exists(path):
    '''Same as the contrib.files.exists, only with a different test'''
    with settings(hide('everything'), warn_only=True):
        return not run("test -e '%s'" % path).failed

