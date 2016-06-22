import os
import shutil
from autotest.client import utils, test
from autotest.client.shared import error


class ltp_stress(test.test):
    version = 11

    def _import_site_config(self):
        site_config_path = os.path.join(os.path.dirname(__file__),
                                        'site_config.py')
        if os.path.exists(site_config_path):
            # for some reason __import__ with full path does not work within
            # autotest, although it works just fine on the same client machine
            # in the python interactive shell or separate testcases
            execfile(site_config_path)
            self.site_ignore_tests = locals().get('ignore_tests', [])
        else:
            self.site_ignore_tests = []

    def initialize(self):
        self._import_site_config()
        self.job.require_gcc()

    # http://sourceforge.net/projects/ltp/files/LTP%20Source/ltp-20140115/
    def setup(self, tarball='ltp-full-20150420.tar.bz2'):
        tarball = utils.unmap_url(self.bindir, tarball, self.tmpdir)
        utils.extract_tarball_to_dir(tarball, self.srcdir)
        os.chdir(self.srcdir)
        ltpbin_dir = os.path.join(self.srcdir, 'bin')
        os.mkdir(ltpbin_dir)

        # saves having lex installed
        shutil.copy(os.path.join(self.bindir, 'scan.c'),
                    os.path.join(self.srcdir, 'pan'))
        utils.configure('--prefix=%s' % ltpbin_dir)
        utils.make('-j %d all' % utils.count_cpus())
        utils.system('yes n | make SKIP_IDCHECK=1 install')

    # Note: to run a specific test, try '-f cmdfile -s test' in the
    # in the args (-f for test file and -s for the test case)
    # eg, job.run_test('ltp', '-f math -s float_bessel')
    def run_once(self, args='', script='testscripts/ltpstress.sh', ignore_tests=[]):

        ignore_tests = ignore_tests + self.site_ignore_tests

        # In case the user wants to run another test script
        if script == 'testscripts/ltpstress.sh':
            logfile = os.path.join(self.resultsdir, 'ltp.log')
            sarfile = os.path.join(self.resultsdir, 'sar.out')
            resultfile = os.path.join(self.resultsdir, 'ltp-result')
            args2 = ' -l %s -t 12 -n -p -d %s -S %s' %(logfile, sarfile, resultfile)
            args = args + ' ' + args2
        #utils.system('cd /root/autotest/client/tmp/ltp/src/bin/testscripts/')
        os.chdir(os.path.join(self.srcdir,'bin/testscripts'))
	ltpbin_dir = os.path.join(self.srcdir, 'bin')
        cmd = os.path.join(ltpbin_dir, script) + ' ' + args
        result = utils.run(cmd, ignore_status=True)

        # Look for the first line in result.stdout containing a token
        # that runltp would identify as a failure. If found, raise the
        # whole line as a reason of the test failure.
        #
        # See include/test.h and lib/test_res.c:tst_exit of LTP for
        # more information about the failure tokens.
        failed_tests = []
        for line in result.stdout.splitlines():
            if set(('TFAIL', 'TBROK', 'TWARN')).intersection(line.split()):
                test_name = line.strip().split(' ')[0]
                if (test_name not in ignore_tests and
                        test_name not in failed_tests):

                    failed_tests.append(test_name)

        if failed_tests:
            raise error.TestFail("LTP tests failed: %s" % failed_tests)
