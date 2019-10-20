REM !/bin/sh

REM  PRE-COMMIT HOOK
REM 
REM  The pre-commit hook is invoked before a Subversion txn is
REM  committed.  Subversion runs this hook by invoking a program
REM  (script, executable, binary, etc.) named 'pre-commit' (for which
REM  this file is a template), with the following ordered arguments:
REM 
REM    [1] REPOS-PATH   (the path to this repository)
REM    [2] TXN-NAME     (the name of the txn about to be committed)
REM 
REM    [STDIN] LOCK-TOKENS ** the lock tokens are passed via STDIN.
REM 
REM    If STDIN contains the line "LOCK-TOKENS:\n" (the "\n" denotes a
REM    single newline), the lines following it are the lock tokens for
REM    this commit.  The end of the list is marked by a line containing
REM    only a newline character.
REM 
REM    Each lock token line consists of a URI-escaped path, followed
REM    by the separator character '|', followed by the lock token string,
REM    followed by a newline.
REM 
REM  If the hook program exits with success, the txn is committed; but
REM  if it exits with failure (non-zero), the txn is aborted, no commit
REM  takes place, and STDERR is returned to the client.   The hook
REM  program can use the 'svnlook' utility to help it examine the txn.
REM 
REM    ***  NOTE: THE HOOK PROGRAM MUST NOT MODIFY THE TXN, EXCEPT  ***
REM    ***  FOR REVISION PROPERTIES (like svn:log or svn:author).   ***
REM 
REM    This is why we recommend using the read-only 'svnlook' utility.
REM    In the future, Subversion may enforce the rule that pre-commit
REM    hooks should not modify the versioned data in txns, or else come
REM    up with a mechanism to make it safe to do so (by informing the
REM    committing client of the changes).  However, right now neither
REM    mechanism is implemented, so hook writers just have to be careful.
REM 
REM  The default working directory for the invocation is undefined, so
REM  the program should set one explicitly if it cares.
REM 
REM  On a Unix system, the normal procedure is to have 'pre-commit'
REM  invoke other programs to do the real work, though it may do the
REM  work itself too.
REM 
REM  Note that 'pre-commit' must be executable by the user(s) who will
REM  invoke it (typically the user httpd runs as), and that user must
REM  have filesystem-level permission to access the repository.
REM 
REM  On a Windows system, you should name the hook program
REM  'pre-commit.bat' or 'pre-commit.exe',
REM  but the basic idea is the same.
REM 
REM  The hook program runs in an empty environment, unless the server is
REM  explicitly configured otherwise.  For example, a common problem is for
REM  the PATH environment variable to not be set to its usual value, so
REM  that subprograms fail to launch unless invoked via absolute path.
REM  If you're having unexpected problems with a hook program, the
REM  culprit may be unusual (or missing) environment variables.
REM 
REM  CAUTION:
REM  For security reasons, you MUST always properly quote arguments when
REM  you use them, as those arguments could contain whitespace or other
REM  problematic characters. Additionally, you should delimit the list
REM  of options with "--" before passing the arguments, so malicious
REM  clients cannot bootleg unexpected options to the commands your
REM  script aims to execute.
REM  For similar reasons, you should also add a trailing @ to URLs which
REM  are passed to SVN commands accepting URLs with peg revisions.
REM 
REM  Here is an example hook script, for a Unix /bin/sh interpreter.
REM  For more examples and pre-written hooks, see those in
REM  the Subversion repository at
REM  http://svn.apache.org/repos/asf/subversion/trunk/tools/hook-scripts/ and
REM  http://svn.apache.org/repos/asf/subversion/trunk/contrib/hook-scripts/


set REPOS=%1%
set TXN=%2%

REM  Make sure that the log message contains some text.

REM SVNLOOK log -t "$TXN" "$REPOS" | \
REM    grep "[a-zA-Z0-9]" > /dev/null || exit 1

REM  Check that the author of this commit has the rights to perform
REM  the commit on the files and directories being modified.
rem commit-access-control.pl "$REPOS" "$TXN" commit-access-control.cfg || exit 1

rem check for an empty log message
svnlook log %REPOS% -t %TXN% | findstr . > nul
if %errorlevel% gtr 0 (goto err) else exit 0
 
:err
echo. 1>&2
echo Your commit has been blocked because you didn't give any log message 1>&2
echo Please write a log message describing the purpose of your changes and 1>&2
echo then try committing again. -- Thank you 1>&2
exit 1

