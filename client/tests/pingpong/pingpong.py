#update by panpan.zhao 2015.6.28;add support for isoft client test

import os
import re
from autotest.client import test, utils
from autotest.client.net import net_utils
from autotest.client.shared import error

class pingpong(test.test):
	version=1
	
	def setup(self, tarball='pingpong.tar.gz', table=16):
            self.job.require_gcc()
            tarball = utils.unmap_url(self.bindir, tarball, self.tmpdir)
            utils.extract_tarball_to_dir(tarball, self.srcdir)
	    if (table == 16): 
	    	os.chdir(self.srcdir)
            	utils.system('patch -p0 < %s' %
                     os.path.join(self.bindir, 'Runtest.patch'))
	
	def run_once(self,runtimes=1):

	    self.pingpong(runtimes)

	def pingpong(self, runtimes):
	    os.chdir(self.srcdir)

	    utils.system('./RunTest.sh ' + str(runtimes))
	    
	def postprocess(self):
            # Get the results:         
            os.chdir(self.srcdir)
            outputdir = self.srcdir + "/results"
            utils.system('cp -a ' + outputdir + '/*  ' +  self.resultsdir)


	    
