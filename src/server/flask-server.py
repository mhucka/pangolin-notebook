#! /usr/bin/python
## ============================================================================
## Description : Flask config to run Pandoc and check in the results to GitHub
## Author(s)   : Michael Hucka <mhucka@caltech.edu>
## Organization: California Institute of Technology
## Date created: 2014-01-24
## Source      : https://github.com/mhucka/hamocs
## ============================================================================
##
## This is used to automatically regenerate the HTML formatted output seen at
##   http://mhucka.github.io/hamocs/
## It needs the GitHub repository to be configured such that every commit hits
## a web hook (https://help.github.com/articles/creating-webhooks).  The target
## of the web hook should be the server at which this Flask script is
## listening, at the port configured below (9005) and the URL path below
## ("/hamocs-make").
##
## This outputs diagnostic messages and process output to "flask.log".

import os, logging, sys
from flask import Flask, Response, render_template
from subprocess import check_call, call, STDOUT
from contextlib import contextmanager

#
# Configuration variables.
#

HOME      = "/home/mhucka/hamocs"
REPO_DIR  = HOME + "/git-repo"
PAGES_DIR = REPO_DIR + "/gh-pages"
LOG_FILE  = HOME + "/flask.log"

MAKE_URI  = '/hamocs-make'
LOG_URI   = '/hamocs-log'
PORT      = 9005

#
# Global variables -- not for configuration.
#

app      = Flask(__name__)
logger   = logging.getLogger(__name__)
outlog   = STDOUT

#
# Body.
#

@contextmanager
def pushd(new_dir):
    # Found this code at http://stackoverflow.com/a/13847807/743730
    prev_dir = os.getcwd()
    os.chdir(new_dir)
    yield
    os.chdir(prev_dir)


def do_update():
    global outlog

    with pushd(REPO_DIR):
        check_call('git pull', stdout=outlog, stderr=outlog, shell=True)
        check_call('make handbook', stdout=outlog, stderr=outlog, shell=True)
        with pushd(PAGES_DIR):
            # gh-pages is a separate clone, so need to do git pull separately.
            call('git pull origin', stdout=outlog, stderr=outlog, shell=True)
            call('git add *.html', stdout=outlog, stderr=outlog, shell=True)
            call('git commit -a -m "Latest version."', shell=True, stderr=outlog, stdout=outlog)
            call('git push origin gh-pages', shell=True, stderr=outlog, stdout=outlog)
    return 'OK'


def configure_logging():
    global logger, outlog

    logger.setLevel(logging.DEBUG)
    handler = logging.FileHandler(LOG_FILE)
    formatter = logging.Formatter('%(asctime)s [%(levelname)s] %(message)s')
    handler.setFormatter(formatter)
    app.logger.addHandler(handler)
    outlog = handler.stream
    sys.stdout = outlog
    sys.stderr = outlog


@app.route(MAKE_URI, methods=['GET', 'POST'])
def handle_make():
    global logger
    logger.info('Update called')
    return do_update()


@app.route(LOG_URI, methods=['GET', 'POST'])
def handle_show_log():
    global logger
    logger.info('Displaying log')
    stream = open(LOG_FILE, 'r')
    contents = stream.read()
    stream.close()
    return '<html><body><pre>' + contents + '</pre></body></html>'


def run_flask():
    global PORT
    app.run(host='0.0.0.0', port=PORT)


#
# Main.
#

if __name__ == '__main__':
    print('All output is redirected to ' + LOG_FILE)
    configure_logging()
    logger.info('Starting')
    run_flask()
    logger.info('Stopping')
