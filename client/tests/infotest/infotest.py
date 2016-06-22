'''
   AUTHOR = lp
   Automatic crawling system hardware and core components information
'''

import os
import re
from autotest.client import test, utils
from autotest.client.net import net_utils
from autotest.client.shared import error

class infotest(test.test):
	version=1
	
	def setup(self, tarball='infotest1.0.tar.gz'):
            self.job.require_gcc()
            tarball = utils.unmap_url(self.bindir, tarball, self.tmpdir)
            utils.extract_tarball_to_dir(tarball, self.srcdir)
	
	def run_once(self):

	    self.infotest()

	def infotest(self):
	    os.chdir(self.srcdir)

	    utils.system('sh sysinfo.sh ' )
	    
	def postprocess(self):
            # Get the results:         
            os.chdir(self.srcdir)
            outputdir = self.srcdir 
            utils.system('mv ' + outputdir + '/*info  ' +  self.resultsdir)

	    
