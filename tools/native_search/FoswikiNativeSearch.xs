/* Copyright (C) 2007 WikiRing http://wikiring.com All Rights Reserved
 * Author: Crawford Currie
 * Fast grep function designed for use from Perl. Does not suffer from
 * limitations of `grep` viz. cost of spawning a subprocess, and
 * limits on command-line length.
 */
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/*
 * Unpack perl args into a null-terminated array of strings. The function name
 * is dictated by the mapping in the default typemap i.e.
 * (char** -> T_PACKEDARRAY -> XS_unpack_charPtrPtr
 * The array of strings is allocated on the heap.
 */
char ** XS_unpack_charPtrPtr(SV* rv) {
	AV *av;

	if (SvROK(rv) && (SvTYPE(SvRV(rv)) == SVt_PVAV))
		av = (AV*)SvRV(rv);
	else {
		warn("unpack_args: rv was not an AV ref");
		return ((char**)NULL);
	}

	int length = av_len(av) + 1; /* av_len is the last index */

    /* array is null-terminated */
    char ** s = (char **)calloc(length + 1, sizeof(char*));
    if (!s) {
    	warn("unpack_args: unable to allocate char**");
    	return ((char**)NULL);
    }

    int i;
    for (i = 0; i < length; i++) {
    	SV ** ssv = av_fetch(av, i, 0);
    	if (ssv) {
            s[i] = (char *)calloc( SvCUR(*ssv) + 1, sizeof(char) );
            /* *Requires* that data be char strings */
     		strcpy(s[i], SvPV(*ssv, PL_na));
    	}
    }
	return s;
}

/*
 * Convert a char** to a Perl AV*, freeing the char** and the strings
 * stored in it.  The function name is dictated by the mapping in the
 * default typemap i.e.
 * (char** -> T_PACKEDARRAY -> XS_pack_charPtrPtr
 */
void XS_pack_charPtrPtr(SV* st, char **s, int n) {
	AV *av = newAV();

    if (s) {
    	char **c;
    	for (c = s; *c; c++) {
    		SV * sv = newSVpv(*c, 0);
    		av_push(av, sv);
            free(*c);
    	}
        free(s);
    }

	SV * sv = newSVrv(st, NULL);	  /* upgrade stack SV to an RV */
	SvREFCNT_dec(sv);         /* discard */
	SvRV(st) = (SV*)av;       /* make stack RV point at our AV */
}

MODULE = FoswikiNativeSearch     PACKAGE = FoswikiNativeSearch

char**
cgrep(argv)
	char ** argv
    PREINIT:
        int count_charPtrPtr; /* Dummy, unused */
