/*
 * pp32.c: ping-pong threads benchmark
 *
 * gcc -O2 -pthread pp32.c -o pp32
 */

#include <pthread.h>
#include <stdlib.h>
#include <strings.h>
#include <stdio.h>
#include <time.h>
#include <sys/time.h>
#include <sys/mman.h>

/* a ping-pong player */
typedef struct
{
  int table;
  int player;
  int count;
  pthread_mutex_t blocks[2];
  pthread_t thread;
} player_t;

/* a ping-pong table on which a rally is played */
typedef struct
{
  int target;
  int sleepms;
  player_t players[2];
  char pad[40];			/* avoids false cache
				   sharing */
} table_t;

/* a barrier used to pthread_processronise and time players */
typedef struct
{
  pthread_mutex_t mx;
  pthread_cond_t cv;
  int target;
  int count;
} barrier_t;

/* global arena of ping-pong tables */
static table_t *tables;

/* global lock used to create a bottleneck */
static pthread_mutex_t bottleneck;

/* player pthread_processonisation */
static barrier_t setup_barrier;	/* all players ready */
static barrier_t begin_barrier;	/* all games begin */
static barrier_t end_barrier;	/* all games ended */

/* global pthread attributes - must call attr_init() before using! */
static pthread_mutexattr_t mxattr;
static pthread_condattr_t cvattr;
static pthread_attr_t ptattr;

/* forward references */
static void *player (void *arg);
static void setup_tables (int n, int target, int sleepms);
static void attr_init (int pthread_process, int sched, long stacksize);
static void barrier_init (barrier_t * b, int target);
static void barrier_wait (barrier_t * b);
static void tvsub (struct timeval *tdiff, struct timeval *t1,
		   struct timeval *t0);
static long long tvdelta (struct timeval *start, struct timeval *stop);

/* for getopt(3C) */
extern char *optarg;
extern int ptind;

/* verbose output flag */
static int verbose = 0;
int
main (int argc, char *argv[])
{
  int c;

  struct timeval t0, t1;
  int ntables = 1;
  int target = 1000000;
  int sleepms = 0;
  int concurrency = 0;
  int resultonly = 0;
  int pthread_scope = PTHREAD_SCOPE_PROCESS;
  int pthread_process = PTHREAD_PROCESS_PRIVATE;
  long stacksize = 0L;
  int errflg = 0;
  while ((c = getopt (argc, argv, "?vri:n:z:p:s:c:S:")) != EOF)
    switch (c)
      {
      case '?':
	errflg++;
	continue;
      case 'v':
	verbose++;
	continue;
		case 'r':
	resultonly++;
	continue;
      case 'i':
	target = atoi (optarg);
	continue;
      case 'n':
	ntables = atoi (optarg);
	continue;
      case 'z':
	sleepms = atoi (optarg);
	continue;
      case 'p':
	if (strcmp (optarg, "shared") == 0)
	  {
	    pthread_process = PTHREAD_PROCESS_SHARED;
	  }

	else if (strcmp (optarg, "private") == 0)
	  {
	    pthread_scope = PTHREAD_PROCESS_PRIVATE;
	  }

	else
	  {
	    errflg++;
	  }
	continue;
      case 's':
	if (strcmp (optarg, "system") == 0)
	  {
	    pthread_scope = PTHREAD_SCOPE_SYSTEM;
	  }

	else if (strcmp (optarg, "process") == 0)
	  {
	    pthread_scope = PTHREAD_SCOPE_PROCESS;
	  }

	else
	  {
	    errflg++;
	  }
	continue;
      case 'c':
	concurrency = atoi (optarg);
	continue;
      case 'S':
	stacksize = atol (optarg);
	continue;
      default:
	errflg++;
      }
  if (errflg > 0)
    {
      printf ("usage: pp [-v] [-i <target>] [-n <ntables>]"
	      " [-z <sleepms>]\n"
	      "[-p private|shared] [-s process|system]\n"
	      "[-c <concurrency>] [-S <stacksize>]\n");
      exit (1);
    }
  if (verbose > 0)
    {
      printf ("\nPING-PONG CONFIGURATION:\n\n"
	      "target (-i) = %d\n"
	      "ntables (-n) = %d\n"
	      "sleepms (-z) = %d\n"
	      "pthread_scope (-s) = %s\n"
	      "pthread_process (-p) = %s\n"
	      "concurrency (-c) = %d\n"
	      "stacksize (-S) = %ld\n\n", target, ntables,
	      sleepms,
	      (pthread_scope ==
	       PTHREAD_SCOPE_PROCESS) ? "process" : "system",
	      (pthread_process ==
	       PTHREAD_PROCESS_PRIVATE) ? "private" : "shared",
	      concurrency, stacksize);
    }

  /* best to do this first! */
  attr_init (pthread_process, pthread_scope, stacksize);	//!!

  /* initialise bottleneck */
  pthread_mutex_init (&bottleneck, &mxattr);

  /* initialise pthread_processronisation and timing points */
  barrier_init (&setup_barrier, (2 * ntables) + 1);
  barrier_init (&begin_barrier, (2 * ntables) + 1);
  barrier_init (&end_barrier, (2 * ntables) + 1);

  /* should not be needed - sigh! */
  if (concurrency > 0)
    {
      pthread_setconcurrency (concurrency);
    }

  /* initialise all games */
  if (gettimeofday (&t0, NULL))
    {
      fprintf (stderr, "gettimeofday failed\n");
      exit (-1);
    }
  setup_tables (ntables, target, sleepms);

  /* wait for all players to be ready */
  barrier_wait (&setup_barrier);
  if (gettimeofday (&t1, NULL))
	{
	  fprintf (stderr, "gettimeofday failed\n");
	  exit (-1);
	}
   if (verbose)
    {
//     printf ("%d threads initialised in %lld msec\n", ntables * 2,
     printf ("%d threads initialised in %lld usec\n", ntables * 2,
	      tvdelta (&t0, &t1));
    }
	if (resultonly)
	{
		printf("%lld\n", tvdelta(&t0, &t1));
	}

  /* start all games */
  if (gettimeofday (&t0, NULL))
    {
      fprintf (stderr, "gettimeofday failed\n");
      exit (-1);
    }
  barrier_wait (&begin_barrier);

  /* wait for all games to complete */
  barrier_wait (&end_barrier);
  if (gettimeofday (&t1, NULL))
	{
	  fprintf (stderr, "gettimeofday failed\n");
	  exit (-1);
	}
  if (verbose)
    {
     printf ("%d games completed in %lld msec\n", ntables,
	      tvdelta (&t0, &t1));
    }
  if (resultonly)
  {
	  printf("%lld\n", tvdelta(&t0, &t1));
  }
  return (0);
}


/*
* build and populate the tables
*/
static void
setup_tables (int n, int target, int sleepms)
{
  int i, j;
  int res;
  tables =
    (void *) mmap (NULL, n * sizeof (table_t), PROT_READ | PROT_WRITE,
		   MAP_PRIVATE | MAP_ANON, -1, 0L);
  if (tables == (table_t *) (-1))
    {
      exit (1);
    }
  for (i = 0; i < n; i++)
    {
      tables[i].target = target;
      tables[i].sleepms = sleepms;
      for (j = 0; j < 2; j++)
	{
	  tables[i].players[j].table = i;
	  tables[i].players[j].player = j;
	  tables[i].players[j].count = 0;
	  pthread_mutex_init (&(tables[i].players[j].blocks[0]), &mxattr);
	  pthread_mutex_init (&(tables[i].players[j].blocks[1]), &mxattr);
	  res =
	    pthread_create (&(tables[i].players[j].thread), &ptattr,
			    player, &(tables[i].players[j]));
	  if (res != 0)
	    {

	      printf
		("Failed while creating new thread: your system can support %d threads only as much as possible\n",
		 i*2+j);
	      exit (1);
	    }
	}
    }
}

/*
* a ping-pong player
*/
static void *
player (void *arg)
{
  player_t *us, *them;
  table_t *table;
  struct timespec ts;
  us = (player_t *) arg;
  table = &(tables[us->table]);
  them = &(table->players[(us->player + 1) % 2]);
  barrier_wait (&setup_barrier);

/* player 0 always serves */
  if (us->player == 0)
    {
      pthread_mutex_lock (&(them->blocks[0]));
      pthread_mutex_lock (&(them->blocks[1]));
      barrier_wait (&begin_barrier);

/* serve! */
      pthread_mutex_unlock (&(them->blocks[0]));
    }

  else
    {
      pthread_mutex_lock (&(them->blocks[0]));
      barrier_wait (&begin_barrier);
    }
  while (us->count < table->target)
    {

/* wait to be unblocked */
      pthread_mutex_lock (&(us->blocks[us->count % 2]));

/* block their next + 1 move */

      pthread_mutex_lock (&(them->blocks[(us->count + us->player) % 2]));

/* let them block us again */
      pthread_mutex_unlock (&(us->blocks[us->count % 2]));

/* unblock their next move */

      pthread_mutex_unlock (&
			    (them->blocks[(us->count + us->player + 1) % 2]));
      us->count++;
      if (table->sleepms == -1)
	{
	  pthread_mutex_lock (&bottleneck);
	  pthread_mutex_unlock (&bottleneck);
	}

      else if (table->sleepms > 0)
	{
	  ts.tv_sec = table->sleepms / 1000;
	  ts.tv_nsec = (table->sleepms % 1000) * 1000000;
	  nanosleep (&ts, NULL);
	}
    }
  barrier_wait (&end_barrier);
  return (NULL);
}


/*
* simple, non-spinning barrier wait mechinism
*/
static void
barrier_wait (barrier_t * b)
{
  pthread_mutex_lock (&b->mx);
  b->count++;
  if (b->count >= b->target)
    {
      pthread_mutex_unlock (&b->mx);
      pthread_cond_broadcast (&b->cv);
      return;
    }
  while (b->count < b->target)
    {
      pthread_cond_wait (&b->cv, &b->mx);
    }
  pthread_mutex_unlock (&b->mx);
}

/*
* initialise a barrier (ok to reinitialise object if no
waiters)
*/
static void
barrier_init (barrier_t * b, int target)
{
  pthread_mutex_init (&b->mx, &mxattr);
  pthread_cond_init (&b->cv, &cvattr);
  b->target = target;
  b->count = 0;
}

/*
* initialise the global pthread attributes
*/
static void
attr_init (int pthread_process, int pthread_scope, long stacksize)
{
  pthread_mutexattr_init (&mxattr);
  pthread_mutexattr_setpshared (&mxattr, pthread_process);
  pthread_condattr_init (&cvattr);
  pthread_condattr_setpshared (&cvattr, pthread_process);
  pthread_attr_init (&ptattr);
  pthread_attr_setscope (&ptattr, pthread_scope);
  if (stacksize > 0)
    {
      pthread_attr_setstacksize (&ptattr, stacksize);
    }
}

static void
tvsub (struct timeval *tdiff, struct timeval *t1, struct timeval *t0)
{
  tdiff->tv_sec = t1->tv_sec - t0->tv_sec;
  tdiff->tv_usec = t1->tv_usec - t0->tv_usec;
  if (tdiff->tv_usec < 0 && tdiff->tv_sec > 0)
    {
      tdiff->tv_sec--;
      tdiff->tv_usec += 1000000;
      if (tdiff->tv_usec <= 0)
	{
	  fprintf (stderr, "time counting error!\n");
	  exit (2);
	}
    }

  /* time shouldn't go backwards!!! */
  if (tdiff->tv_usec < 0 || t1->tv_sec < t0->tv_sec)
    {
      tdiff->tv_sec = 0;
      tdiff->tv_usec = 0;
    }
}

static long long
tvdelta (struct timeval *start, struct timeval *stop)
{
  struct timeval td;
  long long usecs;

  tvsub (&td, stop, start);
  usecs = td.tv_sec;
  usecs *= 1000000;
  usecs += td.tv_usec;
  return (usecs);
}
