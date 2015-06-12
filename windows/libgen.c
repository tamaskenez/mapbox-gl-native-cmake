/* include its own (compatibility) header not the unix one */
#include "libgen.h"
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

char *dirname(char *path) {
    static char result[_MAX_PATH];
    char drive[_MAX_DRIVE];
    char dir[_MAX_DIR];
    char fname[_MAX_FNAME];
    char ext[_MAX_EXT];

    _splitpath(path, drive, dir, fname, ext);
    _makepath(result, drive, dir, NULL, NULL);

    return result;
}

#ifdef __cplusplus
}
#endif
