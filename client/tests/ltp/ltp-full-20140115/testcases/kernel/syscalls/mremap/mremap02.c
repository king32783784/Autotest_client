/*
 *
 *   Copyright (c) International Business Machines  Corp., 2001
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
 */

/*
 * Test Name: mremap02
 *
 * Test Description:
 *  Verify that,
 *   mremap() fails when used to expand the existing virtual memory mapped
 *   region to the requested size, if the virtual memory area previously
 *   mapped was not page aligned or invalid argument specified.
 *
 * Expected Result:
 *  mremap() should return -1 and set errno to EINVAL.
 *
 * Algorithm:
 *  Setup:
 *   Setup signal handling.
 *   Pause for SIGUSR1 if option specified.
 *
 *  Test:
 *   Loop if the proper options are given.
 *   Execute system call
 *   Check return code, if system call failed (return=-1)
 *	if errno set == expected errno
 *		Issue sys call fails with expected return value and errno.
 *	Otherwise,
 *		Issue sys call fails with unexpected errno.
 *   Otherwise,
 *	Issue sys call returns unexpected value.
 *
 *  Cleanup:
 *   Print errno log and/or timing stats if options given
 *
 * Usage:  <for command-line>
 *  mremap02 [-c n] [-e] [-i n] [-I x] [-P x] [-t]
 *     where,  -c n : Run n copies concurrently.
 *	       -e   : Turn on errno logging.
 *	       -i n : Execute test n times.
 *	       -I x : Execute test for x seconds.
 *	       -p x : Pause for x seconds between iterations.
 *	       -t   : Turn on syscall timing.
 *
 * HISTORY
 *	07/2001 Ported by Wayne Boyer
 *
 *      11/09/2001 Manoj Iyer (manjo@austin.ibm.com)
 *      Modified.
 *      - #include <linux/mman.h> should not be included as per man page for
 *        mremap, #include <sys/mman.h> alone should do the job. But inorder
 *        to include definition of MREMAP_MAYMOVE defined in bits/mman.h
 *        (included by sys/mman.h) __USE_GNU needs to be defined.
 *        There may be a more elegant way of doing this...
 *
 *
 * RESTRICTIONS:
 *  None.
 */
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#define __USE_GNU
#include <sys/mman.h>
#undef __USE_GNU

#include "test.h"
#include "usctest.h"

char *TCID = "mremap02";
int TST_TOTAL = 1;
char *addr;			/* addr of memory mapped region */
int memsize;			/* memory mapped size */
int newsize;			/* new size of virtual memory block */
int exp_enos[] = { EINVAL, 0 };

void setup();			/* Main setup function of test */
void cleanup();			/* cleanup function for the test */

int main(int ac, char **av)
{
	int lc;
	char *msg;

	if ((msg = parse_opts(ac, av, NULL, NULL)) != NULL)
		tst_brkm(TBROK, NULL, "OPTION PARSING ERROR - %s", msg);

	setup();

	/* set the expected errnos... */
	TEST_EXP_ENOS(exp_enos);

	for (lc = 0; TEST_LOOPING(lc); lc++) {

		tst_count = 0;

		/*
		 * Attempt to expand the existing mapped
		 * memory region (memsize) by newsize limits using
		 * mremap() should fail as old virtual address is not
		 * page aligned.
		 */
		errno = 0;
		addr = mremap(addr, memsize, newsize, MREMAP_MAYMOVE);
		TEST_ERRNO = errno;

		/* Check for the return value of mremap() */
		if (addr != MAP_FAILED) {
			tst_resm(TFAIL,
				 "mremap returned invalid value, expected: -1");

			/* Unmap the mapped memory region */
			if (munmap(addr, newsize) != 0) {
				tst_brkm(TBROK, cleanup, "munmap fails to "
					 "unmap the expanded memory region, "
					 "error=%d", errno);
			}
			continue;
		}

		TEST_ERROR_LOG(TEST_ERRNO);

		if (errno == EINVAL) {
			tst_resm(TPASS, "mremap() Failed, 'invalid argument "
				 "specified' - errno %d", TEST_ERRNO);
		} else {
			tst_resm(TFAIL, "mremap() Failed, "
				 "'Unexpected errno %d", TEST_ERRNO);
		}
	}

	cleanup();
	tst_exit();

}

/*
 * setup() - performs all ONE TIME setup for this test.
 *
 * Get system page size, Set the size of virtual memory area and the
 * new size after resize, Set the virtual memory address such that it
 * is not aligned.
 */
void setup()
{

	tst_sig(FORK, DEF_HANDLER, cleanup);

	TEST_PAUSE;

	/* Get the system page size */
	if ((memsize = getpagesize()) < 0) {
		tst_brkm(TFAIL, NULL,
			 "getpagesize() fails to get system page size");
	}

	/* Get the New size of virtual memory block after resize */
	newsize = (memsize * 2);

	/* Set the old virtual memory address */
	addr = (char *)(addr + (memsize - 1));
}

/*
 * cleanup() - performs all ONE TIME cleanup for this test at
 *             completion or premature exit.
 */
void cleanup()
{
	/*
	 * print timing stats if that option was specified.
	 * print errno log if that option was specified.
	 */
	TEST_CLEANUP;

	/* Exit the program */

}
