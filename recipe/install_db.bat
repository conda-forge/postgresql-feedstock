set PERL_USE_UNSAFE_INC=1

pushd src\tools\msvc

REM because modern versions of perl don't have this by default 
set PERL5LIB=.;%PERL5LIB%

call install.bat %LIBRARY_PREFIX%
