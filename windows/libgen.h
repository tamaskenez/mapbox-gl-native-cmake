#ifndef MBGL_WINDOWS_LIBGEN_INCLUDED
#define MBGL_WINDOWS_LIBGEN_INCLUDED

#ifdef __cplusplus
extern "C" {
#endif

/* not reentrant, see http://pubs.opengroup.org/onlinepubs/7908799/xsh/dirname.html */
char *dirname(char *path);

#ifdef __cplusplus
}
#endif

#endif
