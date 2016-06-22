# History
# 2014.0929  li.wang  Add support for remote 2D/3D testing
#2015.6.28  panpan.zhao update code for isoft client test.

import os
import re
from autotest.client import test, utils
from autotest.client.shared import error


class unixbench5(test.test):

    """
    This test measure system wide performance by running the following tests:
      - Dhrystone - focuses on string handling.
      - Whetstone - measure floating point operations.
      - Execl Throughput - measure the number of execl calls per second.
      - File Copy
      - Pipe throughput
      - Pipe-based context switching
      - Process creation - number of times a process can fork and reap
      - Shell Scripts - number of times a process can start and reap a script
      - System Call Overhead - estimates the cost of entering and leaving the
        kernel.
      - Graphical Tests - Both 2D and 3D graphical tests are provided.

    @see: http://code.google.com/p/byte-unixbench/
    @author: Dale Curtis <dalecurtis@google.com>
    """
    version = 5

    def initialize(self):
        self.job.require_gcc()
        self.err = []

    def setup(self, tarball='UnixBench5.1.3.tgz', args=''):
        """
        Compiles unixbench.

        @tarball: Path or URL to a unixbench tarball
        @see: http://byte-unixbench.googlecode.com/files/unixbench-5.1.3.tgz
        """
        tarball = utils.unmap_url(self.bindir, tarball, self.tmpdir)
        utils.extract_tarball_to_dir(tarball, self.srcdir)
        os.chdir(self.srcdir)
        if 'graphics' in args or 'gindex' in args:
            utils.system('patch -p1 < %s/Makefile.patch' % self.bindir)
        utils.make()

    def run_once(self, args=''):

        vars = 'UB_TMPDIR="%s" UB_RESULTDIR="%s"' % (self.tmpdir,
                                                     self.resultsdir)
        os.chdir(self.srcdir)
        if not args:
            args = 'gindex'
      
        self.report_data = utils.system_output('export DISPLAY=:0.0;'+ vars + ' ./Run ' + args)
        self.results_path = os.path.join(self.resultsdir,
                                         'raw_output_%s' % self.iteration)
        utils.open_write_close(self.results_path, self.report_data)
        if self.iteration == 3 :
            os.chdir(self.bindir)
            utils.system('./unixbench.sh')

 
""" Here is a sample output:

   #    #  #    #  #  #    #          #####   ######  #    #   ####   #    #
   #    #  ##   #  #   #  #           #    #  #       ##   #  #    #  #    #
   #    #  # #  #  #    ##            #####   #####   # #  #  #       ######
   #    #  #  # #  #    ##            #    #  #       #  # #  #       #    #
   #    #  #   ##  #   #  #           #    #  #       #   ##  #    #  #    #
    ####   #    #  #  #    #          #####   ######  #    #   ####   #    #

   Version 5.1.2                      Based on the Byte Magazine Unix Benchmark

   Multi-CPU version                  Version 5 revisions by Ian Smith,
                                      Sunnyvale, CA, USA
   December 22, 2007                  johantheghost at yahoo period com


1 x Dhrystone 2 using register variables  1 2 3 4 5 6 7 8 9 10

1 x Double-Precision Whetstone  1 2 3 4 5 6 7 8 9 10

1 x Execl Throughput  1 2 3

1 x File Copy 1024 bufsize 2000 maxblocks  1 2 3

1 x File Copy 256 bufsize 500 maxblocks  1 2 3

1 x File Copy 4096 bufsize 8000 maxblocks  1 2 3

1 x Pipe Throughput  1 2 3 4 5 6 7 8 9 10

1 x Pipe-based Context Switching  1 2 3 4 5 6 7 8 9 10

1 x Process Creation  1 2 3

1 x System Call Overhead  1 2 3 4 5 6 7 8 9 10

1 x Shell Scripts (1 concurrent)  1 2 3

1 x Shell Scripts (8 concurrent)  1 2 3

1 x 2D graphics: rectangles  1 2 3

1 x 2D graphics: ellipses  1 2 3

1 x 2D graphics: aa polygons  1 2 3

1 x 2D graphics: text  1 2 3

1 x 2D graphics: images and blits  1 2 3

1 x 2D graphics: windows  1 2 3

1 x 3D graphics: gears  1 2 3

========================================================================
   BYTE UNIX Benchmarks (Version 5.1.2)

   System: loongson: GNU/Linux
   OS: GNU/Linux -- 3.16.0-32-lemote -- #1 SMP PREEMPT Wed Oct 15 13:17:18 CST 2014
   Machine: mips (unknown)
   Language: en_US.utf8 (charmap="UTF-8", collate="UTF-8")
   15:23:24 up 46 min,  3 users,  load average: 0.29, 0.08, 0.07; runlevel unknown

------------------------------------------------------------------------
Benchmark Run: Tue Oct 28 2014 15:23:24 - 16:14:50
0 CPUs in system; running 1 parallel copy of tests

2D graphics: aa polygons                        537.7 score (54.0 s, 2 samples)
2D graphics: ellipses                           237.1 score (56.2 s, 2 samples)
2D graphics: images and blits                 12435.9 score (63.2 s, 2 samples)
2D graphics: rectangles                        1166.5 score (124.1 s, 2 samples)
2D graphics: text                              8428.0 score (32.5 s, 2 samples)
2D graphics: windows                             26.8 score (62.3 s, 2 samples)
3D graphics: gears                               60.6 fps   (20.0 s, 2 samples)
Dhrystone 2 using register variables        2058589.5 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                      431.0 MWIPS (9.9 s, 7 samples)
Execl Throughput                                581.7 lps   (29.8 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks         91295.5 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks           28449.0 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks        131032.7 KBps  (30.0 s, 2 samples)
Pipe Throughput                              198496.0 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                  53321.6 lps   (10.0 s, 7 samples)
Process Creation                               1599.9 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                    474.4 lpm   (60.1 s, 2 samples)
Shell Scripts (8 concurrent)                    178.4 lpm   (60.2 s, 2 samples)
System Call Overhead                         276984.2 lps   (10.0 s, 7 samples)

2D Graphics Benchmarks Index Values          BASELINE       RESULT    INDEX
2D graphics: aa polygons                         15.0        537.7    358.5
2D graphics: ellipses                            15.0        237.1    158.1
2D graphics: images and blits                    15.0      12435.9   8290.6
2D graphics: rectangles                          15.0       1166.5    777.7
2D graphics: text                                15.0       8428.0   5618.7
2D graphics: windows                             15.0         26.8     17.9
                                                                   ========
2D Graphics Benchmarks Index Score                                    576.6

System Benchmarks Index Values               BASELINE       RESULT    INDEX
Dhrystone 2 using register variables         116700.0    2058589.5    176.4
Double-Precision Whetstone                       55.0        431.0     78.4
Execl Throughput                                 43.0        581.7    135.3
File Copy 1024 bufsize 2000 maxblocks          3960.0      91295.5    230.5
File Copy 256 bufsize 500 maxblocks            1655.0      28449.0    171.9
File Copy 4096 bufsize 8000 maxblocks          5800.0     131032.7    225.9
Pipe Throughput                               12440.0     198496.0    159.6
Pipe-based Context Switching                   4000.0      53321.6    133.3
Process Creation                                126.0       1599.9    127.0
Shell Scripts (1 concurrent)                     42.4        474.4    111.9
Shell Scripts (8 concurrent)                      6.0        178.4    297.3
System Call Overhead                          15000.0     276984.2    184.7
                                                                   ========
System Benchmarks Index Score                                         159.8

3D Graphics Benchmarks Index Values          BASELINE       RESULT    INDEX
3D graphics: gears                               33.4         60.6     18.2
                                                                   ========
3D Graphics Benchmarks Index Score                                     18.2
"""
