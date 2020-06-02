#!/bin/sh
#-
# SPDX-License-Identifier: BSD-2-Clause
#
# Copyright (c) 2020. Rubicon Communications, LLC. All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# $FreeBSD$
#

DPATH=$1

case "${DPATH}" in
"")	printf "ERROR: usage $0 <path to src tree>\n" >&2
	exit 1
	;;
esac
if test ! -e ${DPATH}/RELNOTES; then
	printf "ERROR: please point to the top of a src tree\n" >&2
	exit 1
fi

if test ! -d ${DPATH}/sys/dev/athp; then
	cp -pr otus/freebsd/src/sys/dev/athp ${DPATH}/sys/dev/
else
	printf "INFO: found dev/athp; skipping\n" >&2
fi
if test ! -d ${DPATH}/sys/modules/athp; then
	cp -pr otus/freebsd/src/sys/modules/athp ${DPATH}/sys/modules/
else
	printf "INFO: found modules/athp; skipping\n" >&2
fi
if test ! -d ${DPATH}/sys/modules/athpfw; then
	cp -pr otus/freebsd/src/sys/modules/athpfw ${DPATH}/sys/modules/
else
	printf "INFO: found modules/athpfw; skipping\n" >&2
fi

patch -d ${DPATH} -s -p1 < otus/freebsd/src/sys/modules/Makefile.diff
rc=$?
case ${rc} in
0)	rm -f ${DPATH}/sys/modules/Makefile.orig
	;;
*)	printf "WARNING: patch for modules did not apply cleanly. Please fix!" >&2
	;;
esac

printf "DONE.\n" >&2

# end
