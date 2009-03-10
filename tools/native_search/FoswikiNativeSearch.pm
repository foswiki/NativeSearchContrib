# Copyright (C) 2007 WikiRing http://wikiring.com All Rights Reserved
# Author: Crawford Currie
# Perl interface to FoswikiNativeSearch xs module
package FoswikiNativeSearch;

require Exporter;
require DynaLoader;
@ISA    = qw(Exporter DynaLoader);
@EXPORT = qw( cgrep );

bootstrap FoswikiNativeSearch;

1;
