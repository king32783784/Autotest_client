import os
import shutil
import logging
import time
from autotest.client import test, utils

class netperf2(test.test):
    version = 1

    # ftp://ftp.netperf.org/netperf/netperf-2.6.0.tar.bz2
    def setup(self, tarball='netperf-2.6.0.tar.bz2'):
        self.job.require_gcc()
        tarball = utils.unmap_url(self.bindir, tarball, self.tmpdir)
        utils.extract_tarball_to_dir(tarball, self.srcdir)
        os.chdir(self.srcdir)

        utils.configure()
        utils.make()
        utils.system('sync')
        utils.system('echo 3 >/proc/sys/vm/drop_caches')

    def initialize(self):
        #self.server_prog = '%s&' % os.path.join(self.srcdir, 'src/netserver')
        self.client_prog = '%s' % os.path.join(self.srcdir, 'src/netperf')
        self.valid_tests = ['TCP_STREAM', 'TCP_MAERTS', 'TCP_RR', 'TCP_CRR',
                            'TCP_SENDFILE', 'UDP_STREAM', 'UDP_RR']

        getos = '''cat /etc/issue |awk '{print $2}' '''
        testos = utils.system_output(getos, retain_output=True)
        if (testos == 'Client'):
                shutil.copy(os.path.join(self.bindir,'protocols'),'/etc/')

    def run_once(self, server_ip, tests=['TCP_STREAM'], stream_list=[1],
                 test_time=60, args=''):
	#time.sleep(60)
	for num_streams in stream_list:
                for test in tests:
                        os.system('echo 3 > /proc/sys/vm/drop_caches')
                        logging.info("clean the caches........")
                        logging.info("===========Start %s test===============" % test)
                        self.client(server_ip, test, test_time, num_streams, args)
                        time.sleep(5)

    def client(self, server_ip, test, test_time, num_streams, args):
        run_args = '-H %s -t %s -l %d' % (server_ip, test, test_time)
	self.results_path = os.path.join(self.resultsdir,'netperf_output_%s_%s' % (test, self.iteration))
        # Append the test specific arguments.
        if args:
            run_args += ' ' + args
        
	cmd = '%s %s' % (self.client_prog, run_args)
        self.results = utils.system_output(cmd, retain_output=True)
	utils.open_write_close(self.results_path, self.results)


