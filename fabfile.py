'''
Deploy Environment and Site
'''

from fabric.api import *
from fabric.contrib.project import rsync_project
from contextlib import contextmanager

import os.path

env.www_host = 'prod@a.app.ohess.org'
env.build_path = '/srv/www/ohess'
env.env_path = '/srv/www/envs/bootstrap'
env.shell = '/bin/sh -c'

@task
@hosts(env.www_host)
def test():
    with localenv():
        run('perl -v')

@task
@hosts(env.www_host)
def bootstrap():
    '''Bootstrap environment'''
    if not exists(env.build_path):
        run('mkdir -p {build_path}'.format(**env))
    if not exists(env.env_path):
        run('mkdir -p {env_path}/{{lib,bin}}'.format(**env))
    with cd(env.env_path):
        env.cpanm = '{env_path}/bin/cpanm'.format(**env)
        if not exists(env.cpanm):
            run('curl -Lko {cpanm} http://cpanmin.us'.format(**env))
            run('chmod +x {cpanm}'.format(**env))
        run('{cpanm} -nL . ExtUtils::MakeMaker Module::Build'.format(**env))
        run('{cpanm} -nL . Module::Install'.format(**env))
        run('{cpanm} -L . App::cpanminus'.format(**env))
        run('{cpanm} -L . App::local::lib::helper'.format(**env))
        run('{cpanm} -nL . carton'.format(**env))

@task
@hosts(env.www_host)
def deploy():
    '''Deploy master'''
    rsync_project(
        env.build_path,
        './',
        exclude=[
            '*.pyc',
            '.git',
            'local/',
        ]
    )
    with localenv():
        with cd(env.build_path):
            run('carton install')
    # TODO replace with twiggy reload
    #sudo('/etc/init.d/lighttpd reload')
    #run("varnishadm -T :2000 'url.purge .'")

@contextmanager
def localenv():
    '''Context manager for local::lib'''
    with settings(shell='{env_path}/bin/localenv /bin/sh -c'.format(**env)):
        yield

def exists(path):
    '''Same as the contrib.files.exists, only with a different test'''
    with settings(hide('everything'), warn_only=True):
        return not run('test -e "%s"' % path).failed

