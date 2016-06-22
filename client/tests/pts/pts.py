import os
import shutil
import pexpect
import logging
from autotest.client import utils, test
from autotest.client.shared import error


class pts(test.test):
    version = 1

    def initialize(self):
        self.job.require_gcc()
	self.results = []

    # http://www.phoronix-test-suite.com/?k=downloads
    def setup(self, tarball='phoronix-test-suite-5.2.1.tar.gz'):
        tarball = utils.unmap_url(self.bindir, tarball, self.tmpdir)
        utils.extract_tarball_to_dir(tarball, self.srcdir)
	os.chdir(self.srcdir)
	utils.system('sh install-sh')
 #   utils.system('./install-sh %s' % self.srcdir)
    ptstype = os.popen('ls /root/ -a').read()
    if "phoronix-test-suite-pkg.tar.gz" in ptstype:  
        print "OK,there is the phoronix-test-suite-pkg.tar.gz" 
    else:
        utils.system('wget -nv -P /root/ http://tfs.i-soft.com.cn/TestRepos/TestTools/PTS/phoronix-test-suite-pkg.tar.gz ')
	shutil.copy(os.path.join(self.bindir,'phoronix-test-suite-pkg.tar.gz'),'/root/')
    if ".phoronix-test-suite" in ptstype:
        print "OK,it tar already!"
    else:
	    utils.system('tar xf /root/phoronix-test-suite-pkg.tar.gz -C /root/')
#	utils.system('rm -rf /root/phoronix-test-suite-pkg.tar.gz')

    def run_once(self, testname=['compiler'], do='run'):
	cmd = 'phoronix-test-suite'

	utils.system_output(cmd + ' list-available-suites',retain_output=True)	
	for test in testname:
		res_dir = test + '-result'
		des_conf = test + '-conf'
		self.results_path = os.path.join(self.resultsdir,'raw_output_%s' % test)
                if (test == 'desktop-graphics'):
			base_cmd = cmd + ' ' + do + ' ' + test
			todo = ''' <<TODO
                        y
                        ''' + res_dir + \
                        '''
                        ''' + des_conf + '''
                        
                        n                        
                        TODO'''
                        self.results = utils.system_output('export DISPLAY=:0.0;' + base_cmd + todo,
                                                        retain_output=True)
                        utils.open_write_close(self.results_path, self.results)
		else:
                	fout = open(self.results_path, 'w')
			runpts = pexpect.spawn('%s %s %s' % (cmd, do, test))
			runpts.logfile = fout
			while 1:
				index = runpts.expect(['\(Y/n\):', pexpect.EOF, pexpect.TIMEOUT])
                                print index
				logging.info("now start first expect.........")
				if index == 0 :
					break
				elif index == 1 :
					pass
				elif index == 2 :
					pass
			runpts.sendline('y')
			logging.debug(runpts.before)
			runpts.expect('under:')
			runpts.sendline(res_dir)
			logging.debug(runpts.before)
			runpts.expect('configuration:')
			runpts.sendline(des_conf)
			logging.debug(runpts.before)
			runpts.expect('Description:')
			runpts.sendline('')
			logging.debug(runpts.before)
			logging.info("now start run test..............")
			while 1:
                        	index = runpts.expect(['OpenBenchmarking.org', pexpect.EOF, pexpect.TIMEOUT])
 				index = runpts.expect(['\(Y/n\):', pexpect.EOF, pexpect.TIMEOUT])
                        	if index == 0 :
                                	break
                        	elif index == 1 :
                                	pass
                        	elif index == 2 :
                                	pass
			runpts.sendline('n')
			logging.debug(runpts.before)
			runpts.expect(pexpect.EOF)
			fout.close()

    def postprocess(self):
        # Get the results:         
        os.chdir(self.srcdir)
        outputdir = "/root/.phoronix-test-suite/test-results"
        utils.system('cp -a ' + outputdir + '/*  ' +  self.resultsdir)
	#utils.system('rm -rf /root/.phoronix-test-suite')


