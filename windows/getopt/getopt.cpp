#include "getopt.h" //this is not the system one

#include <cstring>

int optind = 1;
char * optarg = 0;
int optopt = 0;

int getopt_long(int argc, char *const *argv,
    const char *shortopts,
    const struct option *longopts, int *longind) {

    if (optind >= argc)
        return -1;

    auto argvi = argv[optind];

    int has_arg = 0;
    int* flag = 0;
    int val = 0;

    int result = -1;

    if (argvi[0] == '-') {
        if (argvi[1] == '-') {
            for (auto lo = longopts; lo->name; ++lo) {
                if (strcmp(lo->name, argvi + 2) == 0) {
                    has_arg = lo->has_arg;
                    flag = lo->flag;
                    result = lo->val;
                    break;
                }
            }
        } else {
            if (argvi[1] != 0 && argvi[2] == 0) {
                for (auto so = shortopts; *so; ++so) {
                    if (*so == ':')
                        continue;
                    if (argvi[1] == *so) {
                        has_arg = so[1] == ':';
                        result = *so;
                        break;
                    }
                }
            }
        }
    }

    optarg = 0;
    if (result != -1) {
        if (has_arg) {
            if (++optind < argc)
                optarg = argv[++optind];
            else {
                result = '?';
                optopt = result;
            }
        }
        if (flag)
            *flag = result;
    }
    ++optind;

    return result;
}
