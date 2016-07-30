<a name="Completion-Using-compctl"></a>

| [ [\<\<](Completion-System.html#Completion-System) ] | [ [\<](Completion-System.html#Completion-Directories) ] | [ [Up](index.html#Top) ] | [ [\>](#Types-of-completion) ] | [ [>>](Zsh-Modules.html#Zsh-Modules) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Completion-Using-compctl-1"></a>

21 Completion Using compctl
===========================

<a name="index-completion_002c-programmable-2"></a><a name="index-completion_002c-controlling-2"></a>

---

<a name="Types-of-completion"></a>

| [ [\<\<](#Completion-Using-compctl) ] | [ [\<](#Completion-Using-compctl) ] | [ [Up](#Completion-Using-compctl) ] | [ [\>](#Description-5) ] | [ [>>](Zsh-Modules.html#Zsh-Modules) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

21.1 Types of completion
------------------------

This version of zsh has two ways of performing completion of words on the command line. New users of the shell may prefer to use the newer and more powerful system based on shell functions; this is described in [Completion System](Completion-System.html#Completion-System), and the basic shell mechanisms which support it are described in [Completion Widgets](Completion-Widgets.html#Completion-Widgets). This chapter describes the older <tt>compctl</tt> command.

---

<a name="Description-5"></a>

| [ [\<\<](#Completion-Using-compctl) ] | [ [\<](#Types-of-completion) ] | [ [Up](#Completion-Using-compctl) ] | [ [\>](#Command-Flags) ] | [ [>>](Zsh-Modules.html#Zsh-Modules) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

21.2 Description
----------------

<a name="index-compctl"></a>

<dl compact="compact">

<dt><tt>compctl</tt> [ <tt>-CDT</tt> ] <var>options</var> [ <var>command</var> ... ]</dt>

<dt><tt>compctl</tt> [ <tt>-CDT</tt> ] <var>options</var> [ <tt>-x</tt> <var>pattern</var> <var>options</var> <tt>-</tt> ... <tt>-</tt><tt>-</tt> ]</dt>

<dt>[ <tt>+</tt> <var>options</var> [ <tt>-x</tt> ... <tt>-</tt><tt>-</tt> ] ... [<tt>+</tt>] ] [ <var>command</var> ... ]</dt>

<dt><tt>compctl</tt> <tt>-M</tt> <var>match-specs</var> ...</dt>

<dt><tt>compctl</tt> <tt>-L</tt> [ <tt>-CDTM</tt> ] [ <var>command</var> ... ]</dt>

<dt><tt>compctl</tt> <tt>+</tt> <var>command</var> ...</dt>

</dl>

Control the editor’s completion behavior according to the supplied set of <var>options</var>. Various editing commands, notably <tt>expand-or-complete-word</tt>, usually bound to tab, will attempt to complete a word typed by the user, while others, notably <tt>delete-char-or-list</tt>, usually bound to ^D in EMACS editing mode, list the possibilities; <tt>compctl</tt> controls what those possibilities are. They may for example be filenames (the most common case, and hence the default), shell variables, or words from a user-specified list.

| [21.3 Command Flags](#Command-Flags) | | [21.4 Option Flags](#Option-Flags) | | [21.5 Alternative Completion](#Alternative-Completion) | | [21.6 Extended Completion](#Extended-Completion) | | [21.7 Example](#Example) |

---

<a name="Command-Flags"></a>

| [ [\<\<](#Completion-Using-compctl) ] | [ [\<](#Description-5) ] | [ [Up](#Completion-Using-compctl) ] | [ [\>](#Option-Flags) ] | [ [>>](Zsh-Modules.html#Zsh-Modules) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Command-Flags-1"></a>

21.3 Command Flags
------------------

Completion of the arguments of a command may be different for each command or may use the default. The behavior when completing the command word itself may also be separately specified. These correspond to the following flags and arguments, all of which (except for <tt>-L</tt>) may be combined with any combination of the <var>options</var> described subsequently in [Option Flags](#Option-Flags):

<dl compact="compact">

<dt><var>command</var> ...</dt>

<dd>

controls completion for the named commands, which must be listed last on the command line. If completion is attempted for a command with a pathname containing slashes and no completion definition is found, the search is retried with the last pathname component. If the command starts with a <tt>=</tt>, completion is tried with the pathname of the command.

Any of the <var>command</var> strings may be patterns of the form normally used for filename generation. These should be quoted to protect them from immediate expansion; for example the command string <tt>’foo*’</tt> arranges for completion of the words of any command beginning with <tt>foo</tt>. When completion is attempted, all pattern completions are tried in the reverse order of their definition until one matches. By default, completion then proceeds as normal, i.e. the shell will try to generate more matches for the specific command on the command line; this can be overridden by including <tt>-tn</tt> in the flags for the pattern completion.

Note that aliases are expanded before the command name is determined unless the <tt>COMPLETE_ALIASES</tt> option is set. Commands may not be combined with the <tt>-C</tt>, <tt>-D</tt> or <tt>-T</tt> flags.

</dd>

<dt><tt>-C</tt></dt>

<dd>

controls completion when the command word itself is being completed. If no <tt>compctl -C</tt> command has been issued, the names of any executable command (whether in the path or specific to the shell, such as aliases or functions) are completed.

</dd>

<dt><tt>-D</tt></dt>

<dd>

controls default completion behavior for the arguments of commands not assigned any special behavior. If no <tt>compctl -D</tt> command has been issued, filenames are completed.

</dd>

<dt><tt>-T</tt></dt>

<dd>

supplies completion flags to be used before any other processing is done, even before processing for <tt>compctl</tt>s defined for specific commands. This is especially useful when combined with extended completion (the <tt>-x</tt> flag, see [Extended Completion](#Extended-Completion) below). Using this flag you can define default behavior which will apply to all commands without exception, or you can alter the standard behavior for all commands. For example, if your access to the user database is too slow and/or it contains too many users (so that completion after ‘<tt>~</tt>’ is too slow to be usable), you can use

<div class="example">

<pre class="example">compctl -T -x 's[~] C[0,[^/]#]' -k friends -S/ -tn
</pre>

</div>

to complete the strings in the array <tt>friends</tt> after a ‘<tt>~</tt>’. The <tt>C[</tt><var>...</var><tt>]</tt> argument is necessary so that this form of <tt>~</tt>-completion is not tried after the directory name is finished.

</dd>

<dt><tt>-L</tt></dt>

<dd>

lists the existing completion behavior in a manner suitable for putting into a start-up script; the existing behavior is not changed. Any combination of the above forms, or the <tt>-M</tt> flag (which must follow the <tt>-L</tt> flag), may be specified, otherwise all defined completions are listed. Any other flags supplied are ignored.

</dd>

<dt>_no argument_</dt>

<dd>

If no argument is given, <tt>compctl</tt> lists all defined completions in an abbreviated form; with a list of <var>options</var>, all completions with those flags set (not counting extended completion) are listed.

</dd>

</dl>

If the <tt>\+</tt> flag is alone and followed immediately by the <var>command</var> list, the completion behavior for all the commands in the list is reset to the default. In other words, completion will subsequently use the options specified by the <tt>-D</tt> flag.

The form with <tt>-M</tt> as the first and only option defines global matching specifications (see [Completion Matching Control](Completion-Widgets.html#Completion-Matching-Control)). The match specifications given will be used for every completion attempt (only when using <tt>compctl</tt>, not with the new completion system) and are tried in the order in which they are defined until one generates at least one match. E.g.:

<div class="example">

<pre class="example">compctl -M '' 'm:{a-zA-Z}={A-Za-z}'
</pre>

</div>

This will first try completion without any global match specifications (the empty string) and, if that generates no matches, will try case insensitive completion.

---

<a name="Option-Flags"></a>

| [ [\<\<](#Completion-Using-compctl) ] | [ [\<](#Command-Flags) ] | [ [Up](#Completion-Using-compctl) ] | [ [\>](#Simple-Flags) ] | [ [>>](Zsh-Modules.html#Zsh-Modules) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Option-Flags-1"></a>

21.4 Option Flags
-----------------

<dl compact="compact">

<dt>[ <tt>-fcFBdeaRGovNAIOPZEnbjrzu/12</tt> ]</dt>

<dt>[ <tt>-k</tt> <var>array</var> ] [ <tt>-g</tt> <var>globstring</var> ] [ <tt>-s</tt> <var>subststring</var> ]</dt>

<dt>[ <tt>-K</tt> <var>function</var> ]</dt>

<dt>[ <tt>-Q</tt> ] [ <tt>-P</tt> <var>prefix</var> ] [ <tt>-S</tt> <var>suffix</var> ]</dt>

<dt>[ <tt>-W</tt> <var>file-prefix</var> ] [ <tt>-H</tt> <var>num pattern</var> ]</dt>

<dt>[ <tt>-q</tt> ] [ <tt>-X</tt> <var>explanation</var> ] [ <tt>-Y</tt> <var>explanation</var> ]</dt>

<dt>[ <tt>-y</tt> <var>func-or-var</var> ] [ <tt>-l</tt> <var>cmd</var> ] [ <tt>-h</tt> <var>cmd</var> ] [ <tt>-U</tt> ]</dt>

<dt>[ <tt>-t</tt> <var>continue</var> ] [ <tt>-J</tt> <var>name</var> ] [ <tt>-V</tt> <var>name</var> ]</dt>

<dt>[ <tt>-M</tt> <var>match-spec</var> ]</dt>

</dl>

The remaining <var>options</var> specify the type of command arguments to look for during completion. Any combination of these flags may be specified; the result is a sorted list of all the possibilities. The options are as follows.

| [21.4.1 Simple Flags](#Simple-Flags) | | [21.4.2 Flags with Arguments](#Flags-with-Arguments) | | [21.4.3 Control Flags](#Control-Flags) |

---

<a name="Simple-Flags"></a>

| [ [\<\<](#Completion-Using-compctl) ] | [ [\<](#Option-Flags) ] | [ [Up](#Option-Flags) ] | [ [\>](#Flags-with-Arguments) ] | [ [>>](Zsh-Modules.html#Zsh-Modules) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Simple-Flags-1"></a>

### 21.4.1 Simple Flags

These produce completion lists made up by the shell itself:

<dl compact="compact">

<dt><tt>-f</tt></dt>

<dd>

Filenames and file system paths.

</dd>

<dt><tt>-/</tt></dt>

<dd>

Just file system paths.

</dd>

<dt><tt>-c</tt></dt>

<dd>

Command names, including aliases, shell functions, builtins and reserved words.

</dd>

<dt><tt>-F</tt></dt>

<dd>

Function names.

</dd>

<dt><tt>-B</tt></dt>

<dd>

Names of builtin commands.

</dd>

<dt><tt>-m</tt></dt>

<dd>

Names of external commands.

</dd>

<dt><tt>-w</tt></dt>

<dd>

Reserved words.

</dd>

<dt><tt>-a</tt></dt>

<dd>

Alias names.

</dd>

<dt><tt>-R</tt></dt>

<dd>

Names of regular (non-global) aliases.

</dd>

<dt><tt>-G</tt></dt>

<dd>

Names of global aliases.

</dd>

<dt><tt>-d</tt></dt>

<dd>

This can be combined with <tt>-F</tt>, <tt>-B</tt>, <tt>-w</tt>, <tt>-a</tt>, <tt>-R</tt> and <tt>-G</tt> to get names of disabled functions, builtins, reserved words or aliases.

</dd>

<dt><tt>-e</tt></dt>

<dd>

This option (to show enabled commands) is in effect by default, but may be combined with <tt>-d</tt>; <tt>-de</tt> in combination with <tt>-F</tt>, <tt>-B</tt>, <tt>-w</tt>, <tt>-a</tt>, <tt>-R</tt> and <tt>-G</tt> will complete names of functions, builtins, reserved words or aliases whether or not they are disabled.

</dd>

<dt><tt>-o</tt></dt>

<dd>

Names of shell options (see [Options](Options.html#Options)).

</dd>

<dt><tt>-v</tt></dt>

<dd>

Names of any variable defined in the shell.

</dd>

<dt><tt>-N</tt></dt>

<dd>

Names of scalar (non-array) parameters.

</dd>

<dt><tt>-A</tt></dt>

<dd>

Array names.

</dd>

<dt><tt>-I</tt></dt>

<dd>

Names of integer variables.

</dd>

<dt><tt>-O</tt></dt>

<dd>

Names of read-only variables.

</dd>

<dt><tt>-p</tt></dt>

<dd>

Names of parameters used by the shell (including special parameters).

</dd>

<dt><tt>-Z</tt></dt>

<dd>

Names of shell special parameters.

</dd>

<dt><tt>-E</tt></dt>

<dd>

Names of environment variables.

</dd>

<dt><tt>-n</tt></dt>

<dd>

Named directories.

</dd>

<dt><tt>-b</tt></dt>

<dd>

Key binding names.

</dd>

<dt><tt>-j</tt></dt>

<dd>

Job names: the first word of the job leader’s command line. This is useful with the <tt>kill</tt> builtin.

</dd>

<dt><tt>-r</tt></dt>

<dd>

Names of running jobs.

</dd>

<dt><tt>-z</tt></dt>

<dd>

Names of suspended jobs.

</dd>

<dt><tt>-u</tt></dt>

<dd>

User names.

</dd>

</dl>

---

<a name="Flags-with-Arguments"></a>

| [ [\<\<](#Completion-Using-compctl) ] | [ [\<](#Simple-Flags) ] | [ [Up](#Option-Flags) ] | [ [\>](#Control-Flags) ] | [ [>>](Zsh-Modules.html#Zsh-Modules) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Flags-with-Arguments-1"></a>

### 21.4.2 Flags with Arguments

These have user supplied arguments to determine how the list of completions is to be made up:

<dl compact="compact">

<dt><tt>-k</tt> <var>array</var></dt>

<dd>

Names taken from the elements of <tt>$</tt><var>array</var> (note that the ‘<tt>$</tt>’ does not appear on the command line). Alternatively, the argument <var>array</var> itself may be a set of space- or comma-separated values in parentheses, in which any delimiter may be escaped with a backslash; in this case the argument should be quoted. For example,

<div class="example">

<pre class="example">compctl -k "(cputime filesize datasize stacksize
           coredumpsize resident descriptors)" limit
</pre>

</div>

</dd>

<dt><tt>-g</tt> <var>globstring</var></dt>

<dd>

The <var>globstring</var> is expanded using filename globbing; it should be quoted to protect it from immediate expansion. The resulting filenames are taken as the possible completions. Use ‘<tt>*(/)</tt>’ instead of ‘<tt>*/</tt>’ for directories. The <tt>fignore</tt> special parameter is not applied to the resulting files. More than one pattern may be given separated by blanks. (Note that brace expansion is _not_ part of globbing. Use the syntax ‘<tt>(either|or)</tt>’ to match alternatives.)

</dd>

<dt><tt>-s</tt> <var>subststring</var></dt>

<dd>

The <var>subststring</var> is split into words and these words are than expanded using all shell expansion mechanisms (see [Expansion](Expansion.html#Expansion)). The resulting words are taken as possible completions. The <tt>fignore</tt> special parameter is not applied to the resulting files. Note that <tt>-g</tt> is faster for filenames.

</dd>

<dt><tt>-K</tt> <var>function</var></dt>

<dd><a name="index-reply_002c-use-of-2"></a>

Call the given function to get the completions. Unless the name starts with an underscore, the function is passed two arguments: the prefix and the suffix of the word on which completion is to be attempted, in other words those characters before the cursor position, and those from the cursor position onwards. The whole command line can be accessed with the <tt>-c</tt> and <tt>-l</tt> flags of the <tt>read</tt> builtin. The function should set the variable <tt>reply</tt> to an array containing the completions (one completion per element); note that <tt>reply</tt> should not be made local to the function. From such a function the command line can be accessed with the <tt>-c</tt> and <tt>-l</tt> flags to the <tt>read</tt> builtin. For example,

<div class="example">

<pre class="example">function whoson { reply=(`users`); }
compctl -K whoson talk
</pre>

</div>

completes only logged-on users after ‘<tt>talk</tt>’. Note that ‘<tt>whoson</tt>’ must return an array, so ‘<tt>reply=‘users‘</tt>’ would be incorrect.

</dd>

<dt><tt>-H</tt> <var>num pattern</var></dt>

<dd>

The possible completions are taken from the last <var>num</var> history lines. Only words matching <var>pattern</var> are taken. If <var>num</var> is zero or negative the whole history is searched and if <var>pattern</var> is the empty string all words are taken (as with ‘<tt>*</tt>’). A typical use is

<div class="example">

<pre class="example">compctl -D -f + -H 0 ''
</pre>

</div>

which forces completion to look back in the history list for a word if no filename matches.

</dd>

</dl>

---

<a name="Control-Flags"></a>

| [ [\<\<](#Completion-Using-compctl) ] | [ [\<](#Flags-with-Arguments) ] | [ [Up](#Option-Flags) ] | [ [\>](#Alternative-Completion) ] | [ [>>](Zsh-Modules.html#Zsh-Modules) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Control-Flags-1"></a>

### 21.4.3 Control Flags

These do not directly specify types of name to be completed, but manipulate the options that do:

<dl compact="compact">

<dt><tt>-Q</tt></dt>

<dd>

This instructs the shell not to quote any metacharacters in the possible completions. Normally the results of a completion are inserted into the command line with any metacharacters quoted so that they are interpreted as normal characters. This is appropriate for filenames and ordinary strings. However, for special effects, such as inserting a backquoted expression from a completion array (<tt>-k</tt>) so that the expression will not be evaluated until the complete line is executed, this option must be used.

</dd>

<dt><tt>-P</tt> <var>prefix</var></dt>

<dd>

The <var>prefix</var> is inserted just before the completed string; any initial part already typed will be completed and the whole <var>prefix</var> ignored for completion purposes. For example,

<div class="example">

<pre class="example">compctl -j -P "%" kill
</pre>

</div>

inserts a ‘%’ after the kill command and then completes job names.

</dd>

<dt><tt>-S</tt> <var>suffix</var></dt>

<dd>

When a completion is found the <var>suffix</var> is inserted after the completed string. In the case of menu completion the suffix is inserted immediately, but it is still possible to cycle through the list of completions by repeatedly hitting the same key.

</dd>

<dt><tt>-W</tt> <var>file-prefix</var></dt>

<dd>

With directory <var>file-prefix</var>: for command, file, directory and globbing completion (options <tt>-c</tt>, <tt>-f</tt>, <tt>-/</tt>, <tt>-g</tt>), the file prefix is implicitly added in front of the completion. For example,

<div class="example">

<pre class="example">compctl -/ -W ~/Mail maildirs
</pre>

</div>

completes any subdirectories to any depth beneath the directory <tt>~/Mail</tt>, although that prefix does not appear on the command line. The <var>file-prefix</var> may also be of the form accepted by the <tt>-k</tt> flag, i.e. the name of an array or a literal list in parenthesis. In this case all the directories in the list will be searched for possible completions.

</dd>

<dt><tt>-q</tt></dt>

<dd>

If used with a suffix as specified by the <tt>-S</tt> option, this causes the suffix to be removed if the next character typed is a blank or does not insert anything or if the suffix consists of only one character and the next character typed is the same character; this the same rule used for the <tt>AUTO_REMOVE_SLASH</tt> option. The option is most useful for list separators (comma, colon, etc.).

</dd>

<dt><tt>-l</tt> <var>cmd</var></dt>

<dd>

This option restricts the range of command line words that are considered to be arguments. If combined with one of the extended completion patterns ‘<tt>p[</tt>...<tt>]</tt>’, ‘<tt>r[</tt>...<tt>]</tt>’, or ‘<tt>R[</tt>...<tt>]</tt>’ (see [Extended Completion](#Extended-Completion) below) the range is restricted to the range of arguments specified in the brackets. Completion is then performed as if these had been given as arguments to the <var>cmd</var> supplied with the option. If the <var>cmd</var> string is empty the first word in the range is instead taken as the command name, and command name completion performed on the first word in the range. For example,

<div class="example">

<pre class="example">compctl -x 'r[-exec,;]' -l '' -- find
</pre>

</div>

completes arguments between ‘<tt>-exec</tt>’ and the following ‘<tt>;</tt>’ (or the end of the command line if there is no such string) as if they were a separate command line.

</dd>

<dt><tt>-h</tt> <var>cmd</var></dt>

<dd>

Normally zsh completes quoted strings as a whole. With this option, completion can be done separately on different parts of such strings. It works like the <tt>-l</tt> option but makes the completion code work on the parts of the current word that are separated by spaces. These parts are completed as if they were arguments to the given <var>cmd</var>. If <var>cmd</var> is the empty string, the first part is completed as a command name, as with <tt>-l</tt>.

</dd>

<dt><tt>-U</tt></dt>

<dd>

Use the whole list of possible completions, whether or not they actually match the word on the command line. The word typed so far will be deleted. This is most useful with a function (given by the <tt>-K</tt> option) which can examine the word components passed to it (or via the <tt>read</tt> builtin’s <tt>-c</tt> and <tt>-l</tt> flags) and use its own criteria to decide what matches. If there is no completion, the original word is retained. Since the produced possible completions seldom have interesting common prefixes and suffixes, menu completion is started immediately if <tt>AUTO_MENU</tt> is set and this flag is used.

</dd>

<dt><tt>-y</tt> <var>func-or-var</var></dt>

<dd><a name="index-reply_002c-use-of-3"></a>

The list provided by <var>func-or-var</var> is displayed instead of the list of completions whenever a listing is required; the actual completions to be inserted are not affected. It can be provided in two ways. Firstly, if <var>func-or-var</var> begins with a <tt>$</tt> it defines a variable, or if it begins with a left parenthesis a literal array, which contains the list. A variable may have been set by a call to a function using the <tt>-K</tt> option. Otherwise it contains the name of a function which will be executed to create the list. The function will be passed as an argument list all matching completions, including prefixes and suffixes expanded in full, and should set the array <tt>reply</tt> to the result. In both cases, the display list will only be retrieved after a complete list of matches has been created.

Note that the returned list does not have to correspond, even in length, to the original set of matches, and may be passed as a scalar instead of an array. No special formatting of characters is performed on the output in this case; in particular, newlines are printed literally and if they appear output in columns is suppressed.

</dd>

<dt><tt>-X</tt> <var>explanation</var></dt>

<dd>

Print <var>explanation</var> when trying completion on the current set of options. A ‘<tt>%n</tt>’ in this string is replaced by the number of matches that were added for this explanation string. The explanation only appears if completion was tried and there was no unique match, or when listing completions. Explanation strings will be listed together with the matches of the group specified together with the <tt>-X</tt> option (using the <tt>-J</tt> or <tt>-V</tt> option). If the same explanation string is given to multiple <tt>-X</tt> options, the string appears only once (for each group) and the number of matches shown for the ‘<tt>%n</tt>’ is the total number of all matches for each of these uses. In any case, the explanation string will only be shown if there was at least one match added for the explanation string.

The sequences <tt>%B</tt>, <tt>%b</tt>, <tt>%S</tt>, <tt>%s</tt>, <tt>%U</tt>, and <tt>%u</tt> specify output attributes (bold, standout, and underline), <tt>%F</tt>, <tt>%f</tt>, <tt>%K</tt>, <tt>%k</tt> specify foreground and background colours, and <tt>%{</tt><var>...</var><tt>%}</tt> can be used to include literal escape sequences as in prompts.

</dd>

<dt><tt>-Y</tt> <var>explanation</var></dt>

<dd>

Identical to <tt>-X</tt>, except that the <var>explanation</var> first undergoes expansion following the usual rules for strings in double quotes. The expansion will be carried out after any functions are called for the <tt>-K</tt> or <tt>-y</tt> options, allowing them to set variables.

</dd>

<dt><tt>-t</tt> <var>continue</var></dt>

<dd>

The <var>continue</var>-string contains a character that specifies which set of completion flags should be used next. It is useful:

(i) With <tt>-T</tt>, or when trying a list of pattern completions, when <tt>compctl</tt> would usually continue with ordinary processing after finding matches; this can be suppressed with ‘<tt>-tn</tt>’.

(ii) With a list of alternatives separated by <tt>+</tt>, when <tt>compctl</tt> would normally stop when one of the alternatives generates matches. It can be forced to consider the next set of completions by adding ‘<tt>-t+</tt>’ to the flags of the alternative before the ‘<tt>+</tt>’.

(iii) In an extended completion list (see below), when <tt>compctl</tt> would normally continue until a set of conditions succeeded, then use only the immediately following flags. With ‘<tt>-t-</tt>’, <tt>compctl</tt> will continue trying extended completions after the next ‘<tt>-</tt>’; with ‘<tt>-tx</tt>’ it will attempt completion with the default flags, in other words those before the ‘<tt>-x</tt>’.

</dd>

<dt><tt>-J</tt> <var>name</var></dt>

<dd>

This gives the name of the group the matches should be placed in. Groups are listed and sorted separately; likewise, menu completion will offer the matches in the groups in the order in which the groups were defined. If no group name is explicitly given, the matches are stored in a group named <tt>default</tt>. The first time a group name is encountered, a group with that name is created. After that all matches with the same group name are stored in that group.

This can be useful with non-exclusive alternative completions. For example, in

<div class="example">

<pre class="example">compctl -f -J files -t+ + -v -J variables foo
</pre>

</div>

both files and variables are possible completions, as the <tt>-t+</tt> forces both sets of alternatives before and after the <tt>+</tt> to be considered at once. Because of the <tt>-J</tt> options, however, all files are listed before all variables.

</dd>

<dt><tt>-V</tt> <var>name</var></dt>

<dd>

Like <tt>-J</tt>, but matches within the group will not be sorted in listings nor in menu completion. These unsorted groups are in a different name space from the sorted ones, so groups defined as <tt>-J files</tt> and <tt>-V files</tt> are distinct.

</dd>

<dt><tt>-1</tt></dt>

<dd>

If given together with the <tt>-V</tt> option, makes only consecutive duplicates in the group be removed. Note that groups with and without this flag are in different name spaces.

</dd>

<dt><tt>-2</tt></dt>

<dd>

If given together with the <tt>-J</tt> or <tt>-V</tt> option, makes all duplicates be kept. Again, groups with and without this flag are in different name spaces.

</dd>

<dt><tt>-M</tt> <var>match-spec</var></dt>

<dd>

This defines additional matching control specifications that should be used only when testing words for the list of flags this flag appears in. The format of the <var>match-spec</var> string is described in [Completion Matching Control](Completion-Widgets.html#Completion-Matching-Control).

</dd>

</dl>

---

<a name="Alternative-Completion"></a>

| [ [\<\<](#Completion-Using-compctl) ] | [ [\<](#Control-Flags) ] | [ [Up](#Completion-Using-compctl) ] | [ [\>](#Extended-Completion) ] | [ [>>](Zsh-Modules.html#Zsh-Modules) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Alternative-Completion-1"></a>

21.5 Alternative Completion
---------------------------

<dl compact="compact">

<dt><tt>compctl</tt> [ <tt>-CDT</tt> ] <var>options</var> <tt>+</tt> <var>options</var> [ <tt>+</tt> ... ] [ <tt>+</tt> ] <var>command</var> ...</dt>

</dl>

The form with ‘<tt>\+</tt>’ specifies alternative options. Completion is tried with the options before the first ‘<tt>\+</tt>’. If this produces no matches completion is tried with the flags after the ‘<tt>\+</tt>’ and so on. If there are no flags after the last ‘<tt>\+</tt>’ and a match has not been found up to that point, default completion is tried. If the list of flags contains a <tt>-t</tt> with a <tt>\+</tt> character, the next list of flags is used even if the current list produced matches.

---

<a name="Extended-Completion"></a>

| [ [\<\<](#Completion-Using-compctl) ] | [ [\<](#Alternative-Completion) ] | [ [Up](#Completion-Using-compctl) ] | [ [\>](#Example) ] | [ [>>](Zsh-Modules.html#Zsh-Modules) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

Additional options are available that restrict completion to some part of the command line; this is referred to as ‘extended completion’.

<a name="Extended-Completion-1"></a>

21.6 Extended Completion
------------------------

<dl compact="compact">

<dt><tt>compctl</tt> [ <tt>-CDT</tt> ] <var>options</var> <tt>-x</tt> <var>pattern</var> <var>options</var> <tt>-</tt> ... <tt>-</tt><tt>-</tt></dt>

<dt>[ <var>command</var> ... ]</dt>

<dt><tt>compctl</tt> [ <tt>-CDT</tt> ] <var>options</var> [ <tt>-x</tt> <var>pattern</var> <var>options</var> <tt>-</tt> ... <tt>-</tt><tt>-</tt> ]</dt>

<dt>[ <tt>+</tt> <var>options</var> [ <tt>-x</tt> ... <tt>-</tt><tt>-</tt> ] ... [<tt>+</tt>] ] [ <var>command</var> ... ]</dt>

</dl>

The form with ‘<tt>-x</tt>’ specifies extended completion for the commands given; as shown, it may be combined with alternative completion using ‘<tt>\+</tt>’. Each <var>pattern</var> is examined in turn; when a match is found, the corresponding <var>options</var>, as described in [Option Flags](#Option-Flags) above, are used to generate possible completions. If no <var>pattern</var> matches, the <var>options</var> given before the <tt>-x</tt> are used.

Note that each pattern should be supplied as a single argument and should be quoted to prevent expansion of metacharacters by the shell.

A <var>pattern</var> is built of sub-patterns separated by commas; it matches if at least one of these sub-patterns matches (they are ‘or’ed). These sub-patterns are in turn composed of other sub-patterns separated by white spaces which match if all of the sub-patterns match (they are ‘and’ed). An element of the sub-patterns is of the form ‘<var>c</var><tt>\[</tt>...<tt>\]\[</tt>...<tt>\]</tt>’, where the pairs of brackets may be repeated as often as necessary, and matches if any of the sets of brackets match (an ‘or’). The example below makes this clearer.

The elements may be any of the following:

<dl compact="compact">

<dt><tt>s[</tt><var>string</var><tt>]</tt>...</dt>

<dd>

Matches if the current word on the command line starts with one of the strings given in brackets. The <var>string</var> is not removed and is not part of the completion.

</dd>

<dt><tt>S[</tt><var>string</var><tt>]</tt>...</dt>

<dd>

Like <tt>s[</tt><var>string</var><tt>]</tt> except that the <var>string</var> is part of the completion.

</dd>

<dt><tt>p[</tt><var>from</var><tt>,</tt><var>to</var><tt>]</tt>...</dt>

<dd>

Matches if the number of the current word is between one of the <var>from</var> and <var>to</var> pairs inclusive. The comma and <var>to</var> are optional; <var>to</var> defaults to the same value as <var>from</var>. The numbers may be negative: <tt>-</tt><var>n</var> refers to the <var>n</var>’th last word on the line.

</dd>

<dt><tt>c[</tt><var>offset</var><tt>,</tt><var>string</var><tt>]</tt>...</dt>

<dd>

Matches if the <var>string</var> matches the word offset by <var>offset</var> from the current word position. Usually <var>offset</var> will be negative.

</dd>

<dt><tt>C[</tt><var>offset</var><tt>,</tt><var>pattern</var><tt>]</tt>...</dt>

<dd>

Like <tt>c</tt> but using pattern matching instead.

</dd>

<dt><tt>w[</tt><var>index</var><tt>,</tt><var>string</var><tt>]</tt>...</dt>

<dd>

Matches if the word in position <var>index</var> is equal to the corresponding <var>string</var>. Note that the word count is made after any alias expansion.

</dd>

<dt><tt>W[</tt><var>index</var><tt>,</tt><var>pattern</var><tt>]</tt>...</dt>

<dd>

Like <tt>w</tt> but using pattern matching instead.

</dd>

<dt><tt>n[</tt><var>index</var><tt>,</tt><var>string</var><tt>]</tt>...</dt>

<dd>

Matches if the current word contains <var>string</var>. Anything up to and including the <var>index</var>th occurrence of this string will not be considered part of the completion, but the rest will. <var>index</var> may be negative to count from the end: in most cases, <var>index</var> will be 1 or -1\. For example,

<div class="example">

<pre class="example">compctl -s '`users`' -x 'n[1,@]' -k hosts -- talk
</pre>

</div>

will usually complete usernames, but if you insert an <tt>@</tt> after the name, names from the array <var>hosts</var> (assumed to contain hostnames, though you must make the array yourself) will be completed. Other commands such as <tt>rcp</tt> can be handled similarly.

</dd>

<dt><tt>N[</tt><var>index</var><tt>,</tt><var>string</var><tt>]</tt>...</dt>

<dd>

Like <tt>n</tt> except that the string will be taken as a character class. Anything up to and including the <var>index</var>th occurrence of any of the characters in <var>string</var> will not be considered part of the completion.

</dd>

<dt><tt>m[</tt><var>min</var><tt>,</tt><var>max</var><tt>]</tt>...</dt>

<dd>

Matches if the total number of words lies between <var>min</var> and <var>max</var> inclusive.

</dd>

<dt><tt>r[</tt><var>str1</var><tt>,</tt><var>str2</var><tt>]</tt>...</dt>

<dd>

Matches if the cursor is after a word with prefix <var>str1</var>. If there is also a word with prefix <var>str2</var> on the command line after the one matched by <var>str1</var> it matches only if the cursor is before this word. If the comma and <var>str2</var> are omitted, it matches if the cursor is after a word with prefix <var>str1</var>.

</dd>

<dt><tt>R[</tt><var>str1</var><tt>,</tt><var>str2</var><tt>]</tt>...</dt>

<dd>

Like <tt>r</tt> but using pattern matching instead.

</dd>

<dt><tt>q[</tt><var>str</var><tt>]</tt>...</dt>

<dd>

Matches the word currently being completed is in single quotes and the <var>str</var> begins with the letter ‘s’, or if completion is done in double quotes and <var>str</var> starts with the letter ‘d’, or if completion is done in backticks and <var>str</var> starts with a ‘b’.

</dd>

</dl>

---

<a name="Example"></a>

| [ [\<\<](#Completion-Using-compctl) ] | [ [\<](#Extended-Completion) ] | [ [Up](#Completion-Using-compctl) ] | [ [\>](Zsh-Modules.html#Zsh-Modules) ] | [ [>>](Zsh-Modules.html#Zsh-Modules) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Example-1"></a>

21.7 Example
------------

<div class="example">

<pre class="example">compctl -u -x 's[+] c[-1,-f],s[-f+]' \ 
  -g '~/Mail/*(:t)' - 's[-f],c[-1,-f]' -f -- mail
</pre>

</div>

This is to be interpreted as follows:

If the current command is <tt>mail</tt>, then

> if ((the current word begins with <tt>\+</tt> and the previous word is <tt>-f</tt>) or (the current word begins with <tt>-f+</tt>)), then complete the non-directory part (the ‘<tt>:t</tt>’ glob modifier) of files in the directory <tt>~/Mail</tt>; else
>
> if the current word begins with <tt>-f</tt> or the previous word was <tt>-f</tt>, then complete any file; else
>
> complete user names.

---

| [ [\<\<](#Completion-Using-compctl) ] | [ [>>](Zsh-Modules.html#Zsh-Modules) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<font size="-1">This document was generated on *July 30, 2016* using [*texi2html 5.0*](http://www.nongnu.org/texi2html/).</font>
