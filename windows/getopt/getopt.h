#ifndef MBGL_WINDOWS_GETOPT_INCLUDED
#define MBGL_WINDOWS_GETOPT_INCLUDED

//License-free windows port of subset of the POSIX getopt features
//Only the functionality required to make linux/main.cpp work is implemented.

const int no_argument = 0;
const int required_argument = 1;

struct option
{
    const char *name;
    int has_arg;
    int *flag;
    int val;
};

int getopt_long(int argc, char *const *argv,
    const char *shortopts,
    const struct option *longopts, int *longind);

extern int optind;
extern char * optarg;
extern int optopt;


#endif
