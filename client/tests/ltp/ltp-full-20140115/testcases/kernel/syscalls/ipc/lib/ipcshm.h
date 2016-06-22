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
 * ipcshm.h - common definitions for the IPC shared memory tests
 */

#ifndef __IPCSHM_H
#define __IPCSHM_H

#include <errno.h>
#include <wait.h>
#include <sys/ipc.h>
#include <sys/shm.h>

#include "test.h"
#include "usctest.h"

void cleanup(void);
void setup(void);

#define SHM_RD	0400
#define SHM_WR	0200
#define SHM_RW	SHM_RD | SHM_WR

#define SHM_SIZE	2048	/* a resonable size for a memory segment */
#define INT_SIZE	4	/* instead of sizeof(int) */

#define MODE_MASK	0x01FF	/* to get the lower nine permission bits */
				/* from shmid_ds.ipc_perm.mode		 */

key_t shmkey;			/* an IPC key generated by ftok() */

void rm_shm(int shm_id);
void check_root();

int getipckey();
int getuserid(char*);

#endif /* ipcshm.h */
