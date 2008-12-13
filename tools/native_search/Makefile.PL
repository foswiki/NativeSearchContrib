# Makefile for FoswikiNativeSearch module
use ExtUtils::MakeMaker;
WriteMakefile(
   NAME => 'FoswikiNativeSearch',
   OBJECT => 'FoswikiNativeSearch.o cgrep.o',
   LIBS => [ '-lpcre' ],
   CCFLAGS => "-g",
   LD => "gcc",
   OBJ_EXT => ".o",
   LDFROM => '$(OBJECT) -lpcre',
);
