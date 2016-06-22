import os
import time
import re
import pwd
import logging
from autotest.client import test, utils
from autotest.client.shared import error


class sysbench(test.test):
    version = 1

    def initialize(self):
        self.job.require_gcc()
        self.results = []

    # http://osdn.dl.sourceforge.net/sourceforge/sysbench/sysbench-0.4.12.tar.gz
    def setup(self, test_type='memory', tarball='sysbench-0.4.12.tar.gz'):
        tarball = utils.unmap_url(self.bindir, tarball, self.tmpdir)
        utils.extract_tarball_to_dir(tarball, self.srcdir)

        os.chdir(self.srcdir)

    def run_once(self, test_type='mysql', num_threads=[4], table_size=100,
		 db_pw='', runtimes=1, read_only=0, block_size='512',
		 total_size='1G', args=''):

        if (test_type == 'mysql'):
		utils.system('yum -y install mysql mysql-server mysql-devel')
		os.chdir(self.srcdir)
                # configure wants to get config, so install it
                utils.configure('--with-mysql-includes=/usr/include/mysql --with-mysql-libs=/usr/lib64/mysql')
		utils.system('./autogen.sh')
        	utils.make('LIBTOOL=/usr/bin/libtool')
        	utils.make('LIBTOOL=/usr/bin/libtool install')
		self.execute_mysql(num_threads, db_pw, table_size, runtimes, read_only, args)
	elif (test_type == 'memory'):
		os.chdir(self.srcdir)
		utils.configure('--without-mysql')
		utils.system('./autogen.sh')
        	utils.make('LIBTOOL=/usr/bin/libtool')
        	utils.make('LIBTOOL=/usr/bin/libtool install')
		self.execute_mem(num_threads, runtimes, block_size, total_size, args)

    def execute_mem(self, num_threads, runtimes, block_size, total_size, args):
	
	
	base_cmd = self.srcdir + '/sysbench/sysbench --test=memory'
	
	for num_thread in num_threads:
		for run in range(1,runtimes+1):
			utils.system('echo 3 > /proc/sys/vm/drop_caches')
                        logging.info("clean caches....")
			logging.info("==============Start sysbench memory %d threads test for %dth =======" % (num_thread,run))
			rcmd = base_cmd + ' --num-threads=' + str(num_thread) + \
					' --memory-block-size=' + block_size + \
					' --memory-total-size='	+ total_size
			self.results = utils.system_output(rcmd + ' run',retain_output=True)
			self.results_path = os.path.join(self.resultsdir,
                                         'raw_output_%d_%d' % (num_thread,run))
                        utils.open_write_close(self.results_path, self.results)

    def execute_mysql(self, num_threads, db_pw, table_size, runtimes, read_only, args):

	utils.system('service mysqld restart')
        # Wait for database to start
        time.sleep(5)

        try:
            base_cmd = self.srcdir + '/sysbench/sysbench --test=oltp ' + \
                                     '--mysql-user=root --mysql-table-engine=innodb ' + \
				     '--mysql-host=localhost --mysql-password=' + db_pw + \
				     ' --mysql-socket=/var/lib/mysql/mysql.sock ' + \
				     '--oltp-table-size=' + str(table_size)
	    
	    for num_thread in num_threads:
            	utils.system('echo "create database sbtest;" | ' + 'mysql -u root -p%s' % db_pw)
            	pcmd = base_cmd + ' prepare'
            	utils.system(pcmd)
		for run in range(1,runtimes+1):
	        	logging.info("===============Start sysbench %d threads test for %dth============" % (num_thread,run))
            		rcmd = base_cmd + \
                		' --num-threads=' + str(num_thread) + \
                		' --mysql-db=sbtest --mysql-engine-trx=yes' + \
                		' --db-ps-mode=disable'

            		if read_only:
                		rcmd = rcmd + ' --oltp-read-only=on'

            		self.results = utils.system_output(rcmd + ' run',
                                                    retain_output=True)
			self.results_path = os.path.join(self.resultsdir,
                                         'raw_output_%d_%d' % (num_thread,run))
			utils.open_write_close(self.results_path, self.results)

	        utils.system(base_cmd + ' cleanup')
		utils.system('echo "drop database sbtest;" | ' + 'mysql -u root -p%s' % db_pw)

        except Exception:
    	    ccmd = base_cmd + ' cleanup'
            utils.system(ccmd)
            utils.system('echo "drop database sbtest;" | ' + 'mysql -u root -p%s' % db_pw)
            raise

    def postprocess(self):
        self.__format_results("\n".join(self.results))

    def __format_results(self, results):
        threads = 0
        tps = 0

        out = open(self.resultsdir + '/keyval', 'w')
        for line in results.split('\n'):
            threads_re = re.search('Number of threads: (\d+)', line)
            if threads_re:
                threads = threads_re.group(1)

            tps_re = re.search('transactions:\s+\d+\s+\((\S+) per sec.\)', line)
            if tps_re:
                tps = tps_re.group(1)
                break

        out.write('threads=%s\ntps=%s' % (threads, tps))
        out.close()
