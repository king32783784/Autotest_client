/******************************************************************************
 *
 *   Copyright (c) International Business Machines  Corp., 2006
 *
 *   This program is free software;  you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
 *   the GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program;  if not, write to the Free Software
 *   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *
 * NAME
 *      fstatat01.c
 *
 * DESCRIPTION
 *	This test case will verify basic function of fstatat64/newfstatat
 *	added by kernel 2.6.16 or up.
 *
 * USAGE:  <for command-line>
 * fstatat01 [-c n] [-e] [-i n] [-I x] [-P x] [-t] [-p]
 * where:
 *      -c n : Run n copies simultaneously.
 *      -e   : Turn on errno logging.
 *      -i n : Execute test n times.
 *      -I x : Execute test for x seconds.
 *      -p   : Pause for SIGUSR1 before starting
 *      -P x : Pause for x seconds between iterations.
 *      -t   : Turn on syscall timing.
 *
 * Author
 *	Yi Yang <yyangcdl@cn.ibm.com>
 *
 * History
 *      08/24/2006      Created first by Yi Yang <yyangcdl@cn.ibm.com>
 *
 *****************************************************************************/

#define _GNU_SOURCE

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <fcntl.h>
#include <error.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include "test.h"
#include "usctest.h"
#include "linux_syscall_numbers.h"

#define TEST_CASES 6
#ifndef AT_FDCWD
#define AT_FDCWD -100
#endif
void setup();
void cleanup();
void setup_every_copy();

char *TCID = "fstatat01";
int TST_TOTAL = TEST_CASES;
char pathname[256];
char testfile[256];
char testfile2[256];
char testfile3[256];
int dirfd, fd, ret;
int fds[TEST_CASES];
char *filenames[TEST_CASES];
int expected_errno[TEST_CASES] = { 0, 0, ENOTDIR, EBADF, EINVAL, 0 };
int flags[TEST_CASES] = { 0, 0, 0, 0, 9999, 0 };

/* TODO (garrcoop): properly port to fstatat64. */
#if (defined __NR_fstatat64) && (__NR_fstatat64 != 0)
struct stat64 statbuf;
#else
struct stat statbuf;
#endif

/*
 * XXX (garrcoop): NO NO NO NO NO NO NO NO NO ... use linux_syscall_numbers.h!
 */
/* __NR_fstatat64 and __NR_fstatat64 if not defined are ALWAYS stubbed by
 *  linux_syscall_numbers.h Need to check for 0 to avoid testing with stubs */
#if (defined __NR_fstatat64) && (__NR_fstatat64 != 0)
int myfstatat(int dirfd, const char *filename, struct stat64 *statbuf,
	      int flags)
{
	return ltp_syscall(__NR_fstatat64, dirfd, filename, statbuf, flags);
}
#elif (defined __NR_newfstatat) && (__NR_newfstatat != 0)
int myfstatat(int dirfd, const char *filename, struct stat *statbuf, int flags)
{
	return ltp_syscall(__NR_newfstatat, dirfd, filename, statbuf, flags);
}
#else
/* stub - will never run */
int myfstatat(int dirfd, const char *filename, struct stat *statbuf, int flags)
{
	return ltp_syscall(0, dirfd, filename, statbuf, flags);
}
#endif

int main(int ac, char **av)
{
	int lc;
	char *msg;
	int i;

	if ((tst_kvercmp(2, 6, 16)) < 0)
		tst_brkm(TCONF, NULL,
			 "This test can only run on kernels that are 2.6.16 and "
			 "higher");

	if ((msg = parse_opts(ac, av, NULL, NULL)) != NULL)
		tst_brkm(TBROK, NULL, "OPTION PARSING ERROR - %s", msg);

	setup();

	for (lc = 0; TEST_LOOPING(lc); lc++) {
		setup_every_copy();

		tst_count = 0;

		for (i = 0; i < TST_TOTAL; i++) {
			TEST(myfstatat
			     (fds[i], filenames[i], &statbuf, flags[i]));

			if (TEST_ERRNO == expected_errno[i]) {

				if (STD_FUNCTIONAL_TEST)
					tst_resm(TPASS | TTERRNO,
						 "fstatat failed as expected");
			} else
				tst_resm(TFAIL | TTERRNO, "fstatat failed");
		}

	}

	cleanup();
	tst_exit();
}

void setup_every_copy()
{
	/* Initialize test dir and file names */
	sprintf(pathname, "fstatattestdir%d", getpid());
	sprintf(testfile, "fstatattestfile%d.txt", getpid());
	sprintf(testfile2, "fstatattestdir%d/fstatattestfile%d.txt", getpid(),
		getpid());
	/* XXX (garrcoop): WTF NO. tst_tmpdir!!!! */
	sprintf(testfile3, "/tmp/fstatattestfile%d.txt", getpid());

	ret = mkdir(pathname, 0700);
	if (ret < 0) {
		perror("mkdir");
		exit(1);
	}

	dirfd = open(pathname, O_DIRECTORY);
	if (dirfd < 0) {
		perror("open");
		exit(1);
	}

	fd = open(testfile, O_CREAT | O_RDWR, 0600);
	if (fd < 0) {
		perror("open");
		exit(1);
	}

	fd = open(testfile2, O_CREAT | O_RDWR, 0600);
	if (fd < 0) {
		perror("open");
		exit(1);
	}

	fd = open(testfile3, O_CREAT | O_RDWR, 0600);
	if (fd < 0) {
		perror("open");
		exit(1);
	}

	fds[0] = fds[1] = fds[4] = dirfd;
	fds[2] = fd;
	fds[3] = 100;
	fds[5] = AT_FDCWD;

	filenames[0] = filenames[2] = filenames[3] = filenames[4] =
	    filenames[5] = testfile;
	filenames[1] = testfile3;
}

void setup()
{

	tst_sig(NOFORK, DEF_HANDLER, cleanup);

	TEST_PAUSE;
}

void cleanup()
{
	unlink(testfile2);
	unlink(testfile3);
	unlink(testfile);
	rmdir(pathname);

	TEST_CLEANUP;
}
