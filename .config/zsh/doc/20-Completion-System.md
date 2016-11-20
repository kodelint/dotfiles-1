<a name="Completion-System"></a>

| [ [\<\<](Completion-Widgets.html#Completion-Widgets) ] | [ [\<](Completion-Widgets.html#Completion-Widget-Example) ] | [ [Up](index.html#Top) ] | [ [\>](#Description-9) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Completion-System-1"></a>

20 Completion System
====================

<a name="index-completion-system"></a><a name="index-completion_002c-programmable-1"></a><a name="index-completion_002c-controlling-1"></a>

---

<a name="Description-9"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Completion-System) ] | [ [Up](#Completion-System) ] | [ [\>](#Initialization) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

20.1 Description
----------------

This describes the shell code for the ‘new’ completion system, referred to as <tt>compsys</tt>. It is written in shell functions based on the features described in the previous chapter, [Completion Widgets](Completion-Widgets.html#Completion-Widgets).

The features are contextual, sensitive to the point at which completion is started. Many completions are already provided. For this reason, a user can perform a great many tasks without knowing any details beyond how to initialize the system, which is described in [Initialization](#Initialization).

The context that decides what completion is to be performed may be

-	an argument or option position: these describe the position on the command line at which completion is requested. For example ‘first argument to rmdir, the word being completed names a directory’;
-	a special context, denoting an element in the shell’s syntax. For example ‘a word in command position’ or ‘an array subscript’.

A full context specification contains other elements, as we shall describe.

Besides commands names and contexts, the system employs two more concepts, *styles* and *tags*. These provide ways for the user to configure the system’s behaviour.

Tags play a dual role. They serve as a classification system for the matches, typically indicating a class of object that the user may need to distinguish. For example, when completing arguments of the <tt>ls</tt> command the user may prefer to try <tt>files</tt> before <tt>directories</tt>, so both of these are tags. They also appear as the rightmost element in a context specification.

Styles modify various operations of the completion system, such as output formatting, but also what kinds of completers are used (and in what order), or which tags are examined. Styles may accept arguments and are manipulated using the <tt>zstyle</tt> command described in [The zsh/zutil Module](Zsh-Modules.html#The-zsh_002fzutil-Module).

In summary, tags describe *what* the completion objects are, and style <tt>how</tt> they are to be completed. At various points of execution, the completion system checks what styles and/or tags are defined for the current context, and uses that to modify its behavior. The full description of context handling, which determines how tags and other elements of the context influence the behaviour of styles, is described in [Completion System Configuration](#Completion-System-Configuration).

When a completion is requested, a dispatcher function is called; see the description of <tt>_main_complete</tt> in the list of control functions below. This dispatcher decides which function should be called to produce the completions, and calls it. The result is passed to one or more *completers*, functions that implement individual completion strategies: simple completion, error correction, completion with error correction, menu selection, etc.

More generally, the shell functions contained in the completion system are of two types:

-	those beginning ‘<tt>comp</tt>’ are to be called directly; there are only a few of these;
-	those beginning ‘<tt>\_</tt>’ are called by the completion code. The shell functions of this set, which implement completion behaviour and may be bound to keystrokes, are referred to as ‘widgets’. These proliferate as new completions are required.

| [20.2 Initialization](#Initialization) | | [20.3 Completion System Configuration](#Completion-System-Configuration) | | [20.4 Control Functions](#Control-Functions) | | [20.5 Bindable Commands](#Bindable-Commands) | | [20.6 Utility Functions](#Completion-Functions) | | [20.7 Completion Directories](#Completion-Directories) |

---

<a name="Initialization"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Description-9) ] | [ [Up](#Completion-System) ] | [ [\>](#Use-of-compinit) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Initialization-1"></a>

20.2 Initialization
-------------------

<a name="index-compinstall"></a><a name="index-completion-system_002c-installing"></a>

If the system was installed completely, it should be enough to call the shell function <tt>compinit</tt> from your initialization file; see the next section. However, the function <tt>compinstall</tt> can be run by a user to configure various aspects of the completion system.

Usually, <tt>compinstall</tt> will insert code into <tt>.zshrc</tt>, although if that is not writable it will save it in another file and tell you that file’s location. Note that it is up to you to make sure that the lines added to <tt>.zshrc</tt> are actually run; you may, for example, need to move them to an earlier place in the file if <tt>.zshrc</tt> usually returns early. So long as you keep them all together (including the comment lines at the start and finish), you can rerun <tt>compinstall</tt> and it will correctly locate and modify these lines. Note, however, that any code you add to this section by hand is likely to be lost if you rerun <tt>compinstall</tt>, although lines using the command ‘<tt>zstyle</tt>’ should be gracefully handled.

The new code will take effect next time you start the shell, or run <tt>.zshrc</tt> by hand; there is also an option to make them take effect immediately. However, if <tt>compinstall</tt> has removed definitions, you will need to restart the shell to see the changes.

To run <tt>compinstall</tt> you will need to make sure it is in a directory mentioned in your <tt>fpath</tt> parameter, which should already be the case if zsh was properly configured as long as your startup files do not remove the appropriate directories from <tt>fpath</tt>. Then it must be autoloaded (‘<tt>autoload -U compinstall</tt>’ is recommended). You can abort the installation any time you are being prompted for information, and your <tt>.zshrc</tt> will not be altered at all; changes only take place right at the end, where you are specifically asked for confirmation.

---

<a name="Use-of-compinit"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Initialization) ] | [ [Up](#Initialization) ] | [ [\>](#Autoloaded-files) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

### 20.2.1 Use of compinit

<a name="index-compinit"></a><a name="index-completion-system_002c-initializing"></a>

This section describes the use of <tt>compinit</tt> to initialize completion for the current session when called directly; if you have run <tt>compinstall</tt> it will be called automatically from your <tt>.zshrc</tt>.

To initialize the system, the function <tt>compinit</tt> should be in a directory mentioned in the <tt>fpath</tt> parameter, and should be autoloaded (‘<tt>autoload -U compinit</tt>’ is recommended), and then run simply as ‘<tt>compinit</tt>’. This will define a few utility functions, arrange for all the necessary shell functions to be autoloaded, and will then re-define all widgets that do completion to use the new system. If you use the <tt>menu-select</tt> widget, which is part of the <tt>zsh/complist</tt> module, you should make sure that that module is loaded before the call to <tt>compinit</tt> so that that widget is also re-defined. If completion styles (see below) are set up to perform expansion as well as completion by default, and the TAB key is bound to <tt>expand-or-complete</tt>, <tt>compinit</tt> will rebind it to <tt>complete-word</tt>; this is necessary to use the correct form of expansion.

Should you need to use the original completion commands, you can still bind keys to the old widgets by putting a ‘<tt>.</tt>’ in front of the widget name, e.g. ‘<tt>.expand-or-complete</tt>’.

To speed up the running of <tt>compinit</tt>, it can be made to produce a dumped configuration that will be read in on future invocations; this is the default, but can be turned off by calling <tt>compinit</tt> with the option <tt>-D</tt>. The dumped file is <tt>.zcompdump</tt> in the same directory as the startup files (i.e. <tt>$ZDOTDIR</tt> or <tt>$HOME</tt>); alternatively, an explicit file name can be given by ‘<tt>compinit -d</tt> <var>dumpfile</var>’. The next invocation of <tt>compinit</tt> will read the dumped file instead of performing a full initialization.

If the number of completion files changes, <tt>compinit</tt> will recognise this and produce a new dump file. However, if the name of a function or the arguments in the first line of a <tt>#compdef</tt> function (as described below) change, it is easiest to delete the dump file by hand so that <tt>compinit</tt> will re-create it the next time it is run. The check performed to see if there are new functions can be omitted by giving the option <tt>-C</tt>. In this case the dump file will only be created if there isn’t one already.

The dumping is actually done by another function, <tt>compdump</tt>, but you will only need to run this yourself if you change the configuration (e.g. using <tt>compdef</tt>) and then want to dump the new one. The name of the old dumped file will be remembered for this purpose.

If the parameter <tt>_compdir</tt> is set, <tt>compinit</tt> uses it as a directory where completion functions can be found; this is only necessary if they are not already in the function search path.

For security reasons <tt>compinit</tt> also checks if the completion system would use files not owned by root or by the current user, or files in directories that are world- or group-writable or that are not owned by root or by the current user. If such files or directories are found, <tt>compinit</tt> will ask if the completion system should really be used. To avoid these tests and make all files found be used without asking, use the option <tt>-u</tt>, and to make <tt>compinit</tt> silently ignore all insecure files and directories use the option <tt>-i</tt>. This security check is skipped entirely when the <tt>-C</tt> option is given.

<a name="index-compaudit"></a>

The security check can be retried at any time by running the function <tt>compaudit</tt>. This is the same check used by <tt>compinit</tt>, but when it is executed directly any changes to <tt>fpath</tt> are made local to the function so they do not persist. The directories to be checked may be passed as arguments; if none are given, <tt>compaudit</tt> uses <tt>fpath</tt> and <tt>_compdir</tt> to find completion system directories, adding missing ones to <tt>fpath</tt> as necessary. To force a check of exactly the directories currently named in <tt>fpath</tt>, set <tt>_compdir</tt> to an empty string before calling <tt>compaudit</tt> or <tt>compinit</tt>.

<a name="index-bashcompinit"></a>

The function <tt>bashcompinit</tt> provides compatibility with bash’s programmable completion system. When run it will define the functions, <tt>compgen</tt> and <tt>complete</tt> which correspond to the bash builtins with the same names. It will then be possible to use completion specifications and functions written for bash.

---

<a name="Autoloaded-files"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Use-of-compinit) ] | [ [Up](#Initialization) ] | [ [\>](#Functions-2) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

### 20.2.2 Autoloaded files

<a name="index-completion-system_002c-autoloaded-functions"></a>

The convention for autoloaded functions used in completion is that they start with an underscore; as already mentioned, the <tt>fpath/FPATH</tt> parameter must contain the directory in which they are stored. If <tt>zsh</tt> was properly installed on your system, then <tt>fpath/FPATH</tt> automatically contains the required directories for the standard functions.

For incomplete installations, if <tt>compinit</tt> does not find enough files beginning with an underscore (fewer than twenty) in the search path, it will try to find more by adding the directory <tt>_compdir</tt> to the search path. If that directory has a subdirectory named <tt>Base</tt>, all subdirectories will be added to the path. Furthermore, if the subdirectory <tt>Base</tt> has a subdirectory named <tt>Core</tt>, <tt>compinit</tt> will add all subdirectories of the subdirectories to the path: this allows the functions to be in the same format as in the <tt>zsh</tt> source distribution.

<a name="index-compdef_002c-use-of-by-compinit"></a>

When <tt>compinit</tt> is run, it searches all such files accessible via <tt>fpath/FPATH</tt> and reads the first line of each of them. This line should contain one of the tags described below. Files whose first line does not start with one of these tags are not considered to be part of the completion system and will not be treated specially.

The tags are:

<dl compact="compact">

<dt><tt>#compdef</tt> <var>name</var> ... [ <tt>-</tt>{<tt>p</tt>|<tt>P</tt>} <var>pattern</var> ... [ <tt>-N</tt> <var>name</var> ... ] ]</dt>

<dd>

The file will be made autoloadable and the function defined in it will be called when completing <var>name</var>s, each of which is either the name of a command whose arguments are to be completed or one of a number of special contexts in the form <tt>-</tt><var>context</var><tt>-</tt> described below.

Each <var>name</var> may also be of the form ‘<var>cmd</var><tt>=</tt><var>service</var>’. When completing the command <var>cmd</var>, the function typically behaves as if the command (or special context) <var>service</var> was being completed instead. This provides a way of altering the behaviour of functions that can perform many different completions. It is implemented by setting the parameter <tt>$service</tt> when calling the function; the function may choose to interpret this how it wishes, and simpler functions will probably ignore it.

If the <tt>#compdef</tt> line contains one of the options <tt>-p</tt> or <tt>-P</tt>, the words following are taken to be patterns. The function will be called when completion is attempted for a command or context that matches one of the patterns. The options <tt>-p</tt> and <tt>-P</tt> are used to specify patterns to be tried before or after other completions respectively. Hence <tt>-P</tt> may be used to specify default actions.

The option <tt>-N</tt> is used after a list following <tt>-p</tt> or <tt>-P</tt>; it specifies that remaining words no longer define patterns. It is possible to toggle between the three options as many times as necessary.

</dd>

<dt><tt>#compdef -k</tt> <var>style key-sequence</var> ...</dt>

<dd>

This option creates a widget behaving like the builtin widget <var>style</var> and binds it to the given <var>key-sequence</var>s, if any. The <var>style</var> must be one of the builtin widgets that perform completion, namely <tt>complete-word</tt>, <tt>delete-char-or-list</tt>, <tt>expand-or-complete</tt>, <tt>expand-or-complete-prefix</tt>, <tt>list-choices</tt>, <tt>menu-complete</tt>, <tt>menu-expand-or-complete</tt>, or <tt>reverse-menu-complete</tt>. If the <tt>zsh/complist</tt> module is loaded (see [The zsh/complist Module](Zsh-Modules.html#The-zsh_002fcomplist-Module)) the widget <tt>menu-select</tt> is also available.

When one of the <var>key-sequence</var>s is typed, the function in the file will be invoked to generate the matches. Note that a key will not be re-bound if it already was (that is, was bound to something other than <tt>undefined-key</tt>). The widget created has the same name as the file and can be bound to any other keys using <tt>bindkey</tt> as usual.

</dd>

<dt><tt>#compdef -K</tt> <var>widget-name</var> <var>style</var> <var>key-sequence</var> [ <var>name</var> <var>style</var> <var>seq</var> ... ]</dt>

<dd>

This is similar to <tt>-k</tt> except that only one <var>key-sequence</var> argument may be given for each <var>widget-name</var> <var>style</var> pair. However, the entire set of three arguments may be repeated with a different set of arguments. Note in particular that the <var>widget-name</var> must be distinct in each set. If it does not begin with ‘<tt>_</tt>’ this will be added. The <var>widget-name</var> should not clash with the name of any existing widget: names based on the name of the function are most useful. For example,

<div class="example">

<pre class="example">#compdef -K _foo_complete complete-word "^X^C" \ 
  _foo_list list-choices "^X^D"
</pre>

</div>

(all on one line) defines a widget <tt>_foo_complete</tt> for completion, bound to ‘<tt>^X^C</tt>’, and a widget <tt>_foo_list</tt> for listing, bound to ‘<tt>^X^D</tt>’.

</dd>

<dt><tt>#autoload</tt> [ <var>options</var> ]</dt>

<dd>

Functions with the <tt>#autoload</tt> tag are marked for autoloading but are not otherwise treated specially. Typically they are to be called from within one of the completion functions. Any <var>options</var> supplied will be passed to the <tt>autoload</tt> builtin; a typical use is <tt>+X</tt> to force the function to be loaded immediately. Note that the <tt>-U</tt> and <tt>-z</tt> flags are always added implicitly.

</dd>

</dl>

The <tt>\#</tt> is part of the tag name and no white space is allowed after it. The <tt>#compdef</tt> tags use the <tt>compdef</tt> function described below; the main difference is that the name of the function is supplied implicitly.

The special contexts for which completion functions can be defined are:

<dl compact="compact">

<dd><a name="index-_002darray_002dvalue_002d_002c-completion-context"></a></dd>

<dt><tt>-array-value-</tt></dt>

<dd>

The right hand side of an array-assignment (‘<var>name</var><tt>=(</tt><var>...</var><tt>)</tt>’)

<a name="index-_002dbrace_002dparameter_002d_002c-completion-context"></a></dd>

<dt><tt>-brace-parameter-</tt></dt>

<dd>

The name of a parameter expansion within braces (‘<tt>${</tt><var>...</var><tt>}</tt>’)

<a name="index-_002dassign_002dparameter_002d_002c-completion-context"></a></dd>

<dt><tt>-assign-parameter-</tt></dt>

<dd>

The name of a parameter in an assignment, i.e. on the left hand side of an ‘<tt>=</tt>’

<a name="index-_002dcommand_002d_002c-completion-context"></a></dd>

<dt><tt>-command-</tt></dt>

<dd>

A word in command position

<a name="index-_002dcondition_002d_002c-completion-context"></a></dd>

<dt><tt>-condition-</tt></dt>

<dd>

A word inside a condition (‘<tt>[[</tt><var>...</var><tt>]]</tt>’)

<a name="index-_002ddefault_002d_002c-completion-context"></a></dd>

<dt><tt>-default-</tt></dt>

<dd>

Any word for which no other completion is defined

<a name="index-_002dequal_002d_002c-completion-context"></a></dd>

<dt><tt>-equal-</tt></dt>

<dd>

A word beginning with an equals sign

<a name="index-_002dfirst_002d_002c-completion-context"></a></dd>

<dt><tt>-first-</tt></dt>

<dd>

This is tried before any other completion function. The function called may set the <tt>_compskip</tt> parameter to one of various values: <tt>all</tt>: no further completion is attempted; a string containing the substring <tt>patterns</tt>: no pattern completion functions will be called; a string containing <tt>default</tt>: the function for the ‘<tt>-default-</tt>’ context will not be called, but functions defined for commands will be.

<a name="index-_002dmath_002d_002c-completion-context"></a></dd>

<dt><tt>-math-</tt></dt>

<dd>

Inside mathematical contexts, such as ‘<tt>((</tt><var>...</var><tt>))</tt>’

<a name="index-_002dparameter_002d_002c-completion-context"></a></dd>

<dt><tt>-parameter-</tt></dt>

<dd>

The name of a parameter expansion (‘<tt>$</tt><var>...</var>’)

<a name="index-_002dredirect_002d_002c-completion-context"></a></dd>

<dt><tt>-redirect-</tt></dt>

<dd>

The word after a redirection operator.

<a name="index-_002dsubscript_002d_002c-completion-context"></a></dd>

<dt><tt>-subscript-</tt></dt>

<dd>

The contents of a parameter subscript.

<a name="index-_002dtilde_002d_002c-completion-context"></a></dd>

<dt><tt>-tilde-</tt></dt>

<dd>

After an initial tilde (‘<tt>~</tt>’), but before the first slash in the word.

<a name="index-_002dvalue_002d_002c-completion-context"></a></dd>

<dt><tt>-value-</tt></dt>

<dd>

On the right hand side of an assignment.

</dd>

</dl>

Default implementations are supplied for each of these contexts. In most cases the context <tt>\-</tt><var>context</var><tt>\-</tt> is implemented by a corresponding function <tt>\_</tt><var>context</var>, for example the context ‘<tt>-tilde-</tt>’ and the function ‘<tt>_tilde</tt>’).

The contexts <tt>-redirect-</tt> and <tt>-value-</tt> allow extra context-specific information. (Internally, this is handled by the functions for each context calling the function <tt>_dispatch</tt>.) The extra information is added separated by commas.

For the <tt>-redirect-</tt> context, the extra information is in the form ‘<tt>-redirect-,</tt><var>op</var><tt>,</tt><var>command</var>’, where <var>op</var> is the redirection operator and <var>command</var> is the name of the command on the line. If there is no command on the line yet, the <var>command</var> field will be empty.

For the <tt>-value-</tt> context, the form is ‘<tt>-value-,</tt><var>name</var><tt>,</tt><var>command</var>’, where <var>name</var> is the name of the parameter on the left hand side of the assignment. In the case of elements of an associative array, for example ‘<tt>assoc=(key <TAB></tt>’, <var>name</var> is expanded to ‘<var>name</var><tt>\-</tt><var>key</var>’. In certain special contexts, such as completing after ‘<tt>make CFLAGS=</tt>’, the <var>command</var> part gives the name of the command, here <tt>make</tt>; otherwise it is empty.

It is not necessary to define fully specific completions as the functions provided will try to generate completions by progressively replacing the elements with ‘<tt>-default-</tt>’. For example, when completing after ‘<tt>foo=<TAB></tt>’, <tt>_value</tt> will try the names ‘<tt>-value-,foo,</tt>’ (note the empty <var>command</var> part), ‘<tt>-value-,foo,-default-</tt>’ and‘<tt>-value-,-default-,-default-</tt>’, in that order, until it finds a function to handle the context.

As an example:

<div class="example">

<pre class="example">compdef '_files -g "*.log"' '-redirect-,2>,-default-'
</pre>

</div>

completes files matching ‘<tt>*.log</tt>’ after ‘<tt>2> <TAB></tt>’ for any command with no more specific handler defined.

Also:

<div class="example">

<pre class="example">compdef _foo -value-,-default-,-default-
</pre>

</div>

specifies that <tt>_foo</tt> provides completions for the values of parameters for which no special function has been defined. This is usually handled by the function <tt>_value</tt> itself.

The same lookup rules are used when looking up styles (as described below); for example

<div class="example">

<pre class="example">zstyle ':completion:*:*:-redirect-,2>,*:*' file-patterns '*.log'
</pre>

</div>

is another way to make completion after ‘<tt>2> <TAB></tt>’ complete files matching ‘<tt>*.log</tt>’.

---

<a name="Functions-2"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Autoloaded-files) ] | [ [Up](#Initialization) ] | [ [\>](#Completion-System-Configuration) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

### 20.2.3 Functions

The following function is defined by <tt>compinit</tt> and may be called directly.

<a name="index-compdef"></a><a name="index-completion-system_002c-adding-definitions"></a>

<dl compact="compact">

<dt><tt>compdef</tt> [ <tt>-ane</tt> ] <var>function name</var> ... [ <tt>-</tt>{<tt>p</tt>|<tt>P</tt>} <var>pattern</var> ... [ <tt>-N</tt> <var>name</var> ...]]</dt>

<dt><tt>compdef -d</tt> <var>name</var> ...</dt>

<dt><tt>compdef -k</tt> [ <tt>-an</tt> ] <var>function style key-sequence</var> [ <var>key-sequence</var> ... ]</dt>

<dt><tt>compdef -K</tt> [ <tt>-an</tt> ] <var>function name style key-seq</var> [ <var>name style seq</var> ... ]</dt>

<dd>

The first form defines the <var>function</var> to call for completion in the given contexts as described for the <tt>#compdef</tt> tag above.

Alternatively, all the arguments may have the form ‘<var>cmd</var><tt>=</tt><var>service</var>’. Here <var>service</var> should already have been defined by ‘<var>cmd1</var><tt>=</tt><var>service</var>’ lines in <tt>#compdef</tt> files, as described above. The argument for <var>cmd</var> will be completed in the same way as <var>service</var>.

The <var>function</var> argument may alternatively be a string containing almost any shell code. If the string contains an equal sign, the above will take precedence. The option <tt>-e</tt> may be used to specify the first argument is to be evaluated as shell code even if it contains an equal sign. The string will be executed using the <tt>eval</tt> builtin command to generate completions. This provides a way of avoiding having to define a new completion function. For example, to complete files ending in ‘<tt>.h</tt>’ as arguments to the command <tt>foo</tt>:

<div class="example">

<pre class="example">compdef '_files -g "*.h"' foo
</pre>

</div>

The option <tt>-n</tt> prevents any completions already defined for the command or context from being overwritten.

The option <tt>-d</tt> deletes any completion defined for the command or contexts listed.

The <var>name</var>s may also contain <tt>-p</tt>, <tt>-P</tt> and <tt>-N</tt> options as described for the <tt>#compdef</tt> tag. The effect on the argument list is identical, switching between definitions of patterns tried initially, patterns tried finally, and normal commands and contexts.

The parameter <tt>$_compskip</tt> may be set by any function defined for a pattern context. If it is set to a value containing the substring ‘<tt>patterns</tt>’ none of the pattern-functions will be called; if it is set to a value containing the substring ‘<tt>all</tt>’, no other function will be called.

The form with <tt>-k</tt> defines a widget with the same name as the <var>function</var> that will be called for each of the <var>key-sequence</var>s; this is like the <tt>#compdef -k</tt> tag. The function should generate the completions needed and will otherwise behave like the builtin widget whose name is given as the <var>style</var> argument. The widgets usable for this are: <tt>complete-word</tt>, <tt>delete-char-or-list</tt>, <tt>expand-or-complete</tt>, <tt>expand-or-complete-prefix</tt>, <tt>list-choices</tt>, <tt>menu-complete</tt>, <tt>menu-expand-or-complete</tt>, and <tt>reverse-menu-complete</tt>, as well as <tt>menu-select</tt> if the <tt>zsh/complist</tt> module is loaded. The option <tt>-n</tt> prevents the key being bound if it is already to bound to something other than <tt>undefined-key</tt>.

The form with <tt>-K</tt> is similar and defines multiple widgets based on the same <var>function</var>, each of which requires the set of three arguments <var>name</var>, <var>style</var> and <var>key-seq</var>uence, where the latter two are as for <tt>-k</tt> and the first must be a unique widget name beginning with an underscore.

Wherever applicable, the <tt>-a</tt> option makes the <var>function</var> autoloadable, equivalent to <tt>autoload -U</tt> <var>function</var>.

</dd>

</dl>

The function <tt>compdef</tt> can be used to associate existing completion functions with new commands. For example,

<div class="example">

<pre class="example">compdef _pids foo
</pre>

</div>

uses the function <tt>_pids</tt> to complete process IDs for the command <tt>foo</tt>.

Note also the <tt>_gnu_generic</tt> function described below, which can be used to complete options for commands that understand the ‘<tt>\-</tt><tt>-help</tt>’ option.

---

<a name="Completion-System-Configuration"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Functions-2) ] | [ [Up](#Completion-System) ] | [ [\>](#Overview-1) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Completion-System-Configuration-1"></a>

20.3 Completion System Configuration
------------------------------------

<a name="index-completion-system_002c-configuration"></a>

This section gives a short overview of how the completion system works, and then more detail on how users can configure how and when matches are generated.

---

<a name="Overview-1"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Completion-System-Configuration) ] | [ [Up](#Completion-System-Configuration) ] | [ [\>](#Standard-Tags) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

### 20.3.1 Overview

When completion is attempted somewhere on the command line the completion system begins building the context. The context represents everything that the shell knows about the meaning of the command line and the significance of the cursor position. This takes account of a number of things including the command word (such as ‘<tt>grep</tt>’ or ‘<tt>zsh</tt>’) and options to which the current word may be an argument (such as the ‘<tt>-o</tt>’ option to <tt>zsh</tt> which takes a shell option as an argument).

The context starts out very generic ("we are beginning a completion") and becomes more specific as more is learned ("the current word is in a position that is usually a command name" or "the current word might be a variable name" and so on). Therefore the context will vary during the same call to the completion system.

This context information is condensed into a string consisting of multiple fields separated by colons, referred to simply as ‘the context’ in the remainder of the documentation. Note that a user of the completion system rarely needs to compose a context string, unless for example a new function is being written to perform completion for a new command. What a user may need to do is compose a *style* pattern, which is matched against a context when needed to look up context-sensitive options that configure the completion system.

The next few paragraphs explain how a context is composed within the completion function suite. Following that is discussion of how *styles* are defined. Styles determine such things as how the matches are generated, similarly to shell options but with much more control. They are defined with the <tt>zstyle</tt> builtin command ([The zsh/zutil Module](Zsh-Modules.html#The-zsh_002fzutil-Module)).

The context string always consists of a fixed set of fields, separated by colons and with a leading colon before the first. Fields which are not yet known are left empty, but the surrounding colons appear anyway. The fields are always in the order <tt>:completion:</tt><var>function</var><tt>:</tt><var>completer</var><tt>:</tt><var>command</var><tt>:</tt><var>argument</var><tt>:</tt><var>tag</var>. These have the following meaning:

-	The literal string <tt>completion</tt>, saying that this style is used by the completion system. This distinguishes the context from those used by, for example, zle widgets and ZFTP functions.
-	The <var>function</var>, if completion is called from a named widget rather than through the normal completion system. Typically this is blank, but it is set by special widgets such as <tt>predict-on</tt> and the various functions in the <tt>Widget</tt> directory of the distribution to the name of that function, often in an abbreviated form.
-	The <var>completer</var> currently active, the name of the function without the leading underscore and with other underscores converted to hyphens. A ‘completer’ is in overall control of how completion is to be performed; ‘<tt>complete</tt>’ is the simplest, but other completers exist to perform related tasks such as correction, or to modify the behaviour of a later completer. See [Control Functions](#Control-Functions) for more information.
-	The <var>command</var> or a special <tt>\-</tt><var>context</var><tt>\-</tt>, just at it appears following the <tt>#compdef</tt> tag or the <tt>compdef</tt> function. Completion functions for commands that have sub-commands usually modify this field to contain the name of the command followed by a minus sign and the sub-command. For example, the completion function for the <tt>cvs</tt> command sets this field to <tt>cvs-add</tt> when completing arguments to the <tt>add</tt> subcommand.
-	The <var>argument</var>; this indicates which command line or option argument we are completing. For command arguments this generally takes the form <tt>argument-</tt><var>n</var>, where <var>n</var> is the number of the argument, and for arguments to options the form <tt>option-</tt><var>opt</var><tt>\-</tt><var>n</var> where <var>n</var> is the number of the argument to option <var>opt</var>. However, this is only the case if the command line is parsed with standard UNIX-style options and arguments, so many completions do not set this.
-	The <var>tag</var>. As described previously, tags are used to discriminate between the types of matches a completion function can generate in a certain context. Any completion function may use any tag name it likes, but a list of the more common ones is given below.

The context is gradually put together as the functions are executed, starting with the main entry point, which adds <tt>:completion:</tt> and the <var>function</var> element if necessary. The completer then adds the <var>completer</var> element. The contextual completion adds the <var>command</var> and <var>argument</var> options. Finally, the <var>tag</var> is added when the types of completion are known. For example, the context name

<div class="example">

<pre class="example"><tt>:completion::complete:dvips:option-o-1:files</tt>
</pre>

</div>

says that normal completion was attempted as the first argument to the option <tt>-o</tt> of the command <tt>dvips</tt>:

<div class="example">

<pre class="example"><tt>dvips -o ...</tt>
</pre>

</div>

and the completion function will generate filenames.

Usually completion will be tried for all possible tags in an order given by the completion function. However, this can be altered by using the <tt>tag-order</tt> style. Completion is then restricted to the list of given tags in the given order.

The <tt>_complete_help</tt> bindable command shows all the contexts and tags available for completion at a particular point. This provides an easy way of finding information for <tt>tag-order</tt> and other styles. It is described in [Bindable Commands](#Bindable-Commands).

When looking up styles the completion system uses full context names, including the tag. Looking up the value of a style therefore consists of two things: the context, which is matched to the most specific (best fitting) style pattern, and the name of the style itself, which must be matched exactly. The following examples demonstrate that style patterns may be loosely defined for styles that apply broadly, or as tightly defined as desired for styles that apply in narrower circumstances.

For example, many completion functions can generate matches in a simple and a verbose form and use the <tt>verbose</tt> style to decide which form should be used. To make all such functions use the verbose form, put

<div class="example">

<pre class="example">zstyle ':completion:*' verbose yes
</pre>

</div>

in a startup file (probably <tt>.zshrc</tt>). This gives the <tt>verbose</tt> style the value <tt>yes</tt> in every context inside the completion system, unless that context has a more specific definition. It is best to avoid giving the context as ‘<tt>\*</tt>’ in case the style has some meaning outside the completion system.

Many such general purpose styles can be configured simply by using the <tt>compinstall</tt> function.

A more specific example of the use of the <tt>verbose</tt> style is by the completion for the <tt>kill</tt> builtin. If the style is set, the builtin lists full job texts and process command lines; otherwise it shows the bare job numbers and PIDs. To turn the style off for this use only:

<div class="example">

<pre class="example">zstyle ':completion:*:*:kill:*:*' verbose no
</pre>

</div>

For even more control, the style can use one of the tags ‘<tt>jobs</tt>’ or ‘<tt>processes</tt>’. To turn off verbose display only for jobs:

<div class="example">

<pre class="example">zstyle ':completion:*:*:kill:*:jobs' verbose no
</pre>

</div>

The <tt>-e</tt> option to <tt>zstyle</tt> even allows completion function code to appear as the argument to a style; this requires some understanding of the internals of completion functions (see [Completion Widgets](Completion-Widgets.html#Completion-Widgets))). For example,

<div class="example">

<pre class="example"><tt>zstyle -e ':completion:*' hosts 'reply=($myhosts)'</tt>
</pre>

</div>

This forces the value of the <tt>hosts</tt> style to be read from the variable <tt>myhosts</tt> each time a host name is needed; this is useful if the value of <tt>myhosts</tt> can change dynamically. For another useful example, see the example in the description of the <tt>file-list</tt> style below. This form can be slow and should be avoided for commonly examined styles such as <tt>menu</tt> and <tt>list-rows-first</tt>.

Note that the order in which styles are *defined* does not matter; the style mechanism uses the most specific possible match for a particular style to determine the set of values. More precisely, strings are preferred over patterns (for example, ‘<tt>:completion::complete:::foo</tt>’ is more specific than ‘<tt>:completion::complete:::*’</tt>), and longer patterns are preferred over shorter patterns.

A good rule of thumb is that any completion style pattern that needs to include more than one wildcard (<tt>\*</tt>) and that does not end in a tag name, should include all six colons (<tt>:</tt>), possibly surrounding additional wildcards.

Style names like those of tags are arbitrary and depend on the completion function. However, the following two sections list some of the most common tags and styles.

---

<a name="Standard-Tags"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Overview-1) ] | [ [Up](#Completion-System-Configuration) ] | [ [\>](#Standard-Styles) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

### 20.3.2 Standard Tags

<a name="index-completion-system_002c-tags"></a>

Some of the following are only used when looking up particular styles and do not refer to a type of match.

<dl compact="compact">

<dd><a name="index-accounts_002c-completion-tag"></a></dd>

<dt><tt>accounts</tt></dt>

<dd>

used to look up the <tt>users-hosts</tt> style

<a name="index-all_002dexpansions_002c-completion-tag"></a></dd>

<dt><tt>all-expansions</tt></dt>

<dd>

used by the <tt>_expand</tt> completer when adding the single string containing all possible expansions

<a name="index-all_002dfiles_002c-completion-tag"></a></dd>

<dt><tt>all-files</tt></dt>

<dd>

for the names of all files (as distinct from a particular subset, see the <tt>globbed-files</tt> tag).

<a name="index-arguments_002c-completion-tag"></a></dd>

<dt><tt>arguments</tt></dt>

<dd>

for arguments to a command

<a name="index-arrays_002c-completion-tag"></a></dd>

<dt><tt>arrays</tt></dt>

<dd>

for names of array parameters

<a name="index-association_002dkeys_002c-completion-tag"></a></dd>

<dt><tt>association-keys</tt></dt>

<dd>

for keys of associative arrays; used when completing inside a subscript to a parameter of this type

<a name="index-bookmarks_002c-completion-tag"></a></dd>

<dt><tt>bookmarks</tt></dt>

<dd>

when completing bookmarks (e.g. for URLs and the <tt>zftp</tt> function suite)

<a name="index-builtins_002c-completion-tag"></a></dd>

<dt><tt>builtins</tt></dt>

<dd>

for names of builtin commands

<a name="index-characters_002c-completion-tag"></a></dd>

<dt><tt>characters</tt></dt>

<dd>

for single characters in arguments of commands such as <tt>stty</tt>. Also used when completing character classes after an opening bracket

<a name="index-colormapids_002c-completion-tag"></a></dd>

<dt><tt>colormapids</tt></dt>

<dd>

for X colormap ids

<a name="index-colors_002c-completion-tag"></a></dd>

<dt><tt>colors</tt></dt>

<dd>

for color names

<a name="index-commands_002c-completion-tag"></a></dd>

<dt><tt>commands</tt></dt>

<dd>

for names of external commands. Also used by complex commands such as <tt>cvs</tt> when completing names subcommands.

<a name="index-contexts_002c-completion-tag"></a></dd>

<dt><tt>contexts</tt></dt>

<dd>

for contexts in arguments to the <tt>zstyle</tt> builtin command

<a name="index-corrections_002c-completion-tag"></a></dd>

<dt><tt>corrections</tt></dt>

<dd>

used by the <tt>_approximate</tt> and <tt>_correct</tt> completers for possible corrections

<a name="index-cursors_002c-completion-tag"></a></dd>

<dt><tt>cursors</tt></dt>

<dd>

for cursor names used by X programs

<a name="index-default_002c-completion-tag"></a></dd>

<dt><tt>default</tt></dt>

<dd>

used in some contexts to provide a way of supplying a default when more specific tags are also valid. Note that this tag is used when only the <var>function</var> field of the context name is set

<a name="index-descriptions_002c-completion-tag"></a></dd>

<dt><tt>descriptions</tt></dt>

<dd>

used when looking up the value of the <tt>format</tt> style to generate descriptions for types of matches

<a name="index-devices_002c-completion-tag"></a></dd>

<dt><tt>devices</tt></dt>

<dd>

for names of device special files

<a name="index-directories_002c-completion-tag"></a></dd>

<dt><tt>directories</tt></dt>

<dd>

for names of directories — <tt>local-directories</tt> is used instead when completing arguments of <tt>cd</tt> and related builtin commands when the <tt>cdpath</tt> array is set

<a name="index-directory_002dstack_002c-completion-tag"></a></dd>

<dt><tt>directory-stack</tt></dt>

<dd>

for entries in the directory stack

<a name="index-displays_002c-completion-tag"></a></dd>

<dt><tt>displays</tt></dt>

<dd>

for X display names

<a name="index-domains_002c-completion-tag"></a></dd>

<dt><tt>domains</tt></dt>

<dd>

for network domains

<a name="index-expansions_002c-completion-tag"></a></dd>

<dt><tt>expansions</tt></dt>

<dd>

used by the <tt>_expand</tt> completer for individual words (as opposed to the complete set of expansions) resulting from the expansion of a word on the command line

<a name="index-extensions_002c-completion-tag"></a></dd>

<dt><tt>extensions</tt></dt>

<dd>

for X server extensions

<a name="index-file_002ddescriptors_002c-completion-tag"></a></dd>

<dt><tt>file-descriptors</tt></dt>

<dd>

for numbers of open file descriptors

<a name="index-files_002c-completion-tag"></a></dd>

<dt><tt>files</tt></dt>

<dd>

the generic file-matching tag used by functions completing filenames

<a name="index-fonts_002c-completion-tag"></a></dd>

<dt><tt>fonts</tt></dt>

<dd>

for X font names

<a name="index-fstypes_002c-completion-tag"></a></dd>

<dt><tt>fstypes</tt></dt>

<dd>

for file system types (e.g. for the <tt>mount</tt> command)

<a name="index-functions_002c-completion-tag"></a></dd>

<dt><tt>functions</tt></dt>

<dd>

names of functions — normally shell functions, although certain commands may understand other kinds of function

<a name="index-globbed_002dfiles_002c-completion-tag"></a></dd>

<dt><tt>globbed-files</tt></dt>

<dd>

for filenames when the name has been generated by pattern matching

<a name="index-groups_002c-completion-tag"></a></dd>

<dt><tt>groups</tt></dt>

<dd>

for names of user groups

<a name="index-history_002dwords_002c-completion-tag"></a></dd>

<dt><tt>history-words</tt></dt>

<dd>

for words from the history

<a name="index-hosts_002c-completion-tag"></a></dd>

<dt><tt>hosts</tt></dt>

<dd>

for hostnames

<a name="index-indexes_002c-completion-tag"></a></dd>

<dt><tt>indexes</tt></dt>

<dd>

for array indexes

<a name="index-jobs_002c-completion-tag"></a></dd>

<dt><tt>jobs</tt></dt>

<dd>

for jobs (as listed by the ‘<tt>jobs</tt>’ builtin)

<a name="index-interfaces_002c-completion-tag"></a></dd>

<dt><tt>interfaces</tt></dt>

<dd>

for network interfaces

<a name="index-keymaps_002c-completion-tag"></a></dd>

<dt><tt>keymaps</tt></dt>

<dd>

for names of zsh keymaps

<a name="index-keysyms_002c-completion-tag"></a></dd>

<dt><tt>keysyms</tt></dt>

<dd>

for names of X keysyms

<a name="index-libraries_002c-completion-tag"></a></dd>

<dt><tt>libraries</tt></dt>

<dd>

for names of system libraries

<a name="index-limits_002c-completion-tag"></a></dd>

<dt><tt>limits</tt></dt>

<dd>

for system limits

<a name="index-local_002ddirectories_002c-completion-tag"></a></dd>

<dt><tt>local-directories</tt></dt>

<dd>

for names of directories that are subdirectories of the current working directory when completing arguments of <tt>cd</tt> and related builtin commands (compare <tt>path-directories</tt>) — when the <tt>cdpath</tt> array is unset, <tt>directories</tt> is used instead

<a name="index-manuals_002c-completion-tag"></a></dd>

<dt><tt>manuals</tt></dt>

<dd>

for names of manual pages

<a name="index-mailboxes_002c-completion-tag"></a></dd>

<dt><tt>mailboxes</tt></dt>

<dd>

for e-mail folders

<a name="index-maps_002c-completion-tag"></a></dd>

<dt><tt>maps</tt></dt>

<dd>

for map names (e.g. NIS maps)

<a name="index-messages_002c-completion-tag"></a></dd>

<dt><tt>messages</tt></dt>

<dd>

used to look up the <tt>format</tt> style for messages

<a name="index-modifiers_002c-completion-tag"></a></dd>

<dt><tt>modifiers</tt></dt>

<dd>

for names of X modifiers

<a name="index-modules_002c-completion-tag"></a></dd>

<dt><tt>modules</tt></dt>

<dd>

for modules (e.g. <tt>zsh</tt> modules)

<a name="index-my_002daccounts_002c-completion-tag"></a></dd>

<dt><tt>my-accounts</tt></dt>

<dd>

used to look up the <tt>users-hosts</tt> style

<a name="index-named_002ddirectories_002c-completion-tag"></a></dd>

<dt><tt>named-directories</tt></dt>

<dd>

for named directories (you wouldn’t have guessed that, would you?)

<a name="index-names_002c-completion-tag"></a></dd>

<dt><tt>names</tt></dt>

<dd>

for all kinds of names

<a name="index-newsgroups_002c-completion-tag"></a></dd>

<dt><tt>newsgroups</tt></dt>

<dd>

for USENET groups

<a name="index-nicknames_002c-completion-tag"></a></dd>

<dt><tt>nicknames</tt></dt>

<dd>

for nicknames of NIS maps

<a name="index-options_002c-completion-tag"></a></dd>

<dt><tt>options</tt></dt>

<dd>

for command options

<a name="index-original_002c-completion-tag"></a></dd>

<dt><tt>original</tt></dt>

<dd>

used by the <tt>_approximate</tt>, <tt>_correct</tt> and <tt>_expand</tt> completers when offering the original string as a match

<a name="index-other_002daccounts_002c-completion-tag"></a></dd>

<dt><tt>other-accounts</tt></dt>

<dd>

used to look up the <tt>users-hosts</tt> style

<a name="index-other_002dfiles_002c-completion-tag"></a></dd>

<dt><tt>other-files</tt></dt>

<dd>

for the names of any non-directory files. This is used instead of <tt>all-files</tt> when the <tt>list-dirs-first</tt> style is in effect.

<a name="index-packages_002c-completion-tag"></a></dd>

<dt><tt>packages</tt></dt>

<dd>

for packages (e.g. <tt>rpm</tt> or installed <tt>Debian</tt> packages)

<a name="index-parameters_002c-completion-tag"></a></dd>

<dt><tt>parameters</tt></dt>

<dd>

for names of parameters

<a name="index-path_002ddirectories_002c-completion-tag"></a></dd>

<dt><tt>path-directories</tt></dt>

<dd>

for names of directories found by searching the <tt>cdpath</tt> array when completing arguments of <tt>cd</tt> and related builtin commands (compare <tt>local-directories</tt>)

<a name="index-paths_002c-completion-tag"></a></dd>

<dt><tt>paths</tt></dt>

<dd>

used to look up the values of the <tt>expand</tt>, <tt>ambiguous</tt> and <tt>special-dirs</tt> styles

<a name="index-pods_002c-completion-tag"></a></dd>

<dt><tt>pods</tt></dt>

<dd>

for perl pods (documentation files)

<a name="index-ports_002c-completion-tag"></a></dd>

<dt><tt>ports</tt></dt>

<dd>

for communication ports

<a name="index-prefixes_002c-completion-tag"></a></dd>

<dt><tt>prefixes</tt></dt>

<dd>

for prefixes (like those of a URL)

<a name="index-printers_002c-completion-tag"></a></dd>

<dt><tt>printers</tt></dt>

<dd>

for print queue names

<a name="index-processes_002c-completion-tag"></a></dd>

<dt><tt>processes</tt></dt>

<dd>

for process identifiers

<a name="index-processes_002dnames_002c-completion-tag"></a></dd>

<dt><tt>processes-names</tt></dt>

<dd>

used to look up the <tt>command</tt> style when generating the names of processes for <tt>killall</tt>

<a name="index-sequences_002c-completion-tag"></a></dd>

<dt><tt>sequences</tt></dt>

<dd>

for sequences (e.g. <tt>mh</tt> sequences)

<a name="index-sessions_002c-completion-tag"></a></dd>

<dt><tt>sessions</tt></dt>

<dd>

for sessions in the <tt>zftp</tt> function suite

<a name="index-signals_002c-completion-tag"></a></dd>

<dt><tt>signals</tt></dt>

<dd>

for signal names

<a name="index-strings_002c-completion-tag"></a></dd>

<dt><tt>strings</tt></dt>

<dd>

for strings (e.g. the replacement strings for the <tt>cd</tt> builtin command)

<a name="index-styles_002c-completion-tag"></a></dd>

<dt><tt>styles</tt></dt>

<dd>

for styles used by the zstyle builtin command

<a name="index-suffixes_002c-completion-tag"></a></dd>

<dt><tt>suffixes</tt></dt>

<dd>

for filename extensions

<a name="index-tags_002c-completion-tag"></a></dd>

<dt><tt>tags</tt></dt>

<dd>

for tags (e.g. <tt>rpm</tt> tags)

<a name="index-targets_002c-completion-tag"></a></dd>

<dt><tt>targets</tt></dt>

<dd>

for makefile targets

<a name="index-time_002dzones_002c-completion-tag"></a></dd>

<dt><tt>time-zones</tt></dt>

<dd>

for time zones (e.g. when setting the <tt>TZ</tt> parameter)

<a name="index-types_002c-completion-tag"></a></dd>

<dt><tt>types</tt></dt>

<dd>

for types of whatever (e.g. address types for the <tt>xhost</tt> command)

<a name="index-urls_002c-completion-tag"></a></dd>

<dt><tt>urls</tt></dt>

<dd>

used to look up the <tt>urls</tt> and <tt>local</tt> styles when completing URLs

<a name="index-users_002c-completion-tag"></a></dd>

<dt><tt>users</tt></dt>

<dd>

for usernames

<a name="index-values_002c-completion-tag"></a></dd>

<dt><tt>values</tt></dt>

<dd>

for one of a set of values in certain lists

<a name="index-variant_002c-completion-tag"></a></dd>

<dt><tt>variant</tt></dt>

<dd>

used by <tt>_pick_variant</tt> to look up the command to run when determining what program is installed for a particular command name.

<a name="index-visuals_002c-completion-tag"></a></dd>

<dt><tt>visuals</tt></dt>

<dd>

for X visuals

<a name="index-warnings_002c-completion-tag"></a></dd>

<dt><tt>warnings</tt></dt>

<dd>

used to look up the <tt>format</tt> style for warnings

<a name="index-widgets_002c-completion-tag"></a></dd>

<dt><tt>widgets</tt></dt>

<dd>

for zsh widget names

<a name="index-windows_002c-completion-tag"></a></dd>

<dt><tt>windows</tt></dt>

<dd>

for IDs of X windows

<a name="index-zsh_002doptions_002c-completion-tag"></a></dd>

<dt><tt>zsh-options</tt></dt>

<dd>

for shell options

</dd>

</dl>

---

<a name="Standard-Styles"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Standard-Tags) ] | [ [Up](#Completion-System-Configuration) ] | [ [\>](#Control-Functions) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

### 20.3.3 Standard Styles

<a name="index-completion-system_002c-styles"></a>

Note that the values of several of these styles represent boolean values. Any of the strings ‘<tt>true</tt>’, ‘<tt>on</tt>’, ‘<tt>yes</tt>’, and ‘<tt>1</tt>’ can be used for the value ‘true’ and any of the strings ‘<tt>false</tt>’, ‘<tt>off</tt>’, ‘<tt>no</tt>’, and ‘<tt>0</tt>’ for the value ‘false’. The behavior for any other value is undefined except where explicitly mentioned. The default value may be either ‘true’ or ‘false’ if the style is not set.

Some of these styles are tested first for every possible tag corresponding to a type of match, and if no style was found, for the <tt>default</tt> tag. The most notable styles of this type are <tt>menu</tt>, <tt>list-colors</tt> and styles controlling completion listing such as <tt>list-packed</tt> and <tt>last-prompt</tt>. When tested for the <tt>default</tt> tag, only the <var>function</var> field of the context will be set so that a style using the default tag will normally be defined along the lines of:

<div class="example">

<pre class="example">zstyle ':completion:*:default' menu ...
</pre>

</div>

<dl compact="compact">

<dd><a name="index-accept_002dexact_002c-completion-style"></a></dd>

<dt><tt>accept-exact</tt></dt>

<dd>

This is tested for the default tag in addition to the tags valid for the current context. If it is set to ‘true’ and any of the trial matches is the same as the string on the command line, this match will immediately be accepted (even if it would otherwise be considered ambiguous).

When completing pathnames (where the tag used is ‘<tt>paths</tt>’) this style accepts any number of patterns as the value in addition to the boolean values. Pathnames matching one of these patterns will be accepted immediately even if the command line contains some more partially typed pathname components and these match no file under the directory accepted.

This style is also used by the <tt>_expand</tt> completer to decide if words beginning with a tilde or parameter expansion should be expanded. For example, if there are parameters <tt>foo</tt> and <tt>foobar</tt>, the string ‘<tt>$foo</tt>’ will only be expanded if <tt>accept-exact</tt> is set to ‘true’; otherwise the completion system will be allowed to complete <tt>$foo</tt> to <tt>$foobar</tt>. If the style is set to ‘<tt>continue</tt>’, <tt>_expand</tt> will add the expansion as a match and the completion system will also be allowed to continue.

<a name="index-accept_002dexact_002ddirs_002c-completion-style"></a></dd>

<dt><tt>accept-exact-dirs</tt></dt>

<dd>

This is used by filename completion. Unlike <tt>accept-exact</tt> it is a boolean. By default, filename completion examines all components of a path to see if there are completions of that component, even if the component matches an existing directory. For example, when completion after <tt>/usr/bin/</tt>, the function examines possible completions to <tt>/usr</tt>.

When this style is ‘true’, any prefix of a path that matches an existing directory is accepted without any attempt to complete it further. Hence, in the given example, the path <tt>/usr/bin/</tt> is accepted immediately and completion tried in that directory.

If you wish to inhibit this behaviour entirely, set the <tt>path-completion</tt> style (see below) to ‘false’.

<a name="index-add_002dspace_002c-completion-style"></a></dd>

<dt><tt>add-space</tt></dt>

<dd>

This style is used by the <tt>_expand</tt> completer. If it is ‘true’ (the default), a space will be inserted after all words resulting from the expansion, or a slash in the case of directory names. If the value is ‘<tt>file</tt>’, the completer will only add a space to names of existing files. Either a boolean ‘true’ or the value ‘<tt>file</tt>’ may be combined with ‘<tt>subst</tt>’, in which case the completer will not add a space to words generated from the expansion of a substitution of the form ‘<tt>$(</tt><var>...</var><tt>)</tt>’ or ‘<tt>${</tt><var>...</var><tt>}</tt>’.

The <tt>_prefix</tt> completer uses this style as a simple boolean value to decide if a space should be inserted before the suffix.

<a name="index-ambiguous_002c-completion-style"></a></dd>

<dt><tt>ambiguous</tt></dt>

<dd>

This applies when completing non-final components of filename paths, in other words those with a trailing slash. If it is set, the cursor is left after the first ambiguous component, even if menu completion is in use. The style is always tested with the <tt>paths</tt> tag.

<a name="index-assign_002dlist_002c-completion-style"></a></dd>

<dt><tt>assign-list</tt></dt>

<dd>

When completing after an equals sign that is being treated as an assignment, the completion system normally completes only one filename. In some cases the value may be a list of filenames separated by colons, as with <tt>PATH</tt> and similar parameters. This style can be set to a list of patterns matching the names of such parameters.

The default is to complete lists when the word on the line already contains a colon.

<a name="index-auto_002ddescription_002c-completion-style"></a></dd>

<dt><tt>auto-description</tt></dt>

<dd>

If set, this style’s value will be used as the description for options that are not described by the completion functions, but that have exactly one argument. The sequence ‘<tt>%d</tt>’ in the value will be replaced by the description for this argument. Depending on personal preferences, it may be useful to set this style to something like ‘<tt>specify: %d</tt>’. Note that this may not work for some commands.

<a name="index-avoid_002dcompleter_002c-completion-style"></a></dd>

<dt><tt>avoid-completer</tt></dt>

<dd>

This is used by the <tt>_all_matches</tt> completer to decide if the string consisting of all matches should be added to the list currently being generated. Its value is a list of names of completers. If any of these is the name of the completer that generated the matches in this completion, the string will not be added.

The default value for this style is ‘<tt>_expand _old_list _correct _approximate</tt>’, i.e. it contains the completers for which a string with all matches will almost never be wanted.

<a name="index-cache_002dpath_002c-completion-style"></a></dd>

<dt><tt>cache-path</tt></dt>

<dd>

This style defines the path where any cache files containing dumped completion data are stored. It defaults to ‘<tt>$ZDOTDIR/.zcompcache</tt>’, or ‘<tt>$HOME/.zcompcache</tt>’ if <tt>$ZDOTDIR</tt> is not defined. The completion cache will not be used unless the <tt>use-cache</tt> style is set.

<a name="index-cache_002dpolicy_002c-completion-style"></a></dd>

<dt><tt>cache-policy</tt></dt>

<dd>

This style defines the function that will be used to determine whether a cache needs rebuilding. See the section on the <tt>_cache_invalid</tt> function below.

<a name="index-call_002dcommand_002c-completion-style"></a></dd>

<dt><tt>call-command</tt></dt>

<dd>

This style is used in the function for commands such as <tt>make</tt> and <tt>ant</tt> where calling the command directly to generate matches suffers problems such as being slow or, as in the case of <tt>make</tt> can potentially cause actions in the makefile to be executed. If it is set to ‘true’ the command is called to generate matches. The default value of this style is ‘false’.

<a name="index-command_002c-completion-style"></a></dd>

<dt><tt>command</tt></dt>

<dd>

In many places, completion functions need to call external commands to generate the list of completions. This style can be used to override the command that is called in some such cases. The elements of the value are joined with spaces to form a command line to execute. The value can also start with a hyphen, in which case the usual command will be added to the end; this is most useful for putting ‘<tt>builtin</tt>’ or ‘<tt>command</tt>’ in front to make sure the appropriate version of a command is called, for example to avoid calling a shell function with the same name as an external command.

As an example, the completion function for process IDs uses this style with the <tt>processes</tt> tag to generate the IDs to complete and the list of processes to display (if the <tt>verbose</tt> style is ‘true’). The list produced by the command should look like the output of the <tt>ps</tt> command. The first line is not displayed, but is searched for the string ‘<tt>PID</tt>’ (or ‘<tt>pid</tt>’) to find the position of the process IDs in the following lines. If the line does not contain ‘<tt>PID</tt>’, the first numbers in each of the other lines are taken as the process IDs to complete.

Note that the completion function generally has to call the specified command for each attempt to generate the completion list. Hence care should be taken to specify only commands that take a short time to run, and in particular to avoid any that may never terminate.

<a name="index-command_002dpath_002c-completion-style"></a></dd>

<dt><tt>command-path</tt></dt>

<dd>

This is a list of directories to search for commands to complete. The default for this style is the value of the special parameter <tt>path</tt>.

<a name="index-commands_002c-completion-style"></a></dd>

<dt><tt>commands</tt></dt>

<dd>

This is used by the function completing sub-commands for the system initialisation scripts (residing in <tt>/etc/init.d</tt> or somewhere not too far away from that). Its values give the default commands to complete for those commands for which the completion function isn’t able to find them out automatically. The default for this style are the two strings ‘<tt>start</tt>’ and ‘<tt>stop</tt>’.

<a name="index-complete_002c-completion-style"></a></dd>

<dt><tt>complete</tt></dt>

<dd>

This is used by the <tt>_expand_alias</tt> function when invoked as a bindable command. If set to ‘true’ and the word on the command line is not the name of an alias, matching alias names will be completed.

<a name="index-complete_002doptions_002c-completion-style"></a></dd>

<dt><tt>complete-options</tt></dt>

<dd>

This is used by the completer for <tt>cd</tt>, <tt>chdir</tt> and <tt>pushd</tt>. For these commands a <tt>-</tt> is used to introduce a directory stack entry and completion of these is far more common than completing options. Hence unless the value of this style is ‘true’ options will not be completed, even after an initial <tt>-</tt>. If it is ‘true’, options will be completed after an initial <tt>-</tt> unless there is a preceding <tt>-</tt><tt>-</tt> on the command line.

<a name="index-completer_002c-completion-style"></a></dd>

<dt><tt>completer</tt></dt>

<dd>

The strings given as the value of this style provide the names of the completer functions to use. The available completer functions are described in [Control Functions](#Control-Functions).

Each string may be either the name of a completer function or a string of the form ‘<var>function</var><tt>:</tt><var>name</var>’. In the first case the <var>completer</var> field of the context will contain the name of the completer without the leading underscore and with all other underscores replaced by hyphens. In the second case the <var>function</var> is the name of the completer to call, but the context will contain the user-defined <var>name</var> in the <var>completer</var> field of the context. If the <var>name</var> starts with a hyphen, the string for the context will be build from the name of the completer function as in the first case with the <var>name</var> appended to it. For example:

<div class="example">

<pre class="example">zstyle ':completion:*' completer _complete _complete:-foo
</pre>

</div>

Here, completion will call the <tt>_complete</tt> completer twice, once using ‘<tt>complete</tt>’ and once using ‘<tt>complete-foo</tt>’ in the <var>completer</var> field of the context. Normally, using the same completer more than once only makes sense when used with the ‘<var>functions</var><tt>:</tt><var>name</var>’ form, because otherwise the context name will be the same in all calls to the completer; possible exceptions to this rule are the <tt>_ignored</tt> and <tt>_prefix</tt> completers.

The default value for this style is ‘<tt>_complete _ignored</tt>’: only completion will be done, first using the <tt>ignored-patterns</tt> style and the <tt>$fignore</tt> array and then without ignoring matches.

<a name="index-condition_002c-completion-style"></a></dd>

<dt><tt>condition</tt></dt>

<dd>

This style is used by the <tt>_list</tt> completer function to decide if insertion of matches should be delayed unconditionally. The default is ‘true’.

<a name="index-delimiters_002c-completion-style"></a></dd>

<dt><tt>delimiters</tt></dt>

<dd>

This style is used when adding a delimiter for use with history modifiers or glob qualifiers that have delimited arguments. It is an array of preferred delimiters to add. Non-special characters are preferred as the completion system may otherwise become confused. The default list is <tt>:</tt>, <tt>+</tt>, <tt>/</tt>, <tt>-</tt>, <tt>%</tt>. The list may be empty to force a delimiter to be typed.

<a name="index-disabled_002c-completion-style"></a></dd>

<dt><tt>disabled</tt></dt>

<dd>

If this is set to ‘true’, the <tt>_expand_alias</tt> completer and bindable command will try to expand disabled aliases, too. The default is ‘false’.

<a name="index-domains_002c-completion-style"></a></dd>

<dt><tt>domains</tt></dt>

<dd>

A list of names of network domains for completion. If this is not set, domain names will be taken from the file <tt>/etc/resolv.conf</tt>.

<a name="index-environ_002c-completion-style"></a></dd>

<dt><tt>environ</tt></dt>

<dd>

The environ style is used when completing for ‘<tt>sudo</tt>’. It is set to an array of ‘<var>VAR</var><tt>=</tt><var>value</var>’ assignments to be exported into the local environment before the completion for the target command is invoked.

<div class="example">

<pre class="example">zstyle ':completion:*:sudo::' environ \ 
  PATH="/sbin:/usr/sbin:$PATH" HOME="/root"
</pre>

</div>

<a name="index-expand_002c-completion-style"></a></dd>

<dt><tt>expand</tt></dt>

<dd>

This style is used when completing strings consisting of multiple parts, such as path names.

If one of its values is the string ‘<tt>prefix</tt>’, the partially typed word from the line will be expanded as far as possible even if trailing parts cannot be completed.

If one of its values is the string ‘<tt>suffix</tt>’, matching names for components after the first ambiguous one will also be added. This means that the resulting string is the longest unambiguous string possible. However, menu completion can be used to cycle through all matches.

<a name="index-fake_002c-completion-style"></a></dd>

<dt><tt>fake</tt></dt>

<dd>

This style may be set for any completion context. It specifies additional strings that will always be completed in that context. The form of each string is ‘<var>value</var><tt>:</tt><var>description</var>’; the colon and description may be omitted, but any literal colons in <var>value</var> must be quoted with a backslash. Any <var>description</var> provided is shown alongside the value in completion listings.

It is important to use a sufficiently restrictive context when specifying fake strings. Note that the styles <tt>fake-files</tt> and <tt>fake-parameters</tt> provide additional features when completing files or parameters.

<a name="index-fake_002dalways_002c-completion-style"></a></dd>

<dt><tt>fake-always</tt></dt>

<dd>

This works identically to the <tt>fake</tt> style except that the <tt>ignored-patterns</tt> style is not applied to it. This makes it possible to override a set of matches completely by setting the ignored patterns to ‘<tt>*</tt>’.

The following shows a way of supplementing any tag with arbitrary data, but having it behave for display purposes like a separate tag. In this example we use the features of the <tt>tag-order</tt> style to divide the <tt>named-directories</tt> tag into two when performing completion with the standard completer <tt>complete</tt> for arguments of <tt>cd</tt>. The tag <tt>named-directories-normal</tt> behaves as normal, but the tag <tt>named-directories-mine</tt> contains a fixed set of directories. This has the effect of adding the match group ‘<tt>extra directories</tt>’ with the given completions.

<div class="example">

<pre class="example">zstyle ':completion::complete:cd:*' tag-order \ 
  'named-directories:-mine:extra\ directories
  named-directories:-normal:named\ directories *'
zstyle ':completion::complete:cd:*:named-directories-mine' \ 
  fake-always mydir1 mydir2
zstyle ':completion::complete:cd:*:named-directories-mine' \ 
  ignored-patterns '*'
</pre>

</div>

<a name="index-fake_002dfiles_002c-completion-style"></a></dd>

<dt><tt>fake-files</tt></dt>

<dd>

This style is used when completing files and looked up without a tag. Its values are of the form ‘<var>dir</var><tt>:</tt><var>names...</var>’. This will add the <var>names</var> (strings separated by spaces) as possible matches when completing in the directory <var>dir</var>, even if no such files really exist. The dir may be a pattern; pattern characters or colons in <var>dir</var> should be quoted with a backslash to be treated literally.

This can be useful on systems that support special file systems whose top-level pathnames can not be listed or generated with glob patterns. It can also be used for directories for which one does not have read permission.

The pattern form can be used to add a certain ‘magic’ entry to all directories on a particular file system.

<a name="index-fake_002dparameters_002c-completion-style"></a></dd>

<dt><tt>fake-parameters</tt></dt>

<dd>

This is used by the completion function for parameter names. Its values are names of parameters that might not yet be set but should be completed nonetheless. Each name may also be followed by a colon and a string specifying the type of the parameter (like ‘<tt>scalar</tt>’, ‘<tt>array</tt>’ or ‘<tt>integer</tt>’). If the type is given, the name will only be completed if parameters of that type are required in the particular context. Names for which no type is specified will always be completed.

<a name="index-file_002dlist_002c-completion-style"></a></dd>

<dt><tt>file-list</tt></dt>

<dd>

This style controls whether files completed using the standard builtin mechanism are to be listed with a long list similar to <tt>ls -l</tt>. Note that this feature uses the shell module <tt>zsh/stat</tt> for file information; this loads the builtin <tt>stat</tt> which will replace any external <tt>stat</tt> executable. To avoid this the following code can be included in an initialization file:

<div class="example">

<pre class="example">zmodload -i zsh/stat
disable stat
</pre>

</div>

The style may either be set to a ‘true’ value (or ‘<tt>all</tt>’), or one of the values ‘<tt>insert</tt>’ or ‘<tt>list</tt>’, indicating that files are to be listed in long format in all circumstances, or when attempting to insert a file name, or when listing file names without attempting to insert one.

More generally, the value may be an array of any of the above values, optionally followed by <tt>=</tt><var>num</var>. If <var>num</var> is present it gives the maximum number of matches for which long listing style will be used. For example,

<div class="example">

<pre class="example">zstyle ':completion:*' file-list list=20 insert=10
</pre>

</div>

specifies that long format will be used when listing up to 20 files or inserting a file with up to 10 matches (assuming a listing is to be shown at all, for example on an ambiguous completion), else short format will be used.

<div class="example">

<pre class="example">zstyle -e ':completion:*' file-list \ 
       '(( ${+NUMERIC} )) && reply=(true)'
</pre>

</div>

specifies that long format will be used any time a numeric argument is supplied, else short format.

<a name="index-file_002dpatterns_002c-completion-style"></a></dd>

<dt><tt>file-patterns</tt></dt>

<dd>

This is used by the standard function for completing filenames, <tt>_files</tt>. If the style is unset up to three tags are offered, ‘<tt>globbed-files</tt>’,‘<tt>directories</tt>’ and ‘<tt>all-files</tt>’, depending on the types of files expected by the caller of <tt>_files</tt>. The first two (‘<tt>globbed-files</tt>’ and ‘<tt>directories</tt>’) are normally offered together to make it easier to complete files in sub-directories.

The <tt>file-patterns</tt> style provides alternatives to the default tags, which are not used. Its value consists of elements of the form ‘<var>pattern</var><tt>:</tt><var>tag</var>’; each string may contain any number of such specifications separated by spaces.

The <var>pattern</var> is a pattern that is to be used to generate filenames. Any occurrence of the sequence ‘<tt>%p</tt>’ is replaced by any pattern(s) passed by the function calling <tt>_files</tt>. Colons in the pattern must be preceded by a backslash to make them distinguishable from the colon before the <var>tag</var>. If more than one pattern is needed, the patterns can be given inside braces, separated by commas.

The <var>tag</var>s of all strings in the value will be offered by <tt>_files</tt> and used when looking up other styles. Any <var>tag</var>s in the same word will be offered at the same time and before later words. If no ‘<tt>:</tt><var>tag</var>’ is given the ‘<tt>files</tt>’ tag will be used.

The <var>tag</var> may also be followed by an optional second colon and a description, which will be used for the ‘<tt>%d</tt>’ in the value of the <tt>format</tt> style (if that is set) instead of the default description supplied by the completion function. If the description given here contains itself a ‘<tt>%d</tt>’, that is replaced with the description supplied by the completion function.

For example, to make the <tt>rm</tt> command first complete only names of object files and then the names of all files if there is no matching object file:

<div class="example">

<pre class="example">zstyle ':completion:*:*:rm:*:*' file-patterns \ 
    '*.o:object-files' '%p:all-files'
</pre>

</div>

To alter the default behaviour of file completion — offer files matching a pattern and directories on the first attempt, then all files — to offer only matching files on the first attempt, then directories, and finally all files:

<div class="example">

<pre class="example">zstyle ':completion:*' file-patterns \ 
    '%p:globbed-files' '*(-/):directories' '*:all-files'
</pre>

</div>

This works even where there is no special pattern: <tt>_files</tt> matches all files using the pattern ‘<tt>*</tt>’ at the first step and stops when it sees this pattern. Note also it will never try a pattern more than once for a single completion attempt.

During the execution of completion functions, the <tt>EXTENDED_GLOB</tt> option is in effect, so the characters ‘<tt>#</tt>’, ‘<tt>~</tt>’ and ‘<tt>^</tt>’ have special meanings in the patterns.

<a name="index-file_002dsort_002c-completion-style"></a></dd>

<dt><tt>file-sort</tt></dt>

<dd>

The standard filename completion function uses this style without a tag to determine in which order the names should be listed; menu completion will cycle through them in the same order. The possible values are: ‘<tt>size</tt>’ to sort by the size of the file; ‘<tt>links</tt>’ to sort by the number of links to the file; ‘<tt>modification</tt>’ (or ‘<tt>time</tt>’ or ‘<tt>date</tt>’) to sort by the last modification time; ‘<tt>access</tt>’ to sort by the last access time; and ‘<tt>inode</tt>’ (or ‘<tt>change</tt>’) to sort by the last inode change time. If the style is set to any other value, or is unset, files will be sorted alphabetically by name. If the value contains the string ‘<tt>reverse</tt>’, sorting is done in the opposite order. If the value contains the string ‘<tt>follow</tt>’, timestamps are associated with the targets of symbolic links; the default is to use the timestamps of the links themselves.

<a name="index-filter_002c-completion-style"></a></dd>

<dt><tt>filter</tt></dt>

<dd>

The <tt>ldap</tt> plugin of email address completion (see <tt>_email_addresses</tt>) uses this style to specify the attributes to match against when filtering entries. So for example, if the style is set to ‘<tt>sn</tt>’, matching is done against surnames. Standard LDAP filtering is used so normal completion matching is bypassed. If this style is not set, the LDAP plugin is skipped. You may also need to set the <tt>command</tt> style to specify how to connect to your LDAP server.

<a name="index-force_002dlist_002c-completion-style"></a></dd>

<dt><tt>force-list</tt></dt>

<dd>

This forces a list of completions to be shown at any point where listing is done, even in cases where the list would usually be suppressed. For example, normally the list is only shown if there are at least two different matches. By setting this style to ‘<tt>always</tt>’, the list will always be shown, even if there is only a single match that will immediately be accepted. The style may also be set to a number. In this case the list will be shown if there are at least that many matches, even if they would all insert the same string.

This style is tested for the default tag as well as for each tag valid for the current completion. Hence the listing can be forced only for certain types of match.

<a name="index-format_002c-completion-style"></a></dd>

<dt><tt>format</tt></dt>

<dd>

If this is set for the <tt>descriptions</tt> tag, its value is used as a string to display above matches in completion lists. The sequence ‘<tt>%d</tt>’ in this string will be replaced with a short description of what these matches are. This string may also contain the following sequences to specify output attributes (see [Prompt Expansion](Prompt-Expansion.html#Prompt-Expansion)): ‘<tt>%B</tt>’, ‘<tt>%S</tt>’, ‘<tt>%U</tt>’, ‘<tt>%F</tt>’, ‘<tt>%K</tt>’ and their lower case counterparts, as well as ‘<tt>%{</tt>...<tt>%}</tt>’. ‘<tt>%F</tt>’, ‘<tt>%K</tt>’ and ‘<tt>%{</tt>...<tt>%}</tt>’ take arguments in the same form as prompt expansion. Note that the sequence ‘<tt>%G</tt>’ is not available; an argument to ‘<tt>%{</tt>’ should be used instead.

The style is tested with each tag valid for the current completion before it is tested for the <tt>descriptions</tt> tag. Hence different format strings can be defined for different types of match.

Note also that some completer functions define additional ‘<tt>%</tt>’-sequences. These are described for the completer functions that make use of them.

Some completion functions display messages that may be customised by setting this style for the <tt>messages</tt> tag. Here, the ‘<tt>%d</tt>’ is replaced with a message given by the completion function.

Finally, the format string is looked up with the <tt>warnings</tt> tag, for use when no matches could be generated at all. In this case the ‘<tt>%d</tt>’ is replaced with the descriptions for the matches that were expected separated by spaces. The sequence ‘<tt>%D</tt>’ is replaced with the same descriptions separated by newlines.

It is possible to use printf-style field width specifiers with ‘<tt>%d</tt>’ and similar escape sequences. This is handled by the <tt>zformat</tt> builtin command from the <tt>zsh/zutil</tt> module, see [The zsh/zutil Module](Zsh-Modules.html#The-zsh_002fzutil-Module).

<a name="index-glob_002c-completion-style"></a></dd>

<dt><tt>glob</tt></dt>

<dd>

This is used by the <tt>_expand</tt> completer. If it is set to ‘true’ (the default), globbing will be attempted on the words resulting from a previous substitution (see the <tt>substitute</tt> style) or else the original string from the line.

<a name="index-global_002c-completion-style"></a></dd>

<dt><tt>global</tt></dt>

<dd>

If this is set to ‘true’ (the default), the <tt>_expand_alias</tt> completer and bindable command will try to expand global aliases.

<a name="index-group_002dname_002c-completion-style"></a></dd>

<dt><tt>group-name</tt></dt>

<dd>

The completion system can group different types of matches, which appear in separate lists. This style can be used to give the names of groups for particular tags. For example, in command position the completion system generates names of builtin and external commands, names of aliases, shell functions and parameters and reserved words as possible completions. To have the external commands and shell functions listed separately:

<div class="example">

<pre class="example">zstyle ':completion:*:*:-command-:*:commands' \ 
       group-name commands
zstyle ':completion:*:*:-command-:*:functions' \ 
       group-name functions
</pre>

</div>

As a consequence, any match with the same tag will be displayed in the same group.

If the name given is the empty string the name of the tag for the matches will be used as the name of the group. So, to have all different types of matches displayed separately, one can just set:

<div class="example">

<pre class="example">zstyle ':completion:*' group-name ''
</pre>

</div>

All matches for which no group name is defined will be put in a group named <tt>-default-</tt>.

<a name="index-group_002dorder_002c-completion-style"></a></dd>

<dt><tt>group-order</tt></dt>

<dd>

This style is additional to the <tt>group-name</tt> style to specify the order for display of the groups defined by that style (compare <tt>tag-order</tt>, which determines which completions appear at all). The groups named are shown in the given order; any other groups are shown in the order defined by the completion function.

For example, to have names of builtin commands, shell functions and external commands appear in that order when completing in command position:

<div class="example">

<pre class="example">zstyle ':completion:*:*:-command-:*:*' group-order \ 
       builtins functions commands
</pre>

</div>

<a name="index-groups_002c-completion-style"></a></dd>

<dt><tt>groups</tt></dt>

<dd>

A list of names of UNIX groups. If this is not set, group names are taken from the YP database or the file ‘<tt>/etc/group</tt>’.

<a name="index-hidden_002c-completion-style"></a></dd>

<dt><tt>hidden</tt></dt>

<dd>

If this is set to ‘true’, matches for the given context will not be listed, although any description for the matches set with the <tt>format</tt> style will be shown. If it is set to ‘<tt>all</tt>’, not even the description will be displayed.

Note that the matches will still be completed; they are just not shown in the list. To avoid having matches considered as possible completions at all, the <tt>tag-order</tt> style can be modified as described below.

<a name="index-hosts_002c-completion-style"></a></dd>

<dt><tt>hosts</tt></dt>

<dd>

A list of names of hosts that should be completed. If this is not set, hostnames are taken from the file ‘<tt>/etc/hosts</tt>’.

<a name="index-hosts_002dports_002c-completion-style"></a></dd>

<dt><tt>hosts-ports</tt></dt>

<dd>

This style is used by commands that need or accept hostnames and network ports. The strings in the value should be of the form ‘<var>host</var><tt>:</tt><var>port</var>’. Valid ports are determined by the presence of hostnames; multiple ports for the same host may appear.

<a name="index-ignore_002dline_002c-completion-style"></a></dd>

<dt><tt>ignore-line</tt></dt>

<dd>

This is tested for each tag valid for the current completion. If it is set to ‘true’, none of the words that are already on the line will be considered as possible completions. If it is set to ‘<tt>current</tt>’, the word the cursor is on will not be considered as a possible completion. The value ‘<tt>current-shown</tt>’ is similar but only applies if the list of completions is currently shown on the screen. Finally, if the style is set to ‘<tt>other</tt>’, all words on the line except for the current one will be excluded from the possible completions.

The values ‘<tt>current</tt>’ and ‘<tt>current-shown</tt>’ are a bit like the opposite of the <tt>accept-exact</tt> style: only strings with missing characters will be completed.

Note that you almost certainly don’t want to set this to ‘true’ or ‘<tt>other</tt>’ for a general context such as ‘<tt>:completion:*</tt>’. This is because it would disallow completion of, for example, options multiple times even if the command in question accepts the option more than once.

<a name="index-ignore_002dparents_002c-completion-style"></a></dd>

<dt><tt>ignore-parents</tt></dt>

<dd>

The style is tested without a tag by the function completing pathnames in order to determine whether to ignore the names of directories already mentioned in the current word, or the name of the current working directory. The value must include one or both of the following strings:

<dl compact="compact">

<dt><tt>parent</tt></dt>

<dd>

The name of any directory whose path is already contained in the word on the line is ignored. For example, when completing after <tt>foo/../</tt>, the directory <tt>foo</tt> will not be considered a valid completion.

</dd>

<dt><tt>pwd</tt></dt>

<dd>

The name of the current working directory will not be completed; hence, for example, completion after <tt>../</tt> will not use the name of the current directory.

</dd>

</dl>

In addition, the value may include one or both of:

<dl compact="compact">

<dt><tt>..</tt></dt>

<dd>

Ignore the specified directories only when the word on the line contains the substring ‘<tt>../</tt>’.

</dd>

<dt><tt>directory</tt></dt>

<dd>

Ignore the specified directories only when names of directories are completed, not when completing names of files.

</dd>

</dl>

Excluded values act in a similar fashion to values of the <tt>ignored-patterns</tt> style, so they can be restored to consideration by the <tt>_ignored</tt> completer.

<a name="index-extra_002dverbose_002c-completion-style"></a></dd>

<dt><tt>extra-verbose</tt></dt>

<dd>

If set, the completion listing is more verbose at the cost of a probable decrease in completion speed. Completion performance will suffer if this style is set to ‘true’.

<a name="index-ignored_002dpatterns_002c-completion-style"></a></dd>

<dt><tt>ignored-patterns</tt></dt>

<dd>

A list of patterns; any trial completion matching one of the patterns will be excluded from consideration. The <tt>_ignored</tt> completer can appear in the list of completers to restore the ignored matches. This is a more configurable version of the shell parameter <tt>$fignore</tt>.

Note that the <tt>EXTENDED_GLOB</tt> option is set during the execution of completion functions, so the characters ‘<tt>\#</tt>’, ‘<tt>~</tt>’ and ‘<tt>^</tt>’ have special meanings in the patterns.

<a name="index-insert_002c-completion-style"></a></dd>

<dt><tt>insert</tt></dt>

<dd>

This style is used by the <tt>_all_matches</tt> completer to decide whether to insert the list of all matches unconditionally instead of adding the list as another match.

<a name="index-insert_002dids_002c-completion-style"></a></dd>

<dt><tt>insert-ids</tt></dt>

<dd>

When completing process IDs, for example as arguments to the <tt>kill</tt> and <tt>wait</tt> builtins the name of a command may be converted to the appropriate process ID. A problem arises when the process name typed is not unique. By default (or if this style is set explicitly to ‘<tt>menu</tt>’) the name will be converted immediately to a set of possible IDs, and menu completion will be started to cycle through them.

If the value of the style is ‘<tt>single</tt>’, the shell will wait until the user has typed enough to make the command unique before converting the name to an ID; attempts at completion will be unsuccessful until that point. If the value is any other string, menu completion will be started when the string typed by the user is longer than the common prefix to the corresponding IDs.

<a name="index-insert_002dtab_002c-completion-style"></a></dd>

<dt><tt>insert-tab</tt></dt>

<dd>

If this is set to ‘true’, the completion system will insert a TAB character (assuming that was used to start completion) instead of performing completion when there is no non-blank character to the left of the cursor. If it is set to ‘false’, completion will be done even there.

The value may also contain the substrings ‘<tt>pending</tt>’ or ‘<tt>pending=</tt><var>val</var>’. In this case, the typed character will be inserted instead of starting completion when there is unprocessed input pending. If a <var>val</var> is given, completion will not be done if there are at least that many characters of unprocessed input. This is often useful when pasting characters into a terminal. Note however, that it relies on the <tt>$PENDING</tt> special parameter from the <tt>zsh/zle</tt> module being set properly which is not guaranteed on all platforms.

The default value of this style is ‘true’ except for completion within <tt>vared</tt> builtin command where it is ‘false’.

<a name="index-insert_002dunambiguous_002c-completion-style"></a></dd>

<dt><tt>insert-unambiguous</tt></dt>

<dd>

This is used by the <tt>_match</tt> and <tt>_approximate</tt> completers. These completers are often used with menu completion since the word typed may bear little resemblance to the final completion. However, if this style is ‘true’, the completer will start menu completion only if it could find no unambiguous initial string at least as long as the original string typed by the user.

In the case of the <tt>_approximate</tt> completer, the completer field in the context will already have been set to one of <tt>correct-</tt><var>num</var> or <tt>approximate-</tt><var>num</var>, where <var>num</var> is the number of errors that were accepted.

In the case of the <tt>_match</tt> completer, the style may also be set to the string ‘<tt>pattern</tt>’. Then the pattern on the line is left unchanged if it does not match unambiguously.

<a name="index-keep_002dprefix_002c-completion-style"></a></dd>

<dt><tt>keep-prefix</tt></dt>

<dd>

This style is used by the <tt>_expand</tt> completer. If it is ‘true’, the completer will try to keep a prefix containing a tilde or parameter expansion. Hence, for example, the string ‘<tt>~/f\*</tt>’ would be expanded to ‘<tt>~/foo</tt>’ instead of ‘<tt>/home/user/foo</tt>’. If the style is set to ‘<tt>changed</tt>’ (the default), the prefix will only be left unchanged if there were other changes between the expanded words and the original word from the command line. Any other value forces the prefix to be expanded unconditionally.

The behaviour of <tt>_expand</tt> when this style is ‘true’ is to cause <tt>_expand</tt> to give up when a single expansion with the restored prefix is the same as the original; hence any remaining completers may be called.

<a name="index-last_002dprompt_002c-completion-style"></a></dd>

<dt><tt>last-prompt</tt></dt>

<dd>

This is a more flexible form of the <tt>ALWAYS_LAST_PROMPT</tt> option. If it is ‘true’, the completion system will try to return the cursor to the previous command line after displaying a completion list. It is tested for all tags valid for the current completion, then the <tt>default</tt> tag. The cursor will be moved back to the previous line if this style is ‘true’ for all types of match. Note that unlike the <tt>ALWAYS_LAST_PROMPT</tt> option this is independent of the numeric argument.

<a name="index-known_002dhosts_002dfiles"></a></dd>

<dt><tt>known-hosts-files</tt></dt>

<dd>

This style should contain a list of files to search for host names and (if the <tt>use-ip</tt> style is set) IP addresses in a format compatible with ssh <tt>known_hosts</tt> files. If it is not set, the files <tt>/etc/ssh/ssh_known_hosts</tt> and <tt>~/.ssh/known_hosts</tt> are used.

<a name="index-list_002c-completion-style"></a></dd>

<dt><tt>list</tt></dt>

<dd>

This style is used by the <tt>_history_complete_word</tt> bindable command. If it is set to ‘true’ it has no effect. If it is set to ‘false’ matches will not be listed. This overrides the setting of the options controlling listing behaviour, in particular <tt>AUTO_LIST</tt>. The context always starts with ‘<tt>:completion:history-words</tt>’.

<a name="index-list_002dcolors_002c-completion-style"></a></dd>

<dt><tt>list-colors</tt></dt>

<dd>

If the <tt>zsh/complist</tt> module is loaded, this style can be used to set color specifications. This mechanism replaces the use of the <tt>ZLS_COLORS</tt> and <tt>ZLS_COLOURS</tt> parameters described in [The zsh/complist Module](Zsh-Modules.html#The-zsh_002fcomplist-Module), but the syntax is the same.

If this style is set for the <tt>default</tt> tag, the strings in the value are taken as specifications that are to be used everywhere. If it is set for other tags, the specifications are used only for matches of the type described by the tag. For this to work best, the <tt>group-name</tt> style must be set to an empty string.

In addition to setting styles for specific tags, it is also possible to use group names specified explicitly by the <tt>group-name</tt> tag together with the ‘<tt>(group)</tt>’ syntax allowed by the <tt>ZLS_COLORS</tt> and <tt>ZLS_COLOURS</tt> parameters and simply using the <tt>default</tt> tag.

It is possible to use any color specifications already set up for the GNU version of the <tt>ls</tt> command:

<div class="example">

<pre class="example">zstyle ':completion:*:default' list-colors \ 
       ${(s.:.)LS_COLORS}
</pre>

</div>

The default colors are the same as for the GNU <tt>ls</tt> command and can be obtained by setting the style to an empty string (i.e. <tt>’’</tt>).

<a name="index-list_002ddirs_002dfirst_002c-completion-style"></a></dd>

<dt><tt>list-dirs-first</tt></dt>

<dd>

This is used by file completion. If set, directories to be completed are listed separately from and before completion for other files, regardless of tag ordering. In addition, the tag <tt>other-files</tt> is used in place of <tt>all-files</tt> for the remaining files, to indicate that no directories are presented with that tag.

<a name="index-list_002dgrouped_002c-completion-style"></a></dd>

<dt><tt>list-grouped</tt></dt>

<dd>

If this style is ‘true’ (the default), the completion system will try to make certain completion listings more compact by grouping matches. For example, options for commands that have the same description (shown when the <tt>verbose</tt> style is set to ‘true’) will appear as a single entry. However, menu selection can be used to cycle through all the matches.

<a name="index-list_002dpacked_002c-completion-style"></a></dd>

<dt><tt>list-packed</tt></dt>

<dd>

This is tested for each tag valid in the current context as well as the <tt>default</tt> tag. If it is set to ‘true’, the corresponding matches appear in listings as if the <tt>LIST_PACKED</tt> option were set. If it is set to ‘false’, they are listed normally.

<a name="index-list_002dprompt_002c-completion-style"></a></dd>

<dt><tt>list-prompt</tt></dt>

<dd>

If this style is set for the <tt>default</tt> tag, completion lists that don’t fit on the screen can be scrolled (see [The zsh/complist Module](Zsh-Modules.html#The-zsh_002fcomplist-Module)). The value, if not the empty string, will be displayed after every screenful and the shell will prompt for a key press; if the style is set to the empty string, a default prompt will be used.

The value may contain the escape sequences: ‘<tt>%l</tt>’ or ‘<tt>%L</tt>’, which will be replaced by the number of the last line displayed and the total number of lines; ‘<tt>%m</tt>’ or ‘<tt>%M</tt>’, the number of the last match shown and the total number of matches; and ‘<tt>%p</tt>’ and ‘<tt>%P</tt>’, ‘<tt>Top</tt>’ when at the beginning of the list, ‘<tt>Bottom</tt>’ when at the end and the position shown as a percentage of the total length otherwise. In each case the form with the uppercase letter will be replaced by a string of fixed width, padded to the right with spaces, while the lowercase form will be replaced by a variable width string. As in other prompt strings, the escape sequences ‘<tt>%S</tt>’, ‘<tt>%s</tt>’, ‘<tt>%B</tt>’, ‘<tt>%b</tt>’, ‘<tt>%U</tt>’, ‘<tt>%u</tt>’ for entering and leaving the display modes standout, bold and underline, and ‘<tt>%F</tt>’, ‘<tt>%f</tt>’, ‘<tt>%K</tt>’, ‘<tt>%k</tt>’ for changing the foreground background colour, are also available, as is the form ‘<tt>%{</tt>...<tt>%}</tt>’ for enclosing escape sequences which display with zero (or, with a numeric argument, some other) width.

After deleting this prompt the variable <tt>LISTPROMPT</tt> should be unset for the removal to take effect.

<a name="index-list_002drows_002dfirst_002c-completion-style"></a></dd>

<dt><tt>list-rows-first</tt></dt>

<dd>

This style is tested in the same way as the <tt>list-packed</tt> style and determines whether matches are to be listed in a rows-first fashion as if the <tt>LIST_ROWS_FIRST</tt> option were set.

<a name="index-list_002dsuffixes_002c-completion-style"></a></dd>

<dt><tt>list-suffixes</tt></dt>

<dd>

This style is used by the function that completes filenames. If it is ‘true’, and completion is attempted on a string containing multiple partially typed pathname components, all ambiguous components will be shown. Otherwise, completion stops at the first ambiguous component.

<a name="index-list_002dseparator_002c-completion-style"></a></dd>

<dt><tt>list-separator</tt></dt>

<dd>

The value of this style is used in completion listing to separate the string to complete from a description when possible (e.g. when completing options). It defaults to ‘<tt>\-</tt><tt>\-</tt>’ (two hyphens).

<a name="index-local_002c-completion-style"></a></dd>

<dt><tt>local</tt></dt>

<dd>

This is for use with functions that complete URLs for which the corresponding files are available directly from the file system. Its value should consist of three strings: a hostname, the path to the default web pages for the server, and the directory name used by a user placing web pages within their home area.

For example:

<div class="example">

<pre class="example">zstyle ':completion:*' local toast \ 
    /var/http/public/toast public_html
</pre>

</div>

Completion after ‘<tt>http://toast/stuff/</tt>’ will look for files in the directory <tt>/var/http/public/toast/stuff</tt>, while completion after ‘<tt>http://toast/~yousir/</tt>’ will look for files in the directory <tt>~yousir/public_html</tt>.

<a name="index-mail_002ddirectory_002c-completion-style"></a></dd>

<dt><tt>mail-directory</tt></dt>

<dd>

If set, zsh will assume that mailbox files can be found in the directory specified. It defaults to ‘<tt>~/Mail</tt>’.

<a name="index-match_002doriginal_002c-completion-style"></a></dd>

<dt><tt>match-original</tt></dt>

<dd>

This is used by the <tt>_match</tt> completer. If it is set to <tt>only</tt>, <tt>_match</tt> will try to generate matches without inserting a ‘<tt>*</tt>’ at the cursor position. If set to any other non-empty value, it will first try to generate matches without inserting the ‘<tt>*</tt>’ and if that yields no matches, it will try again with the ‘<tt>*</tt>’ inserted. If it is unset or set to the empty string, matching will only be performed with the ‘<tt>*</tt>’ inserted.

<a name="index-matcher_002c-completion-style"></a></dd>

<dt><tt>matcher</tt></dt>

<dd>

This style is tested separately for each tag valid in the current context. Its value is placed before any match specifications given by the <tt>matcher-list</tt> style so can override them via the use of an <tt>x:</tt> specification. The value should be in the form described in [Completion Matching Control](Completion-Widgets.html#Completion-Matching-Control). For examples of this, see the description of the <tt>tag-order</tt> style.

<a name="index-matcher_002dlist_002c-completion-style"></a></dd>

<dt><tt>matcher-list</tt></dt>

<dd>

This style can be set to a list of match specifications that are to be applied everywhere. Match specifications are described in [Completion Matching Control](Completion-Widgets.html#Completion-Matching-Control). The completion system will try them one after another for each completer selected. For example, to try first simple completion and, if that generates no matches, case-insensitive completion:

<div class="example">

<pre class="example">zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
</pre>

</div>

By default each specification replaces the previous one; however, if a specification is prefixed with <tt>\+</tt>, it is added to the existing list. Hence it is possible to create increasingly general specifications without repetition:

<div class="example">

<pre class="example">zstyle ':completion:*' matcher-list \ 
       '' '+m:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
</pre>

</div>

It is possible to create match specifications valid for particular completers by using the third field of the context. This applies only to completers that override the global matcher-list, which as of this writing includes only <tt>_prefix</tt> and <tt>_ignored</tt>. For example, to use the completers <tt>_complete</tt> and <tt>_prefix</tt> but allow case-insensitive completion only with <tt>_complete</tt>:

<div class="example">

<pre class="example">zstyle ':completion:*' completer _complete _prefix
zstyle ':completion:*:complete:*:*:*' matcher-list \ 
       '' 'm:{a-zA-Z}={A-Za-z}'
</pre>

</div>

User-defined names, as explained for the <tt>completer</tt> style, are available. This makes it possible to try the same completer more than once with different match specifications each time. For example, to try normal completion without a match specification, then normal completion with case-insensitive matching, then correction, and finally partial-word completion:

<div class="example">

<pre class="example">zstyle ':completion:*' completer \ 
    _complete _correct _complete:foo
zstyle ':completion:*:complete:*:*:*' matcher-list \ 
    '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:foo:*:*:*' matcher-list \ 
    'm:{a-zA-Z}={A-Za-z} r:|[-_./]=* r:|=*'
</pre>

</div>

If the style is unset in any context no match specification is applied. Note also that some completers such as <tt>_correct</tt> and <tt>_approximate</tt> do not use the match specifications at all, though these completers will only ever be called once even if the <tt>matcher-list</tt> contains more than one element.

Where multiple specifications are useful, note that the *entire* completion is done for each element of <tt>matcher-list</tt>, which can quickly reduce the shell’s performance. As a rough rule of thumb, one to three strings will give acceptable performance. On the other hand, putting multiple space-separated values into the same string does not have an appreciable impact on performance.

If there is no current matcher or it is empty, and the option <tt>NO_CASE_GLOB</tt> is in effect, the matching for files is performed case-insensitively in any case. However, any matcher must explicitly specify case-insensitive matching if that is required.

<a name="index-max_002derrors_002c-completion-style"></a></dd>

<dt><tt>max-errors</tt></dt>

<dd>

This is used by the <tt>_approximate</tt> and <tt>_correct</tt> completer functions to determine the maximum number of errors to allow. The completer will try to generate completions by first allowing one error, then two errors, and so on, until either a match or matches were found or the maximum number of errors given by this style has been reached.

If the value for this style contains the string ‘<tt>numeric</tt>’, the completer function will take any numeric argument as the maximum number of errors allowed. For example, with

<div class="example">

<pre class="example">zstyle ':completion:*:approximate:::' max-errors 2 numeric
</pre>

</div>

two errors are allowed if no numeric argument is given, but with a numeric argument of six (as in ‘<tt>ESC-6 TAB</tt>’), up to six errors are accepted. Hence with a value of ‘<tt>0 numeric</tt>’, no correcting completion will be attempted unless a numeric argument is given.

If the value contains the string ‘<tt>not-numeric</tt>’, the completer will *not* try to generate corrected completions when given a numeric argument, so in this case the number given should be greater than zero. For example, ‘<tt>2 not-numeric</tt>’ specifies that correcting completion with two errors will usually be performed, but if a numeric argument is given, correcting completion will not be performed.

The default value for this style is ‘<tt>2 numeric</tt>’.

<a name="index-max_002dmatches_002dwidth_002c-completion-style"></a></dd>

<dt><tt>max-matches-width</tt></dt>

<dd>

This style is used to determine the trade off between the width of the display used for matches and the width used for their descriptions when the <tt>verbose</tt> style is in effect. The value gives the number of display columns to reserve for the matches. The default is half the width of the screen.

This has the most impact when several matches have the same description and so will be grouped together. Increasing the style will allow more matches to be grouped together; decreasing it will allow more of the description to be visible.

<a name="index-menu_002c-completion-style"></a></dd>

<dt><tt>menu</tt></dt>

<dd>

If this is ‘true’ in the context of any of the tags defined for the current completion menu completion will be used. The value for a specific tag will take precedence over that for the ‘<tt>default</tt>’ tag.

If none of the values found in this way is ‘true’ but at least one is set to ‘<tt>auto</tt>’, the shell behaves as if the <tt>AUTO_MENU</tt> option is set.

If one of the values is explicitly set to ‘false’, menu completion will be explicitly turned off, overriding the <tt>MENU_COMPLETE</tt> option and other settings.

In the form ‘<tt>yes=</tt><var>num</var>’, where ‘<tt>yes</tt>’ may be any of the ‘true’ values (‘<tt>yes</tt>’, ‘<tt>true</tt>’, ‘<tt>on</tt>’ and ‘<tt>1</tt>’), menu completion will be turned on if there are at least <var>num</var> matches. In the form ‘<tt>yes=long</tt>’, menu completion will be turned on if the list does not fit on the screen. This does not activate menu completion if the widget normally only lists completions, but menu completion can be activated in that case with the value ‘<tt>yes=long-list</tt>’ (Typically, the value ‘<tt>select=long-list</tt>’ described later is more useful as it provides control over scrolling.)

Similarly, with any of the ‘false’ values (as in ‘<tt>no=10</tt>’), menu completion will *not* be used if there are <var>num</var> or more matches.

The value of this widget also controls menu selection, as implemented by the <tt>zsh/complist</tt> module. The following values may appear either alongside or instead of the values above.

If the value contains the string ‘<tt>select</tt>’, menu selection will be started unconditionally.

In the form ‘<tt>select=</tt><var>num</var>’, menu selection will only be started if there are at least <var>num</var> matches. If the values for more than one tag provide a number, the smallest number is taken.

Menu selection can be turned off explicitly by defining a value containing the string‘<tt>no-select</tt>’.

It is also possible to start menu selection only if the list of matches does not fit on the screen by using the value ‘<tt>select=long</tt>’. To start menu selection even if the current widget only performs listing, use the value ‘<tt>select=long-list</tt>’.

To turn on menu completion or menu selection when a there are a certain number of matches *or* the list of matches does not fit on the screen, both of ‘<tt>yes=</tt>’ and ‘<tt>select=</tt>’ may be given twice, once with a number and once with ‘<tt>long</tt>’ or ‘<tt>long-list</tt>’.

Finally, it is possible to activate two special modes of menu selection. The word ‘<tt>interactive</tt>’ in the value causes interactive mode to be entered immediately when menu selection is started; see [The zsh/complist Module](Zsh-Modules.html#The-zsh_002fcomplist-Module) for a description of interactive mode. Including the string ‘<tt>search</tt>’ does the same for incremental search mode. To select backward incremental search, include the string ‘<tt>search-backward</tt>’.

<a name="index-muttrc_002c-completion-style"></a></dd>

<dt><tt>muttrc</tt></dt>

<dd>

If set, gives the location of the mutt configuration file. It defaults to ‘<tt>~/.muttrc</tt>’.

<a name="index-numbers_002c-completion-style"></a></dd>

<dt><tt>numbers</tt></dt>

<dd>

This is used with the <tt>jobs</tt> tag. If it is ‘true’, the shell will complete job numbers instead of the shortest unambiguous prefix of the job command text. If the value is a number, job numbers will only be used if that many words from the job descriptions are required to resolve ambiguities. For example, if the value is ‘<tt>1</tt>’, strings will only be used if all jobs differ in the first word on their command lines.

<a name="index-old_002dlist_002c-completion-style"></a></dd>

<dt><tt>old-list</tt></dt>

<dd>

This is used by the <tt>_oldlist</tt> completer. If it is set to ‘<tt>always</tt>’, then standard widgets which perform listing will retain the current list of matches, however they were generated; this can be turned off explicitly with the value ‘<tt>never</tt>’, giving the behaviour without the <tt>_oldlist</tt> completer. If the style is unset, or any other value, then the existing list of completions is displayed if it is not already; otherwise, the standard completion list is generated; this is the default behaviour of <tt>_oldlist</tt>. However, if there is an old list and this style contains the name of the completer function that generated the list, then the old list will be used even if it was generated by a widget which does not do listing.

For example, suppose you type <tt>^Xc</tt> to use the <tt>_correct_word</tt> widget, which generates a list of corrections for the word under the cursor. Usually, typing <tt>^D</tt> would generate a standard list of completions for the word on the command line, and show that. With <tt>_oldlist</tt>, it will instead show the list of corrections already generated.

As another example consider the <tt>_match</tt> completer: with the <tt>insert-unambiguous</tt> style set to ‘true’ it inserts only a common prefix string, if there is any. However, this may remove parts of the original pattern, so that further completion could produce more matches than on the first attempt. By using the <tt>_oldlist</tt> completer and setting this style to <tt>_match</tt>, the list of matches generated on the first attempt will be used again.

<a name="index-old_002dmatches_002c-completion-style"></a></dd>

<dt><tt>old-matches</tt></dt>

<dd>

This is used by the <tt>_all_matches</tt> completer to decide if an old list of matches should be used if one exists. This is selected by one of the ‘true’ values or by the string ‘<tt>only</tt>’. If the value is ‘<tt>only</tt>’, <tt>_all_matches</tt> will only use an old list and won’t have any effect on the list of matches currently being generated.

If this style is set it is generally unwise to call the <tt>_all_matches</tt> completer unconditionally. One possible use is for either this style or the <tt>completer</tt> style to be defined with the <tt>-e</tt> option to <tt>zstyle</tt> to make the style conditional.

<a name="index-old_002dmenu_002c-completion-style"></a></dd>

<dt><tt>old-menu</tt></dt>

<dd>

This is used by the <tt>_oldlist</tt> completer. It controls how menu completion behaves when a completion has already been inserted and the user types a standard completion key such as <tt>TAB</tt>. The default behaviour of <tt>_oldlist</tt> is that menu completion always continues with the existing list of completions. If this style is set to ‘false’, however, a new completion is started if the old list was generated by a different completion command; this is the behaviour without the <tt>_oldlist</tt> completer.

For example, suppose you type <tt>^Xc</tt> to generate a list of corrections, and menu completion is started in one of the usual ways. Usually, or with this style set to ‘false’, typing <tt>TAB</tt> at this point would start trying to complete the line as it now appears. With <tt>_oldlist</tt>, it instead continues to cycle through the list of corrections.

<a name="index-original_002c-completion-style"></a></dd>

<dt><tt>original</tt></dt>

<dd>

This is used by the <tt>_approximate</tt> and <tt>_correct</tt> completers to decide if the original string should be added as a possible completion. Normally, this is done only if there are at least two possible corrections, but if this style is set to ‘true’, it is always added. Note that the style will be examined with the completer field in the context name set to <tt>correct-</tt><var>num</var> or <tt>approximate-</tt><var>num</var>, where <var>num</var> is the number of errors that were accepted.

<a name="index-packageset_002c-completion-style"></a></dd>

<dt><tt>packageset</tt></dt>

<dd>

This style is used when completing arguments of the Debian ‘<tt>dpkg</tt>’ program. It contains an override for the default package set for a given context. For example,

<div class="example">

<pre class="example">zstyle ':completion:*:complete:dpkg:option--status-1:*' \ 
               packageset avail
</pre>

</div>

causes available packages, rather than only installed packages, to be completed for ‘<tt>dpkg -</tt><tt>-status</tt>’.

<a name="index-path_002c-completion-style"></a></dd>

<dt><tt>path</tt></dt>

<dd>

The function that completes color names uses this style with the <tt>colors</tt> tag. The value should be the pathname of a file containing color names in the format of an X11 <tt>rgb.txt</tt> file. If the style is not set but this file is found in one of various standard locations it will be used as the default.

<a name="index-path_002dcompletion_002c-completion-style"></a></dd>

<dt><tt>path-completion</tt></dt>

<dd>

This is used by filename completion. By default, filename completion examines all components of a path to see if there are completions of that component. For example, <tt>/u/b/z</tt> can be completed to <tt>/usr/bin/zsh</tt>. Explicitly setting this style to ‘false’ inhibits this behaviour for path components up to the <tt>/</tt> before the cursor; this overrides the setting of <tt>accept-exact-dirs</tt>.

Even with the style set to ‘false’, it is still possible to complete multiple paths by setting the option <tt>COMPLETE_IN_WORD</tt> and moving the cursor back to the first component in the path to be completed. For example, <tt>/u/b/z</tt> can be completed to <tt>/usr/bin/zsh</tt> if the cursor is after the <tt>/u</tt>.

<a name="index-pine_002ddirectory_002c-completion-style"></a></dd>

<dt><tt>pine-directory</tt></dt>

<dd>

If set, specifies the directory containing PINE mailbox files. There is no default, since recursively searching this directory is inconvenient for anyone who doesn’t use PINE.

<a name="index-ports_002c-completion-style"></a></dd>

<dt><tt>ports</tt></dt>

<dd>

A list of Internet service names (network ports) to complete. If this is not set, service names are taken from the file ‘<tt>/etc/services</tt>’.

<a name="index-prefix_002dhidden_002c-completion-style"></a></dd>

<dt><tt>prefix-hidden</tt></dt>

<dd>

This is used for certain completions which share a common prefix, for example command options beginning with dashes. If it is ‘true’, the prefix will not be shown in the list of matches.

The default value for this style is ‘false’.

<a name="index-prefix_002dneeded_002c-completion-style"></a></dd>

<dt><tt>prefix-needed</tt></dt>

<dd>

This style is also relevant for matches with a common prefix. If it is set to ‘true’ this common prefix must be typed by the user to generate the matches.

The style is applicable to the <tt>options</tt>, <tt>signals</tt>, <tt>jobs</tt>, <tt>functions</tt>, and <tt>parameters</tt> completion tags.

For command options, this means that the initial ‘<tt>\-</tt>’, ‘<tt>\+</tt>’, or ‘<tt>\-</tt><tt>\-</tt>’ must be typed explicitly before option names will be completed.

For signals, an initial ‘<tt>\-</tt>’ is required before signal names will be completed.

For jobs, an initial ‘<tt>%</tt>’ is required before job names will be completed.

For function and parameter names, an initial ‘<tt>\_</tt>’ or ‘<tt>.</tt>’ is required before function or parameter names starting with those characters will be completed.

The default value for this style is ‘false’ for <tt>function</tt> and <tt>parameter</tt> completions, and ‘true’ otherwise.

<a name="index-preserve_002dprefix_002c-completion-style"></a></dd>

<dt><tt>preserve-prefix</tt></dt>

<dd>

This style is used when completing path names. Its value should be a pattern matching an initial prefix of the word to complete that should be left unchanged under all circumstances. For example, on some Unices an initial ‘<tt>//</tt>’ (double slash) has a special meaning; setting this style to the string ‘<tt>//</tt>’ will preserve it. As another example, setting this style to ‘<tt>?:/</tt>’ under Cygwin would allow completion after ‘<tt>a:/...</tt>’ and so on.

<a name="index-range_002c-completion-style"></a></dd>

<dt><tt>range</tt></dt>

<dd>

This is used by the <tt>_history</tt> completer and the <tt>_history_complete_word</tt> bindable command to decide which words should be completed.

If it is a single number, only the last <var>N</var> words from the history will be completed.

If it is a range of the form ‘<var>max</var><tt>:</tt><var>slice</var>’, the last <var>slice</var> words will be completed; then if that yields no matches, the <var>slice</var> words before those will be tried and so on. This process stops either when at least one match has been found, or <var>max</var> words have been tried.

The default is to complete all words from the history at once.

<a name="index-recursive_002dfiles_002c-completion-style"></a></dd>

<dt><tt>recursive-files</tt></dt>

<dd>

If this style is set, its value is an array of patterns to be tested against ‘<tt>$PWD/</tt>’: note the trailing slash, which allows directories in the pattern to be delimited unambiguously by including slashes on both sides. If an ordinary file completion fails and the word on the command line does not yet have a directory part to its name, the style is retrieved using the same tag as for the completion just attempted, then the elements tested against <tt>$PWD/</tt> in turn. If one matches, then the shell reattempts completion by prepending the word on the command line with each directory in the expansion of <tt>\**/*(/)</tt> in turn. Typically the elements of the style will be set to restrict the number of directories beneath the current one to a manageable number, for example ‘<tt>*/.git/*</tt>’.

For example,

<div class="example">

<pre class="example">zstyle ':completion:*' recursive-files '*/zsh/*'
</pre>

</div>

If the current directory is <tt>/home/pws/zsh/Src</tt>, then <tt>zle_tr</tt>*TAB* can be completed to <tt>Zle/zle_tricky.c</tt>.

<a name="index-regular_002c-completion-style"></a></dd>

<dt><tt>regular</tt></dt>

<dd>

This style is used by the <tt>_expand_alias</tt> completer and bindable command. If set to ‘true’ (the default), regular aliases will be expanded but only in command position. If it is set to ‘false’, regular aliases will never be expanded. If it is set to ‘<tt>always</tt>’, regular aliases will be expanded even if not in command position.

<a name="index-rehash_002c-completion-style"></a></dd>

<dt><tt>rehash</tt></dt>

<dd>

If this is set when completing external commands, the internal list (hash) of commands will be updated for each search by issuing the <tt>rehash</tt> command. There is a speed penalty for this which is only likely to be noticeable when directories in the path have slow file access.

<a name="index-remote_002daccess_002c-completion-style"></a></dd>

<dt><tt>remote-access</tt></dt>

<dd>

If set to ‘false’, certain commands will be prevented from making Internet connections to retrieve remote information. This includes the completion for the <tt>CVS</tt> command.

It is not always possible to know if connections are in fact to a remote site, so some may be prevented unnecessarily.

<a name="index-remove_002dall_002ddups_002c-completion-style"></a></dd>

<dt><tt>remove-all-dups</tt></dt>

<dd>

The <tt>_history_complete_word</tt> bindable command and the <tt>_history</tt> completer use this to decide if all duplicate matches should be removed, rather than just consecutive duplicates.

<a name="index-select_002dprompt_002c-completion-style"></a></dd>

<dt><tt>select-prompt</tt></dt>

<dd>

If this is set for the <tt>default</tt> tag, its value will be displayed during menu selection (see the <tt>menu</tt> style above) when the completion list does not fit on the screen as a whole. The same escapes as for the <tt>list-prompt</tt> style are understood, except that the numbers refer to the match or line the mark is on. A default prompt is used when the value is the empty string.

<a name="index-select_002dscroll_002c-completion-style"></a></dd>

<dt><tt>select-scroll</tt></dt>

<dd>

This style is tested for the <tt>default</tt> tag and determines how a completion list is scrolled during a menu selection (see the <tt>menu</tt> style above) when the completion list does not fit on the screen as a whole. If the value is ‘<tt>0</tt>’ (zero), the list is scrolled by half-screenfuls; if it is a positive integer, the list is scrolled by the given number of lines; if it is a negative number, the list is scrolled by a screenful minus the absolute value of the given number of lines. The default is to scroll by single lines.

<a name="index-separate_002dsections_002c-completion-style"></a></dd>

<dt><tt>separate-sections</tt></dt>

<dd>

This style is used with the <tt>manuals</tt> tag when completing names of manual pages. If it is ‘true’, entries for different sections are added separately using tag names of the form ‘<tt>manual.</tt><var>X</var>’, where <var>X</var> is the section number. When the <tt>group-name</tt> style is also in effect, pages from different sections will appear separately. This style is also used similarly with the <tt>words</tt> style when completing words for the dict command. It allows words from different dictionary databases to be added separately. The default for this style is ‘false’.

<a name="index-show_002dambiguity_002c-completion-style"></a></dd>

<dt><tt>show-ambiguity</tt></dt>

<dd>

If the <tt>zsh/complist</tt> module is loaded, this style can be used to highlight the first ambiguous character in completion lists. The value is either a color indication such as those supported by the <tt>list-colors</tt> style or, with a value of ‘true’, a default of underlining is selected. The highlighting is only applied if the completion display strings correspond to the actual matches.

<a name="index-show_002dcompleter_002c-completion-style"></a></dd>

<dt><tt>show-completer</tt></dt>

<dd>

Tested whenever a new completer is tried. If it is ‘true’, the completion system outputs a progress message in the listing area showing what completer is being tried. The message will be overwritten by any output when completions are found and is removed after completion is finished.

<a name="index-single_002dignored_002c-completion-style"></a></dd>

<dt><tt>single-ignored</tt></dt>

<dd>

This is used by the <tt>_ignored</tt> completer when there is only one match. If its value is ‘<tt>show</tt>’, the single match will be displayed but not inserted. If the value is ‘<tt>menu</tt>’, then the single match and the original string are both added as matches and menu completion is started, making it easy to select either of them.

<a name="index-sort_002c-completion-style"></a></dd>

<dt><tt>sort</tt></dt>

<dd>

Many completion widgets call <tt>_description</tt> at some point which decides whether the matches are added sorted or unsorted (often indirectly via <tt>_wanted</tt> or <tt>_requested</tt>). This style can be set explicitly to one of the usual ‘true’ or ‘false’ values as an override. If it is not set for the context, the standard behaviour of the calling widget is used.

The style is tested first against the full context including the tag, and if that fails to produce a value against the context without the tag.

If the calling widget explicitly requests unsorted matches, this is usually honoured. However, the default (unsorted) behaviour of completion for the command history may be overridden by setting the style to ‘true’.

In the <tt>_expand</tt> completer, if it is set to ‘true’, the expansions generated will always be sorted. If it is set to ‘<tt>menu</tt>’, then the expansions are only sorted when they are offered as single strings but not in the string containing all possible expansions.

<a name="index-special_002ddirs_002c-completion-style"></a></dd>

<dt><tt>special-dirs</tt></dt>

<dd>

Normally, the completion code will not produce the directory names ‘<tt>.</tt>’ and ‘<tt>..</tt>’ as possible completions. If this style is set to ‘true’, it will add both ‘<tt>.</tt>’ and ‘<tt>..</tt>’ as possible completions; if it is set to ‘<tt>..</tt>’, only ‘<tt>..</tt>’ will be added.

The following example sets <tt>special-dirs</tt> to ‘<tt>..</tt>’ when the current prefix is empty, is a single ‘<tt>.</tt>’, or consists only of a path beginning with ‘<tt>../</tt>’. Otherwise the value is ‘false’.

<div class="example">

<pre class="example">zstyle -e ':completion:*' special-dirs \ 
   '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'
</pre>

</div>

<a name="index-squeeze_002dslashes_002c-completion-style"></a></dd>

<dt><tt>squeeze-slashes</tt></dt>

<dd>

If set to ‘true’, sequences of slashes in filename paths (for example in ‘<tt>foo//bar</tt>’) will be treated as a single slash. This is the usual behaviour of UNIX paths. However, by default the file completion function behaves as if there were a ‘<tt>\*</tt>’ between the slashes.

<a name="index-stop_002c-completion-style"></a></dd>

<dt><tt>stop</tt></dt>

<dd>

If set to ‘true’, the <tt>_history_complete_word</tt> bindable command will stop once when reaching the beginning or end of the history. Invoking <tt>_history_complete_word</tt> will then wrap around to the opposite end of the history. If this style is set to ‘false’ (the default), <tt>_history_complete_word</tt> will loop immediately as in a menu completion.

<a name="index-strip_002dcomments_002c-completion-style"></a></dd>

<dt><tt>strip-comments</tt></dt>

<dd>

If set to ‘true’, this style causes non-essential comment text to be removed from completion matches. Currently it is only used when completing e-mail addresses where it removes any display name from the addresses, cutting them down to plain <var>user@host</var> form.

<a name="index-subst_002dglobs_002donly_002c-completion-style"></a></dd>

<dt><tt>subst-globs-only</tt></dt>

<dd>

This is used by the <tt>_expand</tt> completer. If it is set to ‘true’, the expansion will only be used if it resulted from globbing; hence, if expansions resulted from the use of the <tt>substitute</tt> style described below, but these were not further changed by globbing, the expansions will be rejected.

The default for this style is ‘false’.

<a name="index-substitute_002c-completion-style"></a></dd>

<dt><tt>substitute</tt></dt>

<dd>

This boolean style controls whether the <tt>_expand</tt> completer will first try to expand all substitutions in the string (such as ‘<tt>$(</tt><var>...</var><tt>\)</tt>’ and ‘<tt>${</tt><var>...</var><tt>\}</tt>’).

The default is ‘true’.

<a name="index-suffix_002c-completion-style"></a></dd>

<dt><tt>suffix</tt></dt>

<dd>

This is used by the <tt>_expand</tt> completer if the word starts with a tilde or contains a parameter expansion. If it is set to ‘true’, the word will only be expanded if it doesn’t have a suffix, i.e. if it is something like ‘<tt>~foo</tt>’ or ‘<tt>$foo</tt>’ rather than ‘<tt>~foo/</tt>’ or ‘<tt>$foo/bar</tt>’, unless that suffix itself contains characters eligible for expansion. The default for this style is ‘true’.

<a name="index-tag_002dorder_002c-completion-style"></a></dd>

<dt><tt>tag-order</tt></dt>

<dd>

This provides a mechanism for sorting how the tags available in a particular context will be used.

The values for the style are sets of space-separated lists of tags. The tags in each value will be tried at the same time; if no match is found, the next value is used. (See the <tt>file-patterns</tt> style for an exception to this behavior.)

For example:

<div class="example">

<pre class="example">zstyle ':completion:*:complete:-command-:*:*' tag-order \ 
    'commands functions'
</pre>

</div>

specifies that completion in command position first offers external commands and shell functions. Remaining tags will be tried if no completions are found.

In addition to tag names, each string in the value may take one of the following forms:

<dl compact="compact">

<dt><tt>-</tt></dt>

<dd>

If any value consists of only a hyphen, then _only_ the tags specified in the other values are generated. Normally all tags not explicitly selected are tried last if the specified tags fail to generate any matches. This means that a single value consisting only of a single hyphen turns off completion.

</dd>

<dt><tt>!</tt> <var>tags</var>...</dt>

<dd>

A string starting with an exclamation mark specifies names of tags that are _not_ to be used. The effect is the same as if all other possible tags for the context had been listed.

</dd>

<dt><var>tag</var><tt>:</tt><var>label</var> ...</dt>

<dd>

Here, <var>tag</var> is one of the standard tags and <var>label</var> is an arbitrary name. Matches are generated as normal but the name <var>label</var> is used in contexts instead of <var>tag</var>. This is not useful in words starting with <tt>!</tt>.

If the <var>label</var> starts with a hyphen, the <var>tag</var> is prepended to the <var>label</var> to form the name used for lookup. This can be used to make the completion system try a certain tag more than once, supplying different style settings for each attempt; see below for an example.

</dd>

<dt><var>tag</var><tt>:</tt><var>label</var><tt>:</tt><var>description</var></dt>

<dd>

As before, but <tt>description</tt> will replace the ‘<tt>%d</tt>’ in the value of the <tt>format</tt> style instead of the default description supplied by the completion function. Spaces in the description must be quoted with a backslash. A ‘<tt>%d</tt>’ appearing in <var>description</var> is replaced with the description given by the completion function.

</dd>

</dl>

In any of the forms above the tag may be a pattern or several patterns in the form ‘<tt>\{</tt><var>pat1</var><tt>,</tt><var>pat2...</var><tt>\}</tt>’. In this case all matching tags will be used except for any given explicitly in the same string.

One use of these features is to try one tag more than once, setting other styles differently on each attempt, but still to use all the other tags without having to repeat them all. For example, to make completion of function names in command position ignore all the completion functions starting with an underscore the first time completion is tried:

<div class="example">

<pre class="example">zstyle ':completion:*:*:-command-:*:*' tag-order \ 
    'functions:-non-comp *' functions
zstyle ':completion:*:functions-non-comp' \ 
    ignored-patterns '_*'
</pre>

</div>

On the first attempt, all tags will be offered but the <tt>functions</tt> tag will be replaced by <tt>functions-non-comp</tt>. The <tt>ignored-patterns</tt> style is set for this tag to exclude functions starting with an underscore. If there are no matches, the second value of the <tt>tag-order</tt> style is used which completes functions using the default tag, this time presumably including all function names.

The matches for one tag can be split into different groups. For example:

<div class="example">

<pre class="example">zstyle ':completion:*' tag-order \ 
    'options:-long:long\ options
     options:-short:short\ options
     options:-single-letter:single\ letter\ options'
zstyle ':completion:*:options-long' \ 
     ignored-patterns '[-+](|-|[^-]*)'
zstyle ':completion:*:options-short' \ 
     ignored-patterns '--*' '[-+]?'
zstyle ':completion:*:options-single-letter' \ 
     ignored-patterns '???*'
</pre>

</div>

With the <tt>group-names</tt> style set, options beginning with ‘<tt>\-</tt><tt>\-</tt>’, options beginning with a single ‘<tt>\-</tt>’ or ‘<tt>\+</tt>’ but containing multiple characters, and single-letter options will be displayed in separate groups with different descriptions.

Another use of patterns is to try multiple match specifications one after another. The <tt>matcher-list</tt> style offers something similar, but it is tested very early in the completion system and hence can’t be set for single commands nor for more specific contexts. Here is how to try normal completion without any match specification and, if that generates no matches, try again with case-insensitive matching, restricting the effect to arguments of the command <tt>foo</tt>:

<div class="example">

<pre class="example">zstyle ':completion:*:*:foo:*:*' tag-order '*' '*:-case'
zstyle ':completion:*-case' matcher 'm:{a-z}={A-Z}'
</pre>

</div>

First, all the tags offered when completing after <tt>foo</tt> are tried using the normal tag name. If that generates no matches, the second value of <tt>tag-order</tt> is used, which tries all tags again except that this time each has <tt>-case</tt> appended to its name for lookup of styles. Hence this time the value for the <tt>matcher</tt> style from the second call to <tt>zstyle</tt> in the example is used to make completion case-insensitive.

It is possible to use the <tt>-e</tt> option of the <tt>zstyle</tt> builtin command to specify conditions for the use of particular tags. For example:

<div class="example">

<pre class="example">zstyle -e '*:-command-:*' tag-order '
    if [[ -n $PREFIX$SUFFIX ]]; then
      reply=( )
    else
      reply=( - )
    fi'
</pre>

</div>

Completion in command position will be attempted only if the string typed so far is not empty. This is tested using the <tt>PREFIX</tt> special parameter; see [Completion Widgets](Completion-Widgets.html#Completion-Widgets) for a description of parameters which are special inside completion widgets. Setting <tt>reply</tt> to an empty array provides the default behaviour of trying all tags at once; setting it to an array containing only a hyphen disables the use of all tags and hence of all completions.

If no <tt>tag-order</tt> style has been defined for a context, the strings ‘<tt>(|*-)argument-* (|*-)option-* values</tt>’ and ‘<tt>options</tt>’ plus all tags offered by the completion function will be used to provide a sensible default behavior that causes arguments (whether normal command arguments or arguments of options) to be completed before option names for most commands.

<a name="index-urls_002c-completion-style"></a></dd>

<dt><tt>urls</tt></dt>

<dd>

This is used together with the <tt>urls</tt> tag by functions completing URLs.

If the value consists of more than one string, or if the only string does not name a file or directory, the strings are used as the URLs to complete.

If the value contains only one string which is the name of a normal file the URLs are taken from that file (where the URLs may be separated by white space or newlines).

Finally, if the only string in the value names a directory, the directory hierarchy rooted at this directory gives the completions. The top level directory should be the file access method, such as ‘<tt>http</tt>’, ‘<tt>ftp</tt>’, ‘<tt>bookmark</tt>’ and so on. In many cases the next level of directories will be a filename. The directory hierarchy can descend as deep as necessary.

For example,

<div class="example">

<pre class="example">zstyle ':completion:*' urls ~/.urls
mkdir -p ~/.urls/ftp/ftp.zsh.org/pub

</pre>

</div>

allows completion of all the components of the URL <tt>ftp://ftp.zsh.org/pub</tt> after suitable commands such as ‘<tt>netscape</tt>’ or ‘<tt>lynx</tt>’. Note, however, that access methods and files are completed separately, so if the <tt>hosts</tt> style is set hosts can be completed without reference to the <tt>urls</tt> style.

See the description in the function <tt>_urls</tt> itself for more information (e.g. ‘<tt>more $^fpath/_urls(N)</tt>’).

<a name="index-use_002dcache_002c-completion-style"></a></dd>

<dt><tt>use-cache</tt></dt>

<dd>

If this is set, the completion caching layer is activated for any completions which use it (via the <tt>_store_cache</tt>, <tt>_retrieve_cache</tt>, and <tt>_cache_invalid</tt> functions). The directory containing the cache files can be changed with the <tt>cache-path</tt> style.

<a name="index-use_002dcompctl_002c-completion-style"></a></dd>

<dt><tt>use-compctl</tt></dt>

<dd>

If this style is set to a string *not* equal to <tt>false</tt>, <tt>0</tt>, <tt>no</tt>, and <tt>off</tt>, the completion system may use any completion specifications defined with the <tt>compctl</tt> builtin command. If the style is unset, this is done only if the <tt>zsh/compctl</tt> module is loaded. The string may also contain the substring ‘<tt>first</tt>’ to use completions defined with ‘<tt>compctl -T</tt>’, and the substring ‘<tt>default</tt>’ to use the completion defined with ‘<tt>compctl -D</tt>’.

Note that this is only intended to smooth the transition from <tt>compctl</tt> to the new completion system and may disappear in the future.

Note also that the definitions from <tt>compctl</tt> will only be used if there is no specific completion function for the command in question. For example, if there is a function <tt>_foo</tt> to complete arguments to the command <tt>foo</tt>, <tt>compctl</tt> will never be invoked for <tt>foo</tt>. However, the <tt>compctl</tt> version will be tried if <tt>foo</tt> only uses default completion.

<a name="index-use_002dip_002c-completion-style"></a></dd>

<dt><tt>use-ip</tt></dt>

<dd>

By default, the function <tt>_hosts</tt> that completes host names strips IP addresses from entries read from host databases such as NIS and ssh files. If this style is ‘true’, the corresponding IP addresses can be completed as well. This style is not use in any context where the <tt>hosts</tt> style is set; note also it must be set before the cache of host names is generated (typically the first completion attempt).

<a name="index-users_002c-completion-style"></a></dd>

<dt><tt>users</tt></dt>

<dd>

This may be set to a list of usernames to be completed. If it is not set all usernames will be completed. Note that if it is set only that list of users will be completed; this is because on some systems querying all users can take a prohibitive amount of time.

<a name="index-users_002dhosts_002c-completion-style"></a></dd>

<dt><tt>users-hosts</tt></dt>

<dd>

The values of this style should be of the form ‘<var>user</var><tt>@</tt><var>host</var>’ or ‘<var>user</var><tt>:</tt><var>host</var>’. It is used for commands that need pairs of user- and hostnames. These commands will complete usernames from this style (only), and will restrict subsequent hostname completion to hosts paired with that user in one of the values of the style.

It is possible to group values for sets of commands which allow a remote login, such as <tt>rlogin</tt> and <tt>ssh</tt>, by using the <tt>my-accounts</tt> tag. Similarly, values for sets of commands which usually refer to the accounts of other people, such as <tt>talk</tt> and <tt>finger</tt>, can be grouped by using the <tt>other-accounts</tt> tag. More ambivalent commands may use the <tt>accounts</tt> tag.

<a name="index-users_002dhosts_002dports_002c-completion-style"></a></dd>

<dt><tt>users-hosts-ports</tt></dt>

<dd>

Like <tt>users-hosts</tt> but used for commands like <tt>telnet</tt> and containing strings of the form ‘<var>user</var><tt>@</tt><var>host</var><tt>:</tt><var>port</var>’.

<a name="index-verbose_002c-completion-style"></a></dd>

<dt><tt>verbose</tt></dt>

<dd>

If set, as it is by default, the completion listing is more verbose. In particular many commands show descriptions for options if this style is ‘true’.

<a name="index-word_002c-completion-style"></a></dd>

<dt><tt>word</tt></dt>

<dd>

This is used by the <tt>_list</tt> completer, which prevents the insertion of completions until a second completion attempt when the line has not changed. The normal way of finding out if the line has changed is to compare its entire contents between the two occasions. If this style is ‘true’, the comparison is instead performed only on the current word. Hence if completion is performed on another word with the same contents, completion will not be delayed.

</dd>

</dl>

---

<a name="Control-Functions"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Standard-Styles) ] | [ [Up](#Completion-System) ] | [ [\>](#Bindable-Commands) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Control-Functions-1"></a>

20.4 Control Functions
----------------------

<a name="index-completion-system_002c-choosing-completers"></a>

The initialization script <tt>compinit</tt> redefines all the widgets which perform completion to call the supplied widget function <tt>_main_complete</tt>. This function acts as a wrapper calling the so-called ‘completer’ functions that generate matches. If <tt>_main_complete</tt> is called with arguments, these are taken as the names of completer functions to be called in the order given. If no arguments are given, the set of functions to try is taken from the <tt>completer</tt> style. For example, to use normal completion and correction if that doesn’t generate any matches:

<div class="example">

<pre class="example">zstyle ':completion:*' completer _complete _correct
</pre>

</div>

after calling <tt>compinit</tt>. The default value for this style is ‘<tt>_complete _ignored</tt>’, i.e. normally only ordinary completion is tried, first with the effect of the <tt>ignored-patterns</tt> style and then without it. The <tt>_main_complete</tt> function uses the return status of the completer functions to decide if other completers should be called. If the return status is zero, no other completers are tried and the <tt>_main_complete</tt> function returns.

If the first argument to <tt>_main_complete</tt> is a single hyphen, the arguments will not be taken as names of completers. Instead, the second argument gives a name to use in the <var>completer</var> field of the context and the other arguments give a command name and arguments to call to generate the matches.

The following completer functions are contained in the distribution, although users may write their own. Note that in contexts the leading underscore is stripped, for example basic completion is performed in the context ‘<tt>:completion::complete:</tt><var>...</var>’.

<a name="index-completion-system_002c-completers"></a>

<dl compact="compact">

<dd><a name="index-_005fall_005fmatches"></a></dd>

<dt><tt>_all_matches</tt></dt>

<dd>

This completer can be used to add a string consisting of all other matches. As it influences later completers it must appear as the first completer in the list. The list of all matches is affected by the <tt>avoid-completer</tt> and <tt>old-matches</tt> styles described above.

It may be useful to use the <tt>_generic</tt> function described below to bind <tt>_all_matches</tt> to its own keystroke, for example:

<div class="example">

<pre class="example">zle -C all-matches complete-word _generic
bindkey '^Xa' all-matches
zstyle ':completion:all-matches:*' old-matches only
zstyle ':completion:all-matches::::' completer _all_matches
</pre>

</div>

Note that this does not generate completions by itself: first use any of the standard ways of generating a list of completions, then use <tt>^Xa</tt> to show all matches. It is possible instead to add a standard completer to the list and request that the list of all matches should be directly inserted:

<div class="example">

<pre class="example">zstyle ':completion:all-matches::::' completer \ 
       _all_matches _complete
zstyle ':completion:all-matches:*' insert true
</pre>

</div>

In this case the <tt>old-matches</tt> style should not be set.

<a name="index-_005fapproximate"></a></dd>

<dt><tt>_approximate</tt></dt>

<dd>

This is similar to the basic <tt>_complete</tt> completer but allows the completions to undergo corrections. The maximum number of errors can be specified by the <tt>max-errors</tt> style; see the description of approximate matching in [Filename Generation](Expansion.html#Filename-Generation) for how errors are counted. Normally this completer will only be tried after the normal <tt>_complete</tt> completer:

<div class="example">

<pre class="example">zstyle ':completion:*' completer _complete _approximate
</pre>

</div>

This will give correcting completion if and only if normal completion yields no possible completions. When corrected completions are found, the completer will normally start menu completion allowing you to cycle through these strings.

This completer uses the tags <tt>corrections</tt> and <tt>original</tt> when generating the possible corrections and the original string. The <tt>format</tt> style for the former may contain the additional sequences ‘<tt>%e</tt>’ and ‘<tt>%o</tt>’ which will be replaced by the number of errors accepted to generate the corrections and the original string, respectively.

The completer progressively increases the number of errors allowed up to the limit by the <tt>max-errors</tt> style, hence if a completion is found with one error, no completions with two errors will be shown, and so on. It modifies the completer name in the context to indicate the number of errors being tried: on the first try the completer field contains ‘<tt>approximate-1</tt>’, on the second try ‘<tt>approximate-2</tt>’, and so on.

When <tt>_approximate</tt> is called from another function, the number of errors to accept may be passed with the <tt>-a</tt> option. The argument is in the same format as the <tt>max-errors</tt> style, all in one string.

Note that this completer (and the <tt>_correct</tt> completer mentioned below) can be quite expensive to call, especially when a large number of errors are allowed. One way to avoid this is to set up the <tt>completer</tt> style using the <tt>-e</tt> option to zstyle so that some completers are only used when completion is attempted a second time on the same string, e.g.:

<div class="example">

<pre class="example">zstyle -e ':completion:*' completer '
  if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]]; then
    _last_try="$HISTNO$BUFFER$CURSOR"
    reply=(_complete _match _prefix)
  else
    reply=(_ignored _correct _approximate)
  fi'
</pre>

</div>

This uses the <tt>HISTNO</tt> parameter and the <tt>BUFFER</tt> and <tt>CURSOR</tt> special parameters that are available inside zle and completion widgets to find out if the command line hasn’t changed since the last time completion was tried. Only then are the <tt>_ignored</tt>, <tt>_correct</tt> and <tt>_approximate</tt> completers called.

<a name="index-_005fcomplete"></a></dd>

<dt><tt>_complete</tt></dt>

<dd>

This completer generates all possible completions in a context-sensitive manner, i.e. using the settings defined with the <tt>compdef</tt> function explained above and the current settings of all special parameters. This gives the normal completion behaviour.

To complete arguments of commands, <tt>_complete</tt> uses the utility function <tt>_normal</tt>, which is in turn responsible for finding the particular function; it is described below. Various contexts of the form <tt>-</tt><var>context</var><tt>-</tt> are handled specifically. These are all mentioned above as possible arguments to the <tt>#compdef</tt> tag.

Before trying to find a function for a specific context, <tt>_complete</tt> checks if the parameter ‘<tt>compcontext</tt>’ is set. Setting ‘<tt>compcontext</tt>’ allows the usual completion dispatching to be overridden which is useful in places such as a function that uses <tt>vared</tt> for input. If it is set to an array, the elements are taken to be the possible matches which will be completed using the tag ‘<tt>values</tt>’ and the description ‘<tt>value</tt>’. If it is set to an associative array, the keys are used as the possible completions and the values (if non-empty) are used as descriptions for the matches. If ‘<tt>compcontext</tt>’ is set to a string containing colons, it should be of the form ‘<var>tag</var><tt>:</tt><var>descr</var><tt>:</tt><var>action</var>’. In this case the <var>tag</var> and <var>descr</var> give the tag and description to use and the <var>action</var> indicates what should be completed in one of the forms accepted by the <tt>_arguments</tt> utility function described below.

Finally, if ‘<tt>compcontext</tt>’ is set to a string without colons, the value is taken as the name of the context to use and the function defined for that context will be called. For this purpose, there is a special context named <tt>-command-line-</tt> that completes whole command lines (commands and their arguments). This is not used by the completion system itself but is nonetheless handled when explicitly called.

<a name="index-_005fcorrect"></a></dd>

<dt><tt>_correct</tt></dt>

<dd>

Generate corrections, but not completions, for the current word; this is similar to <tt>_approximate</tt> but will not allow any number of extra characters at the cursor as that completer does. The effect is similar to spell-checking. It is based on <tt>_approximate</tt>, but the completer field in the context name is <tt>correct</tt>.

For example, with:

<div class="example">

<pre class="example">zstyle ':completion:::::' completer \ 
       _complete _correct _approximate
zstyle ':completion:*:correct:::' max-errors 2 not-numeric
zstyle ':completion:*:approximate:::' max-errors 3 numeric
</pre>

</div>

correction will accept up to two errors. If a numeric argument is given, correction will not be performed, but correcting completion will be, and will accept as many errors as given by the numeric argument. Without a numeric argument, first correction and then correcting completion will be tried, with the first one accepting two errors and the second one accepting three errors.

When <tt>_correct</tt> is called as a function, the number of errors to accept may be given following the <tt>-a</tt> option. The argument is in the same form a values to the <tt>accept</tt> style, all in one string.

This completer function is intended to be used without the <tt>_approximate</tt> completer or, as in the example, just before it. Using it after the <tt>_approximate</tt> completer is useless since <tt>_approximate</tt> will at least generate the corrected strings generated by the <tt>_correct</tt> completer — and probably more.

<a name="index-_005fexpand"></a></dd>

<dt><tt>_expand</tt></dt>

<dd>

This completer function does not really perform completion, but instead checks if the word on the command line is eligible for expansion and, if it is, gives detailed control over how this expansion is done. For this to happen, the completion system needs to be invoked with <tt>complete-word</tt>, not <tt>expand-or-complete</tt> (the default binding for <tt>TAB</tt>), as otherwise the string will be expanded by the shell’s internal mechanism before the completion system is started. Note also this completer should be called before the <tt>_complete</tt> completer function.

The tags used when generating expansions are <tt>all-expansions</tt> for the string containing all possible expansions, <tt>expansions</tt> when adding the possible expansions as single matches and <tt>original</tt> when adding the original string from the line. The order in which these strings are generated, if at all, can be controlled by the <tt>group-order</tt> and <tt>tag-order</tt> styles, as usual.

The format string for <tt>all-expansions</tt> and for <tt>expansions</tt> may contain the sequence ‘<tt>%o</tt>’ which will be replaced by the original string from the line.

The kind of expansion to be tried is controlled by the <tt>substitute</tt>, <tt>glob</tt> and <tt>subst-globs-only</tt> styles.

It is also possible to call <tt>_expand</tt> as a function, in which case the different modes may be selected with options: <tt>-s</tt> for <tt>substitute</tt>, <tt>-g</tt> for <tt>glob</tt> and <tt>-o</tt> for <tt>subst-globs-only</tt>.

<a name="index-_005fexpand_005falias"></a></dd>

<dt><tt>_expand_alias</tt></dt>

<dd>

If the word the cursor is on is an alias, it is expanded and no other completers are called. The types of aliases which are to be expanded can be controlled with the styles <tt>regular</tt>, <tt>global</tt> and <tt>disabled</tt>.

This function is also a bindable command, see [Bindable Commands](#Bindable-Commands).

<a name="index-_005fextensions"></a></dd>

<dt><tt>_extensions</tt></dt>

<dd>

If the cursor follows the string ‘<tt>*.</tt>’, filename extensions are completed. The extensions are taken from files in current directory or a directory specified at the beginning of the current word. For exact matches, completion continues to allow other completers such as <tt>_expand</tt> to expand the pattern. The standard <tt>add-space</tt> and <tt>prefix-hidden</tt> styles are observed.

<a name="index-_005fhistory"></a></dd>

<dt><tt>_history</tt></dt>

<dd>

Complete words from the shell’s command history. This completer can be controlled by the <tt>remove-all-dups</tt>, and <tt>sort</tt> styles as for the <tt>_history_complete_word</tt> bindable command, see [Bindable Commands](#Bindable-Commands) and [Completion System Configuration](#Completion-System-Configuration).

<a name="index-_005fignored"></a></dd>

<dt><tt>_ignored</tt></dt>

<dd>

The <tt>ignored-patterns</tt> style can be set to a list of patterns which are compared against possible completions; matching ones are removed. With this completer those matches can be reinstated, as if no <tt>ignored-patterns</tt> style were set. The completer actually generates its own list of matches; which completers are invoked is determined in the same way as for the <tt>_prefix</tt> completer. The <tt>single-ignored</tt> style is also available as described above.

<a name="index-_005flist"></a></dd>

<dt><tt>_list</tt></dt>

<dd>

This completer allows the insertion of matches to be delayed until completion is attempted a second time without the word on the line being changed. On the first attempt, only the list of matches will be shown. It is affected by the styles <tt>condition</tt> and <tt>word</tt>, see [Completion System Configuration](#Completion-System-Configuration).

<a name="index-_005fmatch"></a></dd>

<dt><tt>_match</tt></dt>

<dd>

This completer is intended to be used after the <tt>_complete</tt> completer. It behaves similarly but the string on the command line may be a pattern to match against trial completions. This gives the effect of the <tt>GLOB_COMPLETE</tt> option.

Normally completion will be performed by taking the pattern from the line, inserting a ‘<tt>*</tt>’ at the cursor position and comparing the resulting pattern with the possible completions generated. This can be modified with the <tt>match-original</tt> style described above.

The generated matches will be offered in a menu completion unless the <tt>insert-unambiguous</tt> style is set to ‘true’; see the description above for other options for this style.

Note that matcher specifications defined globally or used by the completion functions (the styles <tt>matcher-list</tt> and <tt>matcher</tt>) will not be used.

<a name="index-_005fmenu"></a></dd>

<dt><tt>_menu</tt></dt>

<dd>

This completer was written as simple example function to show how menu completion can be enabled in shell code. However, it has the notable effect of disabling menu selection which can be useful with <tt>_generic</tt> based widgets. It should be used as the first completer in the list. Note that this is independent of the setting of the <tt>MENU_COMPLETE</tt> option and does not work with the other menu completion widgets such as <tt>reverse-menu-complete</tt>, or <tt>accept-and-menu-complete</tt>.

<a name="index-_005foldlist"></a></dd>

<dt><tt>_oldlist</tt></dt>

<dd>

This completer controls how the standard completion widgets behave when there is an existing list of completions which may have been generated by a special completion (i.e. a separately-bound completion command). It allows the ordinary completion keys to continue to use the list of completions thus generated, instead of producing a new list of ordinary contextual completions. It should appear in the list of completers before any of the widgets which generate matches. It uses two styles: <tt>old-list</tt> and <tt>old-menu</tt>, see [Completion System Configuration](#Completion-System-Configuration).

<a name="index-_005fprefix"></a></dd>

<dt><tt>_prefix</tt></dt>

<dd>

This completer can be used to try completion with the suffix (everything after the cursor) ignored. In other words, the suffix will not be considered to be part of the word to complete. The effect is similar to the <tt>expand-or-complete-prefix</tt> command.

The <tt>completer</tt> style is used to decide which other completers are to be called to generate matches. If this style is unset, the list of completers set for the current context is used — except, of course, the <tt>_prefix</tt> completer itself. Furthermore, if this completer appears more than once in the list of completers only those completers not already tried by the last invocation of <tt>_prefix</tt> will be called.

For example, consider this global <tt>completer</tt> style:

<div class="example">

<pre class="example">zstyle ':completion:*' completer \ 
    _complete _prefix _correct _prefix:foo
</pre>

</div>

Here, the <tt>_prefix</tt> completer tries normal completion but ignoring the suffix. If that doesn’t generate any matches, and neither does the call to the <tt>_correct</tt> completer after it, <tt>_prefix</tt> will be called a second time and, now only trying correction with the suffix ignored. On the second invocation the completer part of the context appears as ‘<tt>foo</tt>’.

To use <tt>_prefix</tt> as the last resort and try only normal completion when it is invoked:

<div class="example">

<pre class="example">zstyle ':completion:*' completer _complete ... _prefix
zstyle ':completion::prefix:*' completer _complete
</pre>

</div>

The <tt>add-space</tt> style is also respected. If it is set to ‘true’ then <tt>_prefix</tt> will insert a space between the matches generated (if any) and the suffix.

Note that this completer is only useful if the <tt>COMPLETE_IN_WORD</tt> option is set; otherwise, the cursor will be moved to the end of the current word before the completion code is called and hence there will be no suffix.

<a name="index-_005fuser_005fexpand"></a></dd>

<dt><tt>_user_expand</tt></dt>

<dd>

This completer behaves similarly to the <tt>_expand</tt> completer but instead performs expansions defined by users. The styles <tt>add-space</tt> and <tt>sort</tt> styles specific to the <tt>_expand</tt> completer are usable with <tt>_user_expand</tt> in addition to other styles handled more generally by the completion system. The tag <tt>all-expansions</tt> is also available.

The expansion depends on the array style <tt>user-expand</tt> being defined for the current context; remember that the context for completers is less specific than that for contextual completion as the full context has not yet been determined. Elements of the array may have one of the following forms:

<dl compact="compact">

<dt><tt>$</tt><var>hash</var></dt>

<dd>

<var>hash</var> is the name of an associative array. Note this is not a full parameter expression, merely a <tt>$</tt>, suitably quoted to prevent immediate expansion, followed by the name of an associative array. If the trial expansion word matches a key in <var>hash</var>, the resulting expansion is the corresponding value.

</dd>

<dt><var>_func</var></dt>

<dd>

<var>_func</var> is the name of a shell function whose name must begin with <tt>_</tt> but is not otherwise special to the completion system. The function is called with the trial word as an argument. If the word is to be expanded, the function should set the array <tt>reply</tt> to a list of expansions. Optionally, it can set <tt>REPLY</tt> to a word that will be used as a description for the set of expansions. The return status of the function is irrelevant.

</dd>

</dl>

</dd>

</dl>

---

<a name="Bindable-Commands"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Control-Functions) ] | [ [Up](#Completion-System) ] | [ [\>](#Completion-Functions) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Bindable-Commands-1"></a>

20.5 Bindable Commands
----------------------

<a name="index-completion-system_002c-bindable-commands"></a>

In addition to the context-dependent completions provided, which are expected to work in an intuitively obvious way, there are a few widgets implementing special behaviour which can be bound separately to keys. The following is a list of these and their default bindings.

<dl compact="compact">

<dd><a name="index-_005fbash_005fcompletions"></a></dd>

<dt><tt>_bash_completions</tt></dt>

<dd>

This function is used by two widgets, <tt>_bash_complete-word</tt> and <tt>_bash_list-choices</tt>. It exists to provide compatibility with completion bindings in bash. The last character of the binding determines what is completed: ‘<tt>!</tt>’, command names; ‘<tt>$</tt>’, environment variables; ‘<tt>@</tt>’, host names; ‘<tt>/</tt>’, file names; ‘<tt>~</tt>’ user names. In bash, the binding preceded by ‘<tt>\e</tt>’ gives completion, and preceded by ‘<tt>^X</tt>’ lists options. As some of these bindings clash with standard zsh bindings, only ‘<tt>\e~</tt>’ and ‘<tt>^X~</tt>’ are bound by default. To add the rest, the following should be added to <tt>.zshrc</tt> after <tt>compinit</tt> has been run:

<div class="example">

<pre class="example">for key in '!' '/pre> '@' '/' '~'; do
  bindkey "\e$key" _bash_complete-word
  bindkey "^X$key" _bash_list-choices
done
</pre>

</div>

This includes the bindings for ‘<tt>~</tt>’ in case they were already bound to something else; the completion code does not override user bindings.

<a name="index-_005fcorrect_005ffilename-_0028_005eXC_0029"></a></dd>

<dt><tt>_correct_filename</tt> (<tt>^XC</tt>)</dt>

<dd>

Correct the filename path at the cursor position. Allows up to six errors in the name. Can also be called with an argument to correct a filename path, independently of zle; the correction is printed on standard output.

<a name="index-_005fcorrect_005fword-_0028_005eXc_0029"></a></dd>

<dt><tt>_correct_word</tt> (<tt>^Xc</tt>)</dt>

<dd>

Performs correction of the current argument using the usual contextual completions as possible choices. This stores the string ‘<tt>correct-word</tt>’ in the <var>function</var> field of the context name and then calls the <tt>_correct</tt> completer.

<a name="index-_005fexpand_005falias-_0028_005eXa_0029"></a></dd>

<dt><tt>_expand_alias</tt> (<tt>^Xa</tt>)</dt>

<dd>

This function can be used as a completer and as a bindable command. It expands the word the cursor is on if it is an alias. The types of alias expanded can be controlled with the styles <tt>regular</tt>, <tt>global</tt> and <tt>disabled</tt>.

When used as a bindable command there is one additional feature that can be selected by setting the <tt>complete</tt> style to ‘true’. In this case, if the word is not the name of an alias, <tt>_expand_alias</tt> tries to complete the word to a full alias name without expanding it. It leaves the cursor directly after the completed word so that invoking <tt>_expand_alias</tt> once more will expand the now-complete alias name.

<a name="index-_005fexpand_005fword-_0028_005eXe_0029"></a></dd>

<dt><tt>_expand_word</tt> (<tt>^Xe</tt>)</dt>

<dd>

Performs expansion on the current word: equivalent to the standard <tt>expand-word</tt> command, but using the <tt>_expand</tt> completer. Before calling it, the <var>function</var> field of the context is set to ‘<tt>expand-word</tt>’.

<a name="index-_005fgeneric"></a></dd>

<dt><tt>_generic</tt></dt>

<dd>

This function is not defined as a widget and not bound by default. However, it can be used to define a widget and will then store the name of the widget in the <var>function</var> field of the context and call the completion system. This allows custom completion widgets with their own set of style settings to be defined easily. For example, to define a widget that performs normal completion and starts menu selection:

<div class="example">

<pre class="example">zle -C foo complete-word _generic
bindkey '...' foo
zstyle ':completion:foo:*' menu yes select=1
</pre>

</div>

Note in particular that the <tt>completer</tt> style may be set for the context in order to change the set of functions used to generate possible matches. If <tt>_generic</tt> is called with arguments, those are passed through to <tt>_main_complete</tt> as the list of completers in place of those defined by the <tt>completer</tt> style.

<a name="index-_005fhistory_005fcomplete_005fword-_0028_005ce_002f_0029"></a></dd>

<dt><tt>_history_complete_word</tt> (<tt>\e/</tt>)</dt>

<dd>

Complete words from the shell’s command history. This uses the <tt>list</tt>, <tt>remove-all-dups</tt>, <tt>sort</tt>, and <tt>stop</tt> styles.

<a name="index-_005fmost_005frecent_005ffile-_0028_005eXm_0029"></a></dd>

<dt><tt>_most_recent_file</tt> (<tt>^Xm</tt>)</dt>

<dd>

Complete the name of the most recently modified file matching the pattern on the command line (which may be blank). If given a numeric argument <var>N</var>, complete the <var>N</var>th most recently modified file. Note the completion, if any, is always unique.

<a name="index-_005fnext_005ftags-_0028_005eXn_0029"></a></dd>

<dt><tt>_next_tags</tt> (<tt>^Xn</tt>)</dt>

<dd>

This command alters the set of matches used to that for the next tag, or set of tags, either as given by the <tt>tag-order</tt> style or as set by default; these matches would otherwise not be available. Successive invocations of the command cycle through all possible sets of tags.

<a name="index-_005fread_005fcomp-_0028_005eX_005eR_0029"></a></dd>

<dt><tt>_read_comp</tt> (<tt>^X^R</tt>)</dt>

<dd>

Prompt the user for a string, and use that to perform completion on the current word. There are two possibilities for the string. First, it can be a set of words beginning ‘<tt>_</tt>’, for example ‘<tt>_files -/</tt>’, in which case the function with any arguments will be called to generate the completions. Unambiguous parts of the function name will be completed automatically (normal completion is not available at this point) until a space is typed.

Second, any other string will be passed as a set of arguments to <tt>compadd</tt> and should hence be an expression specifying what should be completed.

A very restricted set of editing commands is available when reading the string: ‘<tt>DEL</tt>’ and ‘<tt>^H</tt>’ delete the last character; ‘<tt>^U</tt>’ deletes the line, and ‘<tt>^C</tt>’ and ‘<tt>^G</tt>’ abort the function, while ‘<tt>RET</tt>’ accepts the completion. Note the string is used verbatim as a command line, so arguments must be quoted in accordance with standard shell rules.

Once a string has been read, the next call to <tt>_read_comp</tt> will use the existing string instead of reading a new one. To force a new string to be read, call <tt>_read_comp</tt> with a numeric argument.

<a name="index-_005fcomplete_005fdebug-_0028_005eX_003f_0029"></a></dd>

<dt><tt>_complete_debug</tt> (<tt>^X?</tt>)</dt>

<dd>

This widget performs ordinary completion, but captures in a temporary file a trace of the shell commands executed by the completion system. Each completion attempt gets its own file. A command to view each of these files is pushed onto the editor buffer stack.

<a name="index-_005fcomplete_005fhelp-_0028_005eXh_0029"></a></dd>

<dt><tt>_complete_help</tt> (<tt>^Xh</tt>)</dt>

<dd>

This widget displays information about the context names, the tags, and the completion functions used when completing at the current cursor position. If given a numeric argument other than <tt>1</tt> (as in ‘<tt>ESC-2 ^Xh</tt>’), then the styles used and the contexts for which they are used will be shown, too.

Note that the information about styles may be incomplete; it depends on the information available from the completion functions called, which in turn is determined by the user’s own styles and other settings.

<a name="index-_005fcomplete_005fhelp_005fgeneric"></a></dd>

<dt><tt>_complete_help_generic</tt></dt>

<dd>

Unlike other commands listed here, this must be created as a normal ZLE widget rather than a completion widget (i.e. with <tt>zle -N</tt>). It is used for generating help with a widget bound to the <tt>_generic</tt> widget that is described above.

If this widget is created using the name of the function, as it is by default, then when executed it will read a key sequence. This is expected to be bound to a call to a completion function that uses the <tt>_generic</tt> widget. That widget will be executed, and information provided in the same format that the <tt>_complete_help</tt> widget displays for contextual completion.

If the widget’s name contains <tt>debug</tt>, for example if it is created as ‘<tt>zle -N _complete_debug_generic _complete_help_generic</tt>’, it will read and execute the keystring for a generic widget as before, but then generate debugging information as done by <tt>_complete_debug</tt> for contextual completion.

If the widget’s name contains <tt>noread</tt>, it will not read a keystring but instead arrange that the next use of a generic widget run in the same shell will have the effect as described above.

The widget works by setting the shell parameter <tt>ZSH_TRACE_GENERIC_WIDGET</tt> which is read by <tt>_generic</tt>. Unsetting the parameter cancels any pending effect of the <tt>noread</tt> form.

For example, after executing the following:

<div class="example">

<pre class="example">zle -N _complete_debug_generic _complete_help_generic
bindkey '^x:' _complete_debug_generic
</pre>

</div>

typing ‘<tt>C-x :</tt>’ followed by the key sequence for a generic widget will cause trace output for that widget to be saved to a file.

<a name="index-_005fcomplete_005ftag-_0028_005eXt_0029"></a></dd>

<dt><tt>_complete_tag</tt> (<tt>^Xt</tt>)</dt>

<dd>

This widget completes symbol tags created by the <tt>etags</tt> or <tt>ctags</tt> programmes (note there is no connection with the completion system’s tags) stored in a file <tt>TAGS</tt>, in the format used by <tt>etags</tt>, or <tt>tags</tt>, in the format created by <tt>ctags</tt>. It will look back up the path hierarchy for the first occurrence of either file; if both exist, the file <tt>TAGS</tt> is preferred. You can specify the full path to a <tt>TAGS</tt> or <tt>tags</tt> file by setting the parameter <tt>$TAGSFILE</tt> or <tt>$tagsfile</tt> respectively. The corresponding completion tags used are <tt>etags</tt> and <tt>vtags</tt>, after emacs and vi respectively.

</dd>

</dl>

---

<a name="Completion-Functions"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Bindable-Commands) ] | [ [Up](#Completion-System) ] | [ [\>](#Completion-Directories) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Utility-Functions-1"></a>

20.6 Utility Functions
----------------------

<a name="index-completion-system_002c-utility-functions"></a>

Descriptions follow for utility functions that may be useful when writing completion functions. If functions are installed in subdirectories, most of these reside in the <tt>Base</tt> subdirectory. Like the example functions for commands in the distribution, the utility functions generating matches all follow the convention of returning status zero if they generated completions and non-zero if no matching completions could be added.

Two more features are offered by the <tt>_main_complete</tt> function. The arrays <tt>compprefuncs</tt> and <tt>comppostfuncs</tt> may contain names of functions that are to be called immediately before or after completion has been tried. A function will only be called once unless it explicitly reinserts itself into the array.

<dl compact="compact">

<dd><a name="index-_005fabsolute_005fcommand_005fpaths"></a></dd>

<dt><tt>_absolute_command_paths</tt></dt>

<dd>

This function completes external commands as absolute paths (unlike <tt>_command_names -e</tt> which completes their basenames). It takes no arguments.

<a name="index-_005fall_005flabels"></a></dd>

<dt><tt>_all_labels</tt> [ <tt>-x</tt> ] [ <tt>-12VJ</tt> ] <var>tag</var> <var>name</var> <var>descr</var> [ <var>command</var> <var>arg</var> ... ]</dt>

<dd>

This is a convenient interface to the <tt>_next_label</tt> function below, implementing the loop shown in the <tt>_next_label</tt> example. The <var>command</var> and its arguments are called to generate the matches. The options stored in the parameter <var>name</var> will automatically be inserted into the <var>arg</var>s passed to the <var>command</var>. Normally, they are put directly after the <var>command</var>, but if one of the <var>arg</var>s is a single hyphen, they are inserted directly before that. If the hyphen is the last argument, it will be removed from the argument list before the <var>command</var> is called. This allows <tt>_all_labels</tt> to be used in almost all cases where the matches can be generated by a single call to the <tt>compadd</tt> builtin command or by a call to one of the utility functions.

For example:

<div class="example">

<pre class="example">local expl
...
if _requested foo; then
  ...
  _all_labels foo expl '...' compadd ... - $matches
fi
</pre>

</div>

Will complete the strings from the <tt>matches</tt> parameter, using <tt>compadd</tt> with additional options which will take precedence over those generated by <tt>_all_labels</tt>.

<a name="index-_005falternative"></a></dd>

<dt><tt>_alternative</tt> [ <tt>-O</tt> <var>name</var> ] [ <tt>-C</tt> <var>name</var> ] <var>spec</var> ...</dt>

<dd>

This function is useful in simple cases where multiple tags are available. Essentially it implements a loop like the one described for the <tt>_tags</tt> function below.

The tags to use and the action to perform if a tag is requested are described using the <var>spec</var>s which are of the form: ‘<var>tag</var><tt>:</tt><var>descr</var><tt>:</tt><var>action</var>’. The <var>tag</var>s are offered using <tt>_tags</tt> and if the tag is requested, the <var>action</var> is executed with the given description <var>descr</var>. The <var>action</var>s are those accepted by the <tt>_arguments</tt> function (described below), excluding the ‘<tt>-></tt><var>state</var>’ and ‘<tt>=</tt><var>...</var>’ forms.

For example, the <var>action</var> may be a simple function call:

<div class="example">

<pre class="example">_alternative \ 
    'users:user:_users' \ 
    'hosts:host:_hosts'
</pre>

</div>

offers usernames and hostnames as possible matches, generated by the <tt>_users</tt> and <tt>_hosts</tt> functions respectively.

Like <tt>_arguments</tt>, this function uses <tt>_all_labels</tt> to execute the actions, which will loop over all sets of tags. Special handling is only required if there is an additional valid tag, for example inside a function called from <tt>_alternative</tt>.

The option ‘<tt>-O</tt> <var>name</var>’ is used in the same way as by the <tt>_arguments</tt> function. In other words, the elements of the <var>name</var> array will be passed to <tt>compadd</tt> when executing an action.

Like <tt>_tags</tt> this function supports the <tt>-C</tt> option to give a different name for the argument context field.

<a name="index-_005farguments"></a></dd>

<dt><tt>_arguments</tt> [ <tt>-nswWCRS</tt> ] [ <tt>-A</tt> <var>pat</var> ] [ <tt>-O</tt> <var>name</var> ] [ <tt>-M</tt> <var>matchspec</var> ]</dt>

<dt>[ <tt>:</tt> ] <var>spec</var> ...</dt>

<dt><tt>_arguments</tt> [ <var>opt</var> ... ] <tt>-</tt><tt>-</tt> [ <tt>-i</tt> <var>pats</var> ] [ <tt>-s</tt> <var>pair</var> ] [ <var>helpspec</var> ... ]</dt>

<dd>

This function can be used to give a complete specification for completion for a command whose arguments follow standard UNIX option and argument conventions.

_Options overview_

Options to <tt>_arguments</tt> itself must be in separate words, i.e. <tt>-s -w</tt>, not <tt>-sw</tt>. The options are followed by <var>spec</var>s that describe options and arguments of the analyzed command. <var>spec</var>s that describe option flags must precede <var>spec</var>s that describe non-option ("positional" or "normal") arguments of the analyzed line. To avoid ambiguity, all options to <tt>_arguments</tt> itself may be separated from the <var>spec</var> forms by a single colon.

The ‘<tt>-</tt><tt>-</tt>’ form is used to intuit <var>spec</var> forms from the help output of the command being analyzed, and is described in detail below. The <var>opts</var> for the ‘<tt>-</tt><tt>-</tt>’ form are otherwise the same options as the first form. Note that ‘<tt>-s</tt>’ following ‘<tt>-</tt><tt>-</tt>’ has a distinct meaning from ‘<tt>-s</tt>’ preceding ‘<tt>-</tt><tt>-</tt>’, and both may appear.

The option switches <tt>-s</tt>, <tt>-S</tt>, <tt>-A</tt>, <tt>-w</tt>, and <tt>-W</tt> affect how <tt>_arguments</tt> parses the analyzed command line’s options. These switches are useful for commands with standard argument parsing.

The options of <tt>_arguments</tt> have the following meanings:

<dl compact="compact">

<dt><tt>-n</tt></dt>

<dd>

With this option, <tt>_arguments</tt> sets the parameter <tt>NORMARG</tt> to the position of the first normal argument in the <tt>$words</tt> array, i.e. the position after the end of the options. If that argument has not been reached, <tt>NORMARG</tt> is set to <tt>-1</tt>. The caller should declare ‘<tt>integer NORMARG</tt>’ if the <tt>-n</tt> option is passed; otherwise the parameter is not used.

</dd>

<dt><tt>-s</tt></dt>

<dd>

Enable _option stacking_ for single-letter options, whereby multiple single-letter options may be combined into a single word. For example, the two options ‘<tt>-x</tt>’ and ‘<tt>-y</tt>’ may be combined into a single word ‘<tt>-xy</tt>’. By default, every word corresponds to a single option name (‘<tt>-xy</tt>’ is a single option named ‘<tt>xy</tt>’).

Options beginning with a single hyphen or plus sign are eligible for stacking; words beginning with two hyphens are not.

Note that <tt>-s</tt> after <tt>-</tt><tt>-</tt> has a different meaning, which is documented in the segment entitled ‘Deriving <var>spec</var> forms from the help output’.

</dd>

<dt><tt>-w</tt></dt>

<dd>

In combination with <tt>-s</tt>, allow option stacking even if one or more of the options take arguments. For example, if <tt>-x</tt> takes an argument, with no <tt>-s</tt>, ‘<tt>-xy</tt>’ is considered as a single (unhandled) option; with <tt>-s</tt>, <tt>-xy</tt> is an option with the argument ‘<tt>y</tt>’; with both <tt>-s</tt> and <tt>-w</tt>, <tt>-xy</tt> is the option <tt>-x</tt> and the option <tt>-y</tt> with arguments to <tt>-x</tt> (and to <tt>-y</tt>, if it takes arguments) still to come in subsequent words.

</dd>

<dt><tt>-W</tt></dt>

<dd>

This option takes <tt>-w</tt> a stage further: it is possible to complete single-letter options even after an argument that occurs in the same word. However, it depends on the action performed whether options will really be completed at this point. For more control, use a utility function like <tt>_guard</tt> as part of the action.

</dd>

<dt><tt>-C</tt></dt>

<dd>

Modify the <tt>curcontext</tt> parameter for an action of the form ‘<tt>-></tt><var>state</var>’. This is discussed in detail below.

</dd>

<dt><tt>-R</tt></dt>

<dd>

Return status 300 instead of zero when a <tt>$state</tt> is to be handled, in the ‘<tt>-></tt><var>string</var>’ syntax.

</dd>

<dt><tt>-S</tt></dt>

<dd>

Do not complete options after a ‘<tt>-</tt><tt>-</tt>’ appearing on the line, and ignore the ‘<tt>-</tt><tt>-</tt>’. For example, with <tt>-S</tt>, in the line

<div class="example">

<pre class="example">foobar -x -- -y
</pre>

</div>

the ‘<tt>-x</tt>’ is considered an option, the ‘<tt>-y</tt>’ is considered an argument, and the ‘<tt>-</tt><tt>-</tt>’ is considered to be neither.

</dd>

<dt><tt>-A</tt> <var>pat</var></dt>

<dd>

Do not complete options after the first non-option argument on the line. <var>pat</var> is a pattern matching all strings which are not to be taken as arguments. For example, to make <tt>_arguments</tt> stop completing options after the first normal argument, but ignoring all strings starting with a hyphen even if they are not described by one of the <var>optspec</var>s, the form is ‘<tt>-A "-*"</tt>’.

</dd>

<dt><tt>-O</tt> <var>name</var></dt>

<dd>

Pass the elements of the array <var>name</var> as arguments to functions called to execute <var>action</var>s. This is discussed in detail below.

</dd>

<dt><tt>-M</tt> <var>matchspec</var></dt>

<dd>

Use the match specification <var>matchspec</var> for completing option names and values. The default <var>matchspec</var> allows partial word completion after ‘<tt>_</tt>’ and ‘<tt>-</tt>’, such as completing ‘<tt>-f-b</tt>’ to ‘<tt>-foo-bar</tt>’. The default <var>matchspec</var> is:

<div class="example">

<pre class="example"><tt>r:|[_-]=* r:|=*</tt>
</pre>

</div>

</dd>

</dl>

*<var>spec</var>s: overview*

Each of the following forms is a <var>spec</var> describing individual sets of options or arguments on the command line being analyzed.

<dl compact="compact">

<dt><var>n</var><tt>:</tt><var>message</var><tt>:</tt><var>action</var></dt>

<dt><var>n</var><tt>::</tt><var>message</var><tt>:</tt><var>action</var></dt>

<dd>

This describes the <var>n</var>’th normal argument. The <var>message</var> will be printed above the matches generated and the <var>action</var> indicates what can be completed in this position (see below). If there are two colons before the <var>message</var> the argument is optional. If the <var>message</var> contains only white space, nothing will be printed above the matches unless the action adds an explanation string itself.

</dd>

<dt><tt>:</tt><var>message</var><tt>:</tt><var>action</var></dt>

<dt><tt>::</tt><var>message</var><tt>:</tt><var>action</var></dt>

<dd>

Similar, but describes the _next_ argument, whatever number that happens to be. If all arguments are specified in this form in the correct order the numbers are unnecessary.

</dd>

<dt><tt>*:</tt><var>message</var><tt>:</tt><var>action</var></dt>

<dt><tt>*::</tt><var>message</var><tt>:</tt><var>action</var></dt>

<dt><tt>*:::</tt><var>message</var><tt>:</tt><var>action</var></dt>

<dd>

This describes how arguments (usually non-option arguments, those not beginning with <tt>-</tt> or <tt>+</tt>) are to be completed when neither of the first two forms was provided. Any number of arguments can be completed in this fashion.

With two colons before the <var>message</var>, the <tt>words</tt> special array and the <tt>CURRENT</tt> special parameter are modified to refer only to the normal arguments when the <var>action</var> is executed or evaluated. With three colons before the <var>message</var> they are modified to refer only to the normal arguments covered by this description.

</dd>

<dt><var>optspec</var></dt>

<dt><var>optspec</var><tt>:</tt><var>...</var></dt>

<dd>

This describes an option. The colon indicates handling for one or more arguments to the option; if it is not present, the option is assumed to take no arguments.

The following forms are available for the initial <var>optspec</var>, whether or not the option has arguments.

<dl compact="compact">

<dt><tt>*</tt><var>optspec</var></dt>

<dd>

Here <var>optspec</var> is one of the remaining forms below. This indicates the following <var>optspec</var> may be repeated. Otherwise if the corresponding option is already present on the command line to the left of the cursor it will not be offered again.

</dd>

<dt><tt>-</tt><var>optname</var></dt>

<dt><tt>+</tt><var>optname</var></dt>

<dd>

In the simplest form the <var>optspec</var> is just the option name beginning with a minus or a plus sign, such as ‘<tt>-foo</tt>’. The first argument for the option (if any) must follow as a _separate_ word directly after the option.

Either of ‘<tt>-+</tt><var>optname</var>’ and ‘<tt>+-</tt><var>optname</var>’ can be used to specify that <tt>-</tt><var>optname</var> and <tt>+</tt><var>optname</var> are both valid.

In all the remaining forms, the leading ‘<tt>-</tt>’ may be replaced by or paired with ‘<tt>+</tt>’ in this way.

</dd>

<dt><tt>-</tt><var>optname</var><tt>-</tt></dt>

<dd>

The first argument of the option must come directly after the option name _in the same word_. For example, ‘<tt>-foo-:</tt><var>...</var>’ specifies that the completed option and argument will look like ‘<tt>-foo</tt><var>arg</var>’.

</dd>

<dt><tt>-</tt><var>optname</var><tt>+</tt></dt>

<dd>

The first argument may appear immediately after <var>optname</var> in the same word, or may appear as a separate word after the option. For example, ‘<tt>-foo+:</tt><var>...</var>’ specifies that the completed option and argument will look like either ‘<tt>-foo</tt><var>arg</var>’ or ‘<tt>-foo</tt> <var>arg</var>’.

</dd>

<dt><tt>-</tt><var>optname</var><tt>=</tt></dt>

<dd>

The argument may appear as the next word, or in same word as the option name provided that it is separated from it by an equals sign, for example ‘<tt>-foo=</tt><var>arg</var>’ or ‘<tt>-foo</tt> <var>arg</var>’.

</dd>

<dt><tt>-</tt><var>optname</var><tt>=-</tt></dt>

<dd>

The argument to the option must appear after an equals sign in the same word, and may not be given in the next argument.

</dd>

<dt><var>optspec</var><tt>[</tt><var>explanation</var><tt>]</tt></dt>

<dd>

An explanation string may be appended to any of the preceding forms of <var>optspec</var> by enclosing it in brackets, as in ‘<tt>-q[query operation]</tt>’.

The <tt>verbose</tt> style is used to decide whether the explanation strings are displayed with the option in a completion listing.

If no bracketed explanation string is given but the <tt>auto-description</tt> style is set and only one argument is described for this <var>optspec</var>, the value of the style is displayed, with any appearance of the sequence ‘<tt>%d</tt>’ in it replaced by the <var>message</var> of the first <var>optarg</var> that follows the <var>optspec</var>; see below.

</dd>

</dl>

It is possible for options with a literal ‘<tt>\+</tt>’ or ‘<tt>=</tt>’ to appear, but that character must be quoted, for example ‘<tt>\-\+</tt>’.

Each <var>optarg</var> following an <var>optspec</var> must take one of the following forms:

<dl compact="compact">

<dt><tt>:</tt><var>message</var><tt>:</tt><var>action</var></dt>

<dt><tt>::</tt><var>message</var><tt>:</tt><var>action</var></dt>

<dd>

An argument to the option; <var>message</var> and <var>action</var> are treated as for ordinary arguments. In the first form, the argument is mandatory, and in the second form it is optional.

This group may be repeated for options which take multiple arguments. In other words, <tt>:</tt><var>message1</var><tt>:</tt><var>action1</var><tt>:</tt><var>message2</var><tt>:</tt><var>action2</var> specifies that the option takes two arguments.

</dd>

<dt><tt>:*</tt><var>pattern</var><tt>:</tt><var>message</var><tt>:</tt><var>action</var></dt>

<dt><tt>:*</tt><var>pattern</var><tt>::</tt><var>message</var><tt>:</tt><var>action</var></dt>

<dt><tt>:*</tt><var>pattern</var><tt>:::</tt><var>message</var><tt>:</tt><var>action</var></dt>

<dd>

This describes multiple arguments. Only the last <var>optarg</var> for an option taking multiple arguments may be given in this form. If the <var>pattern</var> is empty (i.e. <tt>:*:</tt>), all the remaining words on the line are to be completed as described by the <var>action</var>; otherwise, all the words up to and including a word matching the <var>pattern</var> are to be completed using the <var>action</var>.

Multiple colons are treated as for the ‘<tt>*:</tt><var>...</var>’ forms for ordinary arguments: when the <var>message</var> is preceded by two colons, the <tt>words</tt> special array and the <tt>CURRENT</tt> special parameter are modified during the execution or evaluation of the <var>action</var> to refer only to the words after the option. When preceded by three colons, they are modified to refer only to the words covered by this description.

</dd>

</dl>

</dd>

</dl>

Any literal colon in an <var>optname</var>, <var>message</var>, or <var>action</var> must be preceded by a backslash, ‘<tt>:</tt>’.

Each of the forms above may be preceded by a list in parentheses of option names and argument numbers. If the given option is on the command line, the options and arguments indicated in parentheses will not be offered. For example, ‘<tt>(-two -three 1)-one:</tt><var>...</var>’ completes the option ‘<tt>-one</tt>’; if this appears on the command line, the options <tt>-two</tt> and <tt>-three</tt> and the first ordinary argument will not be completed after it. ‘<tt>(-foo):</tt><var>...</var>’ specifies an ordinary argument completion; <tt>-foo</tt> will not be completed if that argument is already present.

Other items may appear in the list of excluded options to indicate various other items that should not be applied when the current specification is matched: a single star (<tt>*</tt>) for the rest arguments (i.e. a specification of the form ‘<tt>*:</tt><var>...</var>’); a colon (<tt>:</tt>) for all normal (non-option-) arguments; and a hyphen (<tt>\-</tt>) for all options. For example, if ‘<tt>\(*\)</tt>’ appears before an option and the option appears on the command line, the list of remaining arguments (those shown in the above table beginning with ‘<tt>*:</tt>’) will not be completed.

To aid in reuse of specifications, it is possible to precede any of the forms above with ‘<tt>!</tt>’; then the form will no longer be completed, although if the option or argument appears on the command line they will be skipped as normal. The main use for this is when the arguments are given by an array, and <tt>_arguments</tt> is called repeatedly for more specific contexts: on the first call ‘<tt>_arguments $global_options</tt>’ is used, and on subsequent calls ‘<tt>_arguments !$^global_options</tt>’.

*<var>spec</var>s: actions*

In each of the forms above the <var>action</var> determines how completions should be generated. Except for the ‘<tt>-></tt><var>string</var>’ form below, the <var>action</var> will be executed by calling the <tt>_all_labels</tt> function to process all tag labels. No special handling of tags is needed unless a function call introduces a new one.

The functions called to execute <var>action</var>s will be called with the elements of the array named by the ‘<tt>-O</tt> <var>name</var>’ option as arguments. This can be used, for example, to pass the same set of options for the <tt>compadd</tt> builtin to all <var>action</var>s.

The forms for <var>action</var> are as follows.

<dl compact="compact">

<dt>(single unquoted space)</dt>

<dd>

This is useful where an argument is required but it is not possible or desirable to generate matches for it. The <var>message</var> will be displayed but no completions listed. Note that even in this case the colon at the end of the <var>message</var> is needed; it may only be omitted when neither a <var>message</var> nor an <var>action</var> is given.

</dd>

<dt><tt>(</tt><var>item1</var> <var>item2</var> <var>...</var><tt>)</tt></dt>

<dd>

One of a list of possible matches, for example:

<div class="example">

<pre class="example"><tt>:foo:(foo bar baz</tt><tt>)</tt>
</pre>

</div>

</dd>

<dt><tt>((<var>item1</var>\:<var>desc1</var> <var>...</var>))</tt></dt>

<dd>

Similar to the above, but with descriptions for each possible match. Note the backslash before the colon. For example,

<div class="example">

<pre class="example"><tt>:foo:((a\:bar b\:baz</tt><tt>))</tt>
</pre>

</div>

The matches will be listed together with their descriptions if the <tt>description</tt> style is set with the <tt>values</tt> tag in the context.

</dd>

<dt><tt>-></tt><var>string</var></dt>

<dd><a name="index-context_002c-use-of"></a><a name="index-line_002c-use-of"></a><a name="index-opt_005fargs_002c-use-of"></a>

In this form, <tt>_arguments</tt> processes the arguments and options and then returns control to the calling function with parameters set to indicate the state of processing; the calling function then makes its own arrangements for generating completions. For example, functions that implement a state machine can use this type of action.

Where <tt>_arguments</tt> encounters <var>action</var> in the ‘<tt>-></tt><var>string</var>’ format, it will strip all leading and trailing whitespace from <var>string</var> and set the array <tt>state</tt> to the set of all <var>string</var>s for which an action is to be performed. The elements of the array <tt>state_descr</tt> are assigned the corresponding <var>message</var> field from each <var>optarg</var> containing such an <var>action</var>.

By default and in common with all other well behaved completion functions, _arguments returns status zero if it was able to add matches and non-zero otherwise. However, if the <tt>-R</tt> option is given, <tt>_arguments</tt> will instead return a status of 300 to indicate that <tt>$state</tt> is to be handled.

In addition to <tt>$state</tt> and <tt>$state_descr</tt>, <tt>_arguments</tt> also sets the global parameters ‘<tt>context</tt>’, ‘<tt>line</tt>’ and ‘<tt>opt_args</tt>’ as described below, and does not reset any changes made to the special parameters such as <tt>PREFIX</tt> and <tt>words</tt>. This gives the calling function the choice of resetting these parameters or propagating changes in them.

A function calling <tt>_arguments</tt> with at least one action containing a ‘<tt>-></tt><var>string</var>’ must therefore declare appropriate local parameters:

<div class="example">

<pre class="example">local context state state_descr line
typeset -A opt_args
</pre>

</div>

to prevent <tt>_arguments</tt> from altering the global environment.

</dd>

<dt><tt>{</tt><var>eval-string</var><tt>}</tt></dt>

<dd><a name="index-expl_002c-use-of"></a>

A string in braces is evaluated as shell code to generate matches. If the <var>eval-string</var> itself does not begin with an opening parenthesis or brace it is split into separate words before execution.

</dd>

<dt><tt>=</tt> <var>action</var></dt>

<dd>

If the <var>action</var> starts with ‘<tt>=</tt> ’ (an equals sign followed by a space), <tt>_arguments</tt> will insert the contents of the <var>argument</var> field of the current context as the new first element in the <tt>words</tt> special array and increment the value of the <tt>CURRENT</tt> special parameter. This has the effect of inserting a dummy word onto the completion command line while not changing the point at which completion is taking place.

This is most useful with one of the specifiers that restrict the words on the command line on which the <var>action</var> is to operate (the two- and three-colon forms above). One particular use is when an <var>action</var> itself causes <tt>_arguments</tt> on a restricted range; it is necessary to use this trick to insert an appropriate command name into the range for the second call to <tt>_arguments</tt> to be able to parse the line.

</dd>

<dt><var>word...</var></dt>

<dt><var>word...</var></dt>

<dd>

This covers all forms other than those above. If the <var>action</var> starts with a space, the remaining list of words will be invoked unchanged.

Otherwise it will be invoked with some extra strings placed after the first word; these are to be passed down as options to the <tt>compadd</tt> builtin. They ensure that the state specified by <tt>_arguments</tt>, in particular the descriptions of options and arguments, is correctly passed to the completion command. These additional arguments are taken from the array parameter ‘<tt>expl</tt>’; this will be set up before executing the <var>action</var> and hence may be referred to inside it, typically in an expansion of the form ‘<tt>$expl[@]</tt>’ which preserves empty elements of the array.

</dd>

</dl>

During the performance of the action the array ‘<tt>line</tt>’ will be set to the normal arguments from the command line, i.e. the words from the command line after the command name excluding all options and their arguments. Options are stored in the associative array ‘<tt>opt_args</tt>’ with option names as keys and their arguments as the values. For options that have more than one argument these are given as one string, separated by colons. All colons in the original arguments are preceded with backslashes.

The parameter ‘<tt>context</tt>’ is set when returning to the calling function to perform an action of the form ‘<tt>-></tt><var>string</var>’. It is set to an array of elements corresponding to the elements of <tt>$state</tt>. Each element is a suitable name for the argument field of the context: either a string of the form ‘<tt>option</tt><var>-opt</var><tt>\-</tt><var>n</var>’ for the <var>n</var>’th argument of the option <var>-opt</var>, or a string of the form ‘<tt>argument-</tt><var>n</var>’ for the <var>n</var>’th argument. For ‘rest’ arguments, that is those in the list at the end not handled by position, <var>n</var> is the string ‘<tt>rest</tt>’. For example, when completing the argument of the <tt>-o</tt> option, the name is ‘<tt>option-o-1</tt>’, while for the second normal (non-option-) argument it is ‘<tt>argument-2</tt>’.

Furthermore, during the evaluation of the <var>action</var> the context name in the <tt>curcontext</tt> parameter is altered to append the same string that is stored in the <tt>context</tt> parameter.

The option <tt>-C</tt> tells <tt>_arguments</tt> to modify the <tt>curcontext</tt> parameter for an action of the form ‘<tt>-></tt><var>state</var>’. This is the standard parameter used to keep track of the current context. Here it (and not the <tt>context</tt> array) should be made local to the calling function to avoid passing back the modified value and should be initialised to the current value at the start of the function:

<div class="example">

<pre class="example">local curcontext="$curcontext"
</pre>

</div>

This is useful where it is not possible for multiple states to be valid together.

*Specifying multiple sets of options*

It is possible to specify multiple sets of options and arguments with the sets separated by single hyphens. The specifications before the first hyphen (if any) are shared by all the remaining sets. The first word in every other set provides a name for the set which may appear in exclusion lists in specifications, either alone or before one of the possible values described above. In the second case a ‘<tt>\-</tt>’ should appear between this name and the remainder.

For example:

<div class="example">

<pre class="example">_arguments \ 
    -a \ 
  - set1 \ 
    -c \ 
  - set2 \ 
    -d \ 
    ':arg:(x2 y2)'
</pre>

</div>

This defines two sets. When the command line contains the option ‘<tt>-c</tt>’, the ‘<tt>-d</tt>’ option and the argument will not be considered possible completions. When it contains ‘<tt>-d</tt>’ or an argument, the option ‘<tt>-c</tt>’ will not be considered. However, after ‘<tt>-a</tt>’ both sets will still be considered valid.

If an option in a set appears on the command line, it is stored in the associative array ‘<tt>opt_args</tt>’ with ’<var>set</var><tt>\-</tt><var>option</var>’ as a key. In the example above, a key ‘<tt>set1–c</tt>’ is used if the option ‘<tt>-c</tt>’ is on the command line.

If the name given for one of the mutually exclusive sets is of the form ‘<tt>\(</tt><var>name</var><tt>\)</tt>’ then only one value from each set will ever be completed; more formally, all specifications are mutually exclusive to all other specifications in the same set. This is useful for defining multiple sets of options which are mutually exclusive and in which the options are aliases for each other. For example:

<div class="example">

<pre class="example">_arguments \ 
    -a -b \ 
  - '(compress)' \ 
    {-c,--compress}'[compress]' \ 
  - '(uncompress)' \ 
    {-d,--decompress}'[decompress]'
</pre>

</div>

As the completion code has to parse the command line separately for each set this form of argument is slow and should only be used when necessary. A useful alternative is often an option specification with rest-arguments (as in ‘<tt>-foo:\*:...</tt>’); here the option <tt>-foo</tt> swallows up all remaining arguments as described by the <var>optarg</var> definitions.

*Deriving <var>spec</var> forms from the help output*

The option ‘<tt>\-</tt><tt>\-</tt>’ allows <tt>_arguments</tt> to work out the names of long options that support the ‘<tt>\-</tt><tt>-help</tt>’ option which is standard in many GNU commands. The command word is called with the argument ‘<tt>\-</tt><tt>-help</tt>’ and the output examined for option names. Clearly, it can be dangerous to pass this to commands which may not support this option as the behaviour of the command is unspecified.

In addition to options, ‘<tt>_arguments -</tt><tt>\-</tt>’ will try to deduce the types of arguments available for options when the form ‘<tt>\-</tt><tt>\-</tt><var>opt</var><tt>=</tt><var>val</var>’ is valid. It is also possible to provide hints by examining the help text of the command and adding <var>helpspec</var> of the form ‘<var>pattern</var><tt>:</tt><var>message</var><tt>:</tt><var>action</var>’; note that other <tt>_arguments</tt> <var>spec</var> forms are not used. The <var>pattern</var> is matched against the help text for an option, and if it matches the <var>message</var> and <var>action</var> are used as for other argument specifiers. The special case of ‘<tt>\*:</tt>’ means both <var>message</var> and <var>action</var> are empty, which has the effect of causing options having no description in the help output to be ordered in listings ahead of options that have a description.

For example:

<div class="example">

<pre class="example">_arguments -- '*\*:toggle:(yes no)' \ 
              '*=FILE*:file:_files' \ 
              '*=DIR*:directory:_files -/' \ 
              '*=PATH*:directory:_files -/'
</pre>

</div>

Here, ‘<tt>yes</tt>’ and ‘<tt>no</tt>’ will be completed as the argument of options whose description ends in a star; file names will be completed for options that contain the substring ‘<tt>=FILE</tt>’ in the description; and directories will be completed for options whose description contains ‘<tt>=DIR</tt>’ or ‘<tt>=PATH</tt>’. The last three are in fact the default and so need not be given explicitly, although it is possible to override the use of these patterns. A typical help text which uses this feature is:

<div class="example">

<pre class="example">  -C, --directory=DIR          change to directory DIR
</pre>

</div>

so that the above specifications will cause directories to be completed after ‘<tt>\-</tt><tt>-directory</tt>’, though not after ‘<tt>-C</tt>’.

Note also that <tt>_arguments</tt> tries to find out automatically if the argument for an option is optional. This can be specified explicitly by doubling the colon before the <var>message</var>.

If the <var>pattern</var> ends in ‘<tt>(-)</tt>’, this will be removed from the pattern and the <var>action</var> will be used only directly after the ‘<tt>=</tt>’, not in the next word. This is the behaviour of a normal specification defined with the form ‘<tt>=-</tt>’.

The ‘<tt>_arguments -</tt><tt>\-</tt>’ can be followed by the option ‘<tt>-i</tt> <var>patterns</var>’ to give patterns for options which are not to be completed. The patterns can be given as the name of an array parameter or as a literal list in parentheses. For example,

<div class="example">

<pre class="example">_arguments -- -i \ 
    "(--(en|dis)able-FEATURE*)"
</pre>

</div>

will cause completion to ignore the options ‘<tt>\-</tt><tt>-enable-FEATURE</tt>’ and ‘<tt>\-</tt><tt>-disable-FEATURE</tt>’ (this example is useful with GNU <tt>configure</tt>).

The ‘<tt>_arguments -</tt><tt>\-</tt>’ form can also be followed by the option ‘<tt>-s</tt> <var>pair</var>’ to describe option aliases. The <var>pair</var> consists of a list of alternating patterns and corresponding replacements, enclosed in parens and quoted so that it forms a single argument word in the <tt>_arguments</tt> call.

For example, some <tt>configure</tt>-script help output describes options only as ‘<tt>\-</tt><tt>-enable-foo</tt>’, but the script also accepts the negated form ‘<tt>\-</tt><tt>-disable-foo</tt>’. To allow completion of the second form:

<div class="example">

<pre class="example">_arguments -- -s "((#s)--enable- --disable-)"
</pre>

</div>

*Miscellaneous notes*

Finally, note that <tt>_arguments</tt> generally expects to be the primary function handling any completion for which it is used. It may have side effects which change the treatment of any matches added by other functions called after it. To combine <tt>_arguments</tt> with other functions, those functions should be called either before <tt>_arguments</tt>, as an <var>action</var> within a <var>spec</var>, or in handlers for ‘<tt>-></tt><var>state</var>’ actions.

Here is a more general example of the use of <tt>_arguments</tt>:

<div class="example">

<pre class="example">_arguments '-l+:left border:' \ 
           '-format:paper size:(letter A4)' \ 
           '*-copy:output file:_files::resolution:(300 600)' \ 
           ':postscript file:_files -g \*.\(ps\|eps\)' \ 
           '*:page number:'
</pre>

</div>

This describes three options: ‘<tt>-l</tt>’, ‘<tt>-format</tt>’, and ‘<tt>-copy</tt>’. The first takes one argument described as ‘<var>left border</var>’ for which no completion will be offered because of the empty action. Its argument may come directly after the ‘<tt>-l</tt>’ or it may be given as the next word on the line.

The ‘<tt>-format</tt>’ option takes one argument in the next word, described as ‘<var>paper size</var>’ for which only the strings ‘<tt>letter</tt>’ and ‘<tt>A4</tt>’ will be completed.

The ‘<tt>-copy</tt>’ option may appear more than once on the command line and takes two arguments. The first is mandatory and will be completed as a filename. The second is optional (because of the second colon before the description ‘<var>resolution</var>’) and will be completed from the strings ‘<tt>300</tt>’ and ‘<tt>600</tt>’.

The last two descriptions say what should be completed as arguments. The first describes the first argument as a ‘<var>postscript file</var>’ and makes files ending in ‘<tt>ps</tt>’ or ‘<tt>eps</tt>’ be completed. The last description gives all other arguments the description ‘<var>page numbers</var>’ but does not offer completions.

<a name="index-_005fcache_005finvalid"></a></dd>

<dt><tt>_cache_invalid</tt> <var>cache_identifier</var></dt>

<dd>

This function returns status zero if the completions cache corresponding to the given cache identifier needs rebuilding. It determines this by looking up the <tt>cache-policy</tt> style for the current context. This should provide a function name which is run with the full path to the relevant cache file as the only argument.

Example:

<div class="example">

<pre class="example">_example_caching_policy () {
    # rebuild if cache is more than a week old
    local -a oldp
    oldp=( "$1"(Nm+7) )
    (( $#oldp ))
}
</pre>

</div>

<a name="index-_005fcall_005ffunction"></a></dd>

<dt><tt>_call_function</tt> <var>return</var> <var>name</var> [ <var>arg</var> ... ]</dt>

<dd>

If a function <var>name</var> exists, it is called with the arguments <var>arg</var>s. The <var>return</var> argument gives the name of a parameter in which the return status from the function <var>name</var> should be stored; if <var>return</var> is empty or a single hyphen it is ignored.

The return status of <tt>_call_function</tt> itself is zero if the function <var>name</var> exists and was called and non-zero otherwise.

<a name="index-_005fcall_005fprogram"></a></dd>

<dt><tt>_call_program</tt> <var>tag</var> <var>string</var> ...</dt>

<dd>

This function provides a mechanism for the user to override the use of an external command. It looks up the <tt>command</tt> style with the supplied <var>tag</var>. If the style is set, its value is used as the command to execute. The <var>string</var>s from the call to <tt>_call_program</tt>, or from the style if set, are concatenated with spaces between them and the resulting string is evaluated. The return status is the return status of the command called.

<a name="index-_005fcombination"></a></dd>

<dt><tt>_combination</tt> [ <tt>-s</tt> <var>pattern</var> ] <var>tag</var> <var>style</var> <var>spec</var> ... <var>field</var> <var>opts</var> ...</dt>

<dd>

This function is used to complete combinations of values, for example pairs of hostnames and usernames. The <var>style</var> argument gives the style which defines the pairs; it is looked up in a context with the <var>tag</var> specified.

The style name consists of field names separated by hyphens, for example ‘<tt>users-hosts-ports</tt>’. For each field for a value is already known, a <var>spec</var> of the form ‘<var>field</var><tt>=</tt><var>pattern</var>’ is given. For example, if the command line so far specifies a user ‘<tt>pws</tt>’, the argument ‘<tt>users=pws</tt>’ should appear.

The next argument with no equals sign is taken as the name of the field for which completions should be generated (presumably not one of the <var>field</var>s for which the value is known).

The matches generated will be taken from the value of the style. These should contain the possible values for the combinations in the appropriate order (users, hosts, ports in the example above). The different fields the values for the different fields are separated by colons. This can be altered with the option <tt>-s</tt> to <tt>_combination</tt> which specifies a pattern. Typically this is a character class, as for example ‘<tt>-s "\[:@]"</tt>’ in the case of the <tt>users-hosts</tt> style. Each ‘<var>field</var><tt>=</tt><var>pattern</var>’ specification restricts the completions which apply to elements of the style with appropriately matching fields.

If no style with the given name is defined for the given tag, or if none of the strings in style’s value match, but a function name of the required field preceded by an underscore is defined, that function will be called to generate the matches. For example, if there is no ‘<tt>users-hosts-ports</tt>’ or no matching hostname when a host is required, the function ‘<tt>_hosts</tt>’ will automatically be called.

If the same name is used for more than one field, in both the ‘<var>field</var><tt>=</tt><var>pattern</var>’ and the argument that gives the name of the field to be completed, the number of the field (starting with one) may be given after the fieldname, separated from it by a colon.

All arguments after the required field name are passed to <tt>compadd</tt> when generating matches from the style value, or to the functions for the fields if they are called.

<a name="index-_005fcommand_005fnames"></a></dd>

<dt><tt>_command_names</tt> [ <tt>-e</tt> | <tt>\-</tt> ]</dt>

<dd>

This function completes words that are valid at command position: names of aliases, builtins, hashed commands, functions, and so on. With the <tt>-e</tt> flag, only hashed commands are completed. The <tt>\-</tt> flag is ignored.

<a name="index-_005fdescribe"></a></dd>

<dt><tt>_describe</tt> \[<tt>-12JVx</tt>] [ <tt>-oO</tt> | <tt>-t</tt> <var>tag</var> ] <var>descr</var> <var>name1</var> [ <var>name2</var> ] [ <var>opt</var> ... ]</dt>

<dt>[ <tt>\-</tt><tt>\-</tt> <var>name1</var> [ <var>name2</var> ] [ <var>opt</var> ... ] ... ]</dt>

<dd>

This function associates completions with descriptions. Multiple groups separated by <tt>\-</tt><tt>\-</tt> can be supplied, potentially with different completion options <var>opt</var>s.

The <var>descr</var> is taken as a string to display above the matches if the <tt>format</tt> style for the <tt>descriptions</tt> tag is set. This is followed by one or two names of arrays followed by options to pass to <tt>compadd</tt>. The array <var>name1</var> contains the possible completions with their descriptions in the form ‘<var>completion</var><tt>:</tt><var>description</var>’. Any literal colons in <var>completion</var> must be quoted with a backslash. If a <var>name2</var> is given, it should have the same number of elements as <var>name1</var>; in this case the corresponding elements are added as possible completions instead of the <var>completion</var> strings from <var>name1</var>. The completion list will retain the descriptions from <var>name1</var>. Finally, a set of completion options can appear.

If the option ‘<tt>-o</tt>’ appears before the first argument, the matches added will be treated as names of command options (N.B. not shell options), typically following a ‘<tt>\-</tt>’, ‘<tt>\-</tt><tt>\-</tt>’ or ‘<tt>\+</tt>’ on the command line. In this case <tt>_describe</tt> uses the <tt>prefix-hidden</tt>, <tt>prefix-needed</tt> and <tt>verbose</tt> styles to find out if the strings should be added as completions and if the descriptions should be shown. Without the ‘<tt>-o</tt>’ option, only the <tt>verbose</tt> style is used to decide how descriptions are shown. If ‘<tt>-O</tt>’ is used instead of ‘<tt>-o</tt>’, command options are completed as above but <tt>_describe</tt> will not handle the <tt>prefix-needed</tt> style.

With the <tt>-t</tt> option a <var>tag</var> can be specified. The default is ‘<tt>values</tt>’ or, if the <tt>-o</tt> option is given, ‘<tt>options</tt>’.

The options <tt>-1</tt>, <tt>-2</tt>, <tt>-J</tt>, <tt>-V</tt>, <tt>-x</tt> are passed to <tt>_next_label</tt>.

If selected by the <tt>list-grouped</tt> style, strings with the same description will appear together in the list.

<tt>_describe</tt> uses the <tt>_all_labels</tt> function to generate the matches, so it does not need to appear inside a loop over tag labels.

<a name="index-_005fdescription"></a></dd>

<dt><tt>_description</tt> [ <tt>-x</tt> ] [ <tt>-12VJ</tt> ] <var>tag</var> <var>name</var> <var>descr</var> [ <var>spec</var> ... ]</dt>

<dd>

This function is not to be confused with the previous one; it is used as a helper function for creating options to <tt>compadd</tt>. It is buried inside many of the higher level completion functions and so often does not need to be called directly.

The styles listed below are tested in the current context using the given <var>tag</var>. The resulting options for <tt>compadd</tt> are put into the array named <var>name</var> (this is traditionally ‘<tt>expl</tt>’, but this convention is not enforced). The description for the corresponding set of matches is passed to the function in <var>descr</var>.

The styles tested are: <tt>format</tt>, <tt>hidden</tt>, <tt>matcher</tt>, <tt>ignored-patterns</tt> and <tt>group-name</tt>. The <tt>format</tt> style is first tested for the given <var>tag</var> and then for the <tt>descriptions</tt> tag if no value was found, while the remainder are only tested for the tag given as the first argument. The function also calls <tt>_setup</tt> which tests some more styles.

The string returned by the <tt>format</tt> style (if any) will be modified so that the sequence ‘<tt>%d</tt>’ is replaced by the <var>descr</var> given as the third argument without any leading or trailing white space. If, after removing the white space, the <var>descr</var> is the empty string, the format style will not be used and the options put into the <var>name</var> array will not contain an explanation string to be displayed above the matches.

If <tt>_description</tt> is called with more than three arguments, the additional <var>spec</var>s should be of the form ‘<var>char</var><tt>:</tt><var>str</var>’. These supply escape sequence replacements for the <tt>format</tt> style: every appearance of ‘<tt>%</tt><var>char</var>’ will be replaced by <var>string</var>.

If the <tt>-x</tt> option is given, the description will be passed to <tt>compadd</tt> using the <tt>-x</tt> option instead of the default <tt>-X</tt>. This means that the description will be displayed even if there are no corresponding matches.

The options placed in the array <var>name</var> take account of the <tt>group-name</tt> style, so matches are placed in a separate group where necessary. The group normally has its elements sorted (by passing the option <tt>-J</tt> to <tt>compadd</tt>), but if an option starting with ‘<tt>-V</tt>’, ‘<tt>-J</tt>’, ‘<tt>-1</tt>’, or ‘<tt>-2</tt>’ is passed to <tt>_description</tt>, that option will be included in the array. Hence it is possible for the completion group to be unsorted by giving the option ‘<tt>-V</tt>’, ‘<tt>-1V</tt>’, or ‘<tt>-2V</tt>’.

In most cases, the function will be used like this:

<div class="example">

<pre class="example">local expl
_description files expl file
compadd "$expl[@]" - "$files[@]"
</pre>

</div>

Note the use of the parameter <tt>expl</tt>, the hyphen, and the list of matches. Almost all calls to <tt>compadd</tt> within the completion system use a similar format; this ensures that user-specified styles are correctly passed down to the builtins which implement the internals of completion.

<a name="index-_005fdispatch"></a></dd>

<dt><tt>_dispatch</tt> <var>context string</var> ...</dt>

<dd>

This sets the current context to <var>context</var> and looks for completion functions to handle this context by hunting through the list of command names or special contexts (as described above for <tt>compdef</tt>) given as <var>string</var>s. The first completion function to be defined for one of the contexts in the list is used to generate matches. Typically, the last <var>string</var> is <tt>-default-</tt> to cause the function for default completion to be used as a fallback.

The function sets the parameter <tt>$service</tt> to the <var>string</var> being tried, and sets the <var>context/command</var> field (the fourth) of the <tt>$curcontext</tt> parameter to the <var>context</var> given as the first argument.

<a name="index-_005ffiles"></a></dd>

<dt><tt>_files</tt></dt>

<dd>

The function <tt>_files</tt> calls <tt>_path_files</tt> with all the arguments it was passed except for <tt>-g</tt> and <tt>-/</tt>. The use of these two options depends on the setting of the <tt>file-patterns</tt> style.

This function accepts the full set of options allowed by <tt>_path_files</tt>, described below.

<a name="index-_005fgnu_005fgeneric"></a></dd>

<dt><tt>_gnu_generic</tt></dt>

<dd>

This function is a simple wrapper around the <tt>_arguments</tt> function described above. It can be used to determine automatically the long options understood by commands that produce a list when passed the option ‘<tt>\-</tt><tt>-help</tt>’. It is intended to be used as a top-level completion function in its own right. For example, to enable option completion for the commands <tt>foo</tt> and <tt>bar</tt>, use

<div class="example">

<pre class="example">compdef _gnu_generic foo bar
</pre>

</div>

after the call to <tt>compinit</tt>.

The completion system as supplied is conservative in its use of this function, since it is important to be sure the command understands the option ‘<tt>\-</tt><tt>-help</tt>’.

<a name="index-_005fguard"></a></dd>

<dt><tt>_guard</tt> [ <var>options</var> ] <var>pattern descr</var></dt>

<dd>

This function displays <var>descr</var> if <var>pattern</var> matches the string to be completed. It is intended to be used in the <var>action</var> for the specifications passed to <tt>_arguments</tt> and similar functions.

The return status is zero if the message was displayed and the word to complete is not empty, and non-zero otherwise.

The <var>pattern</var> may be preceded by any of the options understood by <tt>compadd</tt> that are passed down from <tt>_description</tt>, namely <tt>-M</tt>, <tt>-J</tt>, <tt>-V</tt>, <tt>-1</tt>, <tt>-2</tt>, <tt>-n</tt>, <tt>-F</tt> and <tt>-X</tt>. All of these options will be ignored. This fits in conveniently with the argument-passing conventions of actions for <tt>_arguments</tt>.

As an example, consider a command taking the options <tt>-n</tt> and <tt>-none</tt>, where <tt>-n</tt> must be followed by a numeric value in the same word. By using:

<div class="example">

<pre class="example">_arguments '-n-: :_guard "[0-9]#" "numeric value"' '-none'
</pre>

</div>

<tt>_arguments</tt> can be made to both display the message ‘<tt>numeric value</tt>’ and complete options after ‘<tt>-n<TAB></tt>’. If the ‘<tt>-n</tt>’ is already followed by one or more digits (the pattern passed to <tt>_guard</tt>) only the message will be displayed; if the ‘<tt>-n</tt>’ is followed by another character, only options are completed.

<a name="index-_005fmessage"></a></dd>

<dt><tt>_message</tt> [ <tt>-r12</tt> ] [ <tt>-VJ</tt> <var>group</var> ] <var>descr</var></dt>

<dt><tt>_message -e</tt> [ <var>tag</var> ] <var>descr</var></dt>

<dd>

The <var>descr</var> is used in the same way as the third argument to the <tt>_description</tt> function, except that the resulting string will always be shown whether or not matches were generated. This is useful for displaying a help message in places where no completions can be generated.

The <tt>format</tt> style is examined with the <tt>messages</tt> tag to find a message; the usual tag, <tt>descriptions</tt>, is used only if the style is not set with the former.

If the <tt>-r</tt> option is given, no style is used; the <var>descr</var> is taken literally as the string to display. This is most useful when the <var>descr</var> comes from a pre-processed argument list which already contains an expanded description.

The <tt>-12VJ</tt> options and the <var>group</var> are passed to <tt>compadd</tt> and hence determine the group the message string is added to.

The second <tt>-e</tt> form gives a description for completions with the tag <var>tag</var> to be shown even if there are no matches for that tag. This form is called by <tt>_arguments</tt> in the event that there is no action for an option specification. The tag can be omitted and if so the tag is taken from the parameter <tt>$curtag</tt>; this is maintained by the completion system and so is usually correct. Note that if there are no matches at the time this function is called, <tt>compstate[insert]</tt> is cleared, so additional matches generated later are not inserted on the command line.

<a name="index-_005fmulti_005fparts"></a></dd>

<dt><tt>_multi_parts</tt> [ <tt>-i</tt> ] <var>sep</var> <var>array</var></dt>

<dd>

The argument <var>sep</var> is a separator character. The <var>array</var> may be either the name of an array parameter or a literal array in the form ‘<tt>(foo bar</tt><tt>\)</tt>’, a parenthesised list of words separated by whitespace. The possible completions are the strings from the array. However, each chunk delimited by <var>sep</var> will be completed separately. For example, the <tt>_tar</tt> function uses ‘<tt>_multi_parts</tt> <tt>/</tt> <var>patharray</var>’ to complete partial file paths from the given array of complete file paths.

The <tt>-i</tt> option causes <tt>_multi_parts</tt> to insert a unique match even if that requires multiple separators to be inserted. This is not usually the expected behaviour with filenames, but certain other types of completion, for example those with a fixed set of possibilities, may be more suited to this form.

Like other utility functions, this function accepts the ‘<tt>-V</tt>’, ‘<tt>-J</tt>’, ‘<tt>-1</tt>’, ‘<tt>-2</tt>’, ‘<tt>-n</tt>’, ‘<tt>-f</tt>’, ‘<tt>-X</tt>’, ‘<tt>-M</tt>’, ‘<tt>-P</tt>’, ‘<tt>-S</tt>’, ‘<tt>-r</tt>’, ‘<tt>-R</tt>’, and ‘<tt>-q</tt>’ options and passes them to the <tt>compadd</tt> builtin.

<a name="index-_005fnext_005flabel"></a></dd>

<dt><tt>_next_label</tt> [ <tt>-x</tt> ] [ <tt>-12VJ</tt> ] <var>tag</var> <var>name</var> <var>descr</var> [ <var>option</var> ... ]</dt>

<dd>

This function is used to implement the loop over different tag labels for a particular tag as described above for the <tt>tag-order</tt> style. On each call it checks to see if there are any more tag labels; if there is it returns status zero, otherwise non-zero. As this function requires a current tag to be set, it must always follow a call to <tt>_tags</tt> or <tt>_requested</tt>.

The <tt>-x12VJ</tt> options and the first three arguments are passed to the <tt>_description</tt> function. Where appropriate the <var>tag</var> will be replaced by a tag label in this call. Any description given in the <tt>tag-order</tt> style is preferred to the <var>descr</var> passed to <tt>_next_label</tt>.

The <var>option</var>s given after the <var>descr</var> are set in the parameter given by <var>name</var>, and hence are to be passed to <tt>compadd</tt> or whatever function is called to add the matches.

Here is a typical use of this function for the tag <tt>foo</tt>. The call to <tt>_requested</tt> determines if tag <tt>foo</tt> is required at all; the loop over <tt>_next_label</tt> handles any labels defined for the tag in the <tt>tag-order</tt> style.

<div class="example">

<pre class="example">local expl ret=1
...
if _requested foo; then
  ...
  while _next_label foo expl '...'; do
    compadd "$expl[@]" ... && ret=0
  done
  ...
fi
return ret
</pre>

</div>

<a name="index-_005fnormal"></a></dd>

<dt><tt>_normal</tt></dt>

<dd>

This is the standard function called to handle completion outside any special <tt>\-</tt><var>context</var><tt>\-</tt>. It is called both to complete the command word and also the arguments for a command. In the second case, <tt>_normal</tt> looks for a special completion for that command, and if there is none it uses the completion for the <tt>-default-</tt> context.

A second use is to reexamine the command line specified by the <tt>$words</tt> array and the <tt>$CURRENT</tt> parameter after those have been modified. For example, the function <tt>_precommand</tt>, which completes after pre-command specifiers such as <tt>nohup</tt>, removes the first word from the <tt>words</tt> array, decrements the <tt>CURRENT</tt> parameter, then calls <tt>_normal</tt> again. The effect is that ‘<tt>nohup</tt> <var>cmd ...</var>’ is treated in the same way as ‘<var>cmd ...</var>’.

If the command name matches one of the patterns given by one of the options <tt>-p</tt> or <tt>-P</tt> to <tt>compdef</tt>, the corresponding completion function is called and then the parameter <tt>_compskip</tt> is checked. If it is set completion is terminated at that point even if no matches have been found. This is the same effect as in the <tt>-first-</tt> context.

<a name="index-_005foptions"></a></dd>

<dt><tt>_options</tt></dt>

<dd>

This can be used to complete the names of shell options. It provides a matcher specification that ignores a leading ‘<tt>no</tt>’, ignores underscores and allows upper-case letters to match their lower-case counterparts (for example, ‘<tt>glob</tt>’, ‘<tt>noglob</tt>’, ‘<tt>NO_GLOB</tt>’ are all completed). Any arguments are propagated to the <tt>compadd</tt> builtin.

<a name="index-_005foptions_005fset"></a><a name="index-_005foptions_005funset"></a></dd>

<dt><tt>_options_set</tt> and <tt>_options_unset</tt></dt>

<dd>

These functions complete only set or unset options, with the same matching specification used in the <tt>_options</tt> function.

Note that you need to uncomment a few lines in the <tt>_main_complete</tt> function for these functions to work properly. The lines in question are used to store the option settings in effect before the completion widget locally sets the options it needs. Hence these functions are not generally used by the completion system.

<a name="index-_005fparameters"></a></dd>

<dt><tt>_parameters</tt></dt>

<dd>

This is used to complete the names of shell parameters.

The option ‘<tt>-g</tt> <var>pattern</var>’ limits the completion to parameters whose type matches the <var>pattern</var>. The type of a parameter is that shown by ‘<tt>print ${(t)</tt><var>param</var><tt>\}</tt>’, hence judicious use of ‘<tt>\*</tt>’ in <var>pattern</var> is probably necessary.

All other arguments are passed to the <tt>compadd</tt> builtin.

<a name="index-_005fpath_005ffiles"></a></dd>

<dt><tt>_path_files</tt></dt>

<dd>

This function is used throughout the completion system to complete filenames. It allows completion of partial paths. For example, the string ‘<tt>/u/i/s/sig</tt>’ may be completed to ‘<tt>/usr/include/sys/signal.h</tt>’.

The options accepted by both <tt>_path_files</tt> and <tt>_files</tt> are:

<dl compact="compact">

<dt><tt>-f</tt></dt>

<dd>

Complete all filenames. This is the default.

</dd>

<dt><tt>-/</tt></dt>

<dd>

Specifies that only directories should be completed.

</dd>

<dt><tt>-g</tt> <var>pattern</var></dt>

<dd>

Specifies that only files matching the <var>pattern</var> should be completed.

</dd>

<dt><tt>-W</tt> <var>paths</var></dt>

<dd>

Specifies path prefixes that are to be prepended to the string from the command line to generate the filenames but that should not be inserted as completions nor shown in completion listings. Here, <var>paths</var> may be the name of an array parameter, a literal list of paths enclosed in parentheses or an absolute pathname.

</dd>

<dt><tt>-F</tt> <var>ignored-files</var></dt>

<dd>

This behaves as for the corresponding option to the <tt>compadd</tt> builtin. It gives direct control over which filenames should be ignored. If the option is not present, the <tt>ignored-patterns</tt> style is used.

</dd>

</dl>

Both <tt>_path_files</tt> and <tt>_files</tt> also accept the following options which are passed to <tt>compadd</tt>: ‘<tt>-J</tt>’, ‘<tt>-V</tt>’, ‘<tt>-1</tt>’, ‘<tt>-2</tt>’, ‘<tt>-n</tt>’, ‘<tt>-X</tt>’, ‘<tt>-M</tt>’, ‘<tt>-P</tt>’, ‘<tt>-S</tt>’, ‘<tt>-q</tt>’, ‘<tt>-r</tt>’, and ‘<tt>-R</tt>’.

Finally, the <tt>_path_files</tt> function uses the styles <tt>expand</tt>, <tt>ambiguous</tt>, <tt>special-dirs</tt>, <tt>list-suffixes</tt> and <tt>file-sort</tt> described above.

<a name="index-_005fpick_005fvariant"></a></dd>

<dt><tt>_pick_variant</tt> [ <tt>-b</tt> <var>builtin-label</var> ] [ <tt>-c</tt> <var>command</var> ] [ <tt>-r</tt> <var>name</var> ]</dt>

<dt><var>label</var><tt>=</tt><var>pattern</var> ... <var>label</var> [ <var>arg</var> ... ]</dt>

<dd>

This function is used to resolve situations where a single command name requires more than one type of handling, either because it has more than one variant or because there is a name clash between two different commands.

The command to run is taken from the first element of the array <tt>words</tt> unless this is overridden by the option <tt>-c</tt>. This command is run and its output is compared with a series of patterns. Arguments to be passed to the command can be specified at the end after all the other arguments. The patterns to try in order are given by the arguments <var>label</var><tt>=</tt><var>pattern</var>; if the output of ‘<var>command</var> <var>arg</var> ...’ contains <var>pattern</var>, then <var>label</var> is selected as the label for the command variant. If none of the patterns match, the final command label is selected and status 1 is returned.

If the ‘<tt>-b</tt> <var>builtin-label</var>’ is given, the command is tested to see if it is provided as a shell builtin, possibly autoloaded; if so, the label <var>builtin-label</var> is selected as the label for the variant.

If the ‘<tt>-r</tt> <var>name</var>’ is given, the <var>label</var> picked is stored in the parameter named <var>name</var>.

The results are also cached in the <tt>_cmd_variant</tt> associative array indexed by the name of the command run.

<a name="index-_005fregex_005farguments"></a></dd>

<dt><tt>_regex_arguments</tt> <var>name</var> <var>spec</var> ...</dt>

<dd>

This function generates a completion function <var>name</var> which matches the specifications <var>spec</var>s, a set of regular expressions as described below. After running <tt>_regex_arguments</tt>, the function <var>name</var> should be called as a normal completion function. The pattern to be matched is given by the contents of the <tt>words</tt> array up to the current cursor position joined together with null characters; no quotation is applied.

The arguments are grouped as sets of alternatives separated by ‘<tt>|</tt>’, which are tried one after the other until one matches. Each alternative consists of a one or more specifications which are tried left to right, with each pattern matched being stripped in turn from the command line being tested, until all of the group succeeds or until one fails; in the latter case, the next alternative is tried. This structure can be repeated to arbitrary depth by using parentheses; matching proceeds from inside to outside.

A special procedure is applied if no test succeeds but the remaining command line string contains no null character (implying the remaining word is the one for which completions are to be generated). The completion target is restricted to the remaining word and any <var>action</var>s for the corresponding patterns are executed. In this case, nothing is stripped from the command line string. The order of evaluation of the <var>action</var>s can be determined by the <tt>tag-order</tt> style; the various formats supported by <tt>_alternative</tt> can be used in <var>action</var>. The <var>descr</var> is used for setting up the array parameter <tt>expl</tt>.

Specification arguments take one of following forms, in which metacharacters such as ‘<tt>\(</tt>’, ‘<tt>\)</tt>’, ‘<tt>\#</tt>’ and ‘<tt>|</tt>’ should be quoted.

<dl compact="compact">

<dt><tt>/</tt><var>pattern</var><tt>/</tt> [<tt>%</tt><var>lookahead</var><tt>%</tt>] [<tt>-</tt><var>guard</var>] [<tt>:</tt><var>tag</var><tt>:</tt><var>descr</var><tt>:</tt><var>action</var>]</dt>

<dd>

This is a single primitive component. The function tests whether the combined pattern ‘<tt>(#b)((#B)</tt><var>pattern</var><tt>)</tt><var>lookahead</var><tt>*</tt>’ matches the command line string. If so, ‘<var>guard</var>’ is evaluated and its return status is examined to determine if the test has succeeded. The <var>pattern</var> string ‘<tt>[]</tt>’ is guaranteed never to match. The <var>lookahead</var> is not stripped from the command line before the next pattern is examined.

The argument starting with <tt>:</tt> is used in the same manner as an argument to <tt>_alternative</tt>.

A component is used as follows: <var>pattern</var> is tested to see if the component already exists on the command line. If it does, any following specifications are examined to find something to complete. If a component is reached but no such pattern exists yet on the command line, the string containing the <var>action</var> is used to generate matches to insert at that point.

</dd>

<dt><tt>/</tt><var>pattern</var><tt>/+</tt> [<tt>%</tt><var>lookahead</var><tt>%</tt>] [<tt>-</tt><var>guard</var>] [<tt>:</tt><var>tag</var><tt>:</tt><var>descr</var><tt>:</tt><var>action</var>]</dt>

<dd>

This is similar to ‘<tt>/</tt><var>pattern</var><tt>/</tt> ...’ but the left part of the command line string (i.e. the part already matched by previous patterns) is also considered part of the completion target.

</dd>

<dt><tt>/</tt><var>pattern</var><tt>/-</tt> [<tt>%</tt><var>lookahead</var><tt>%</tt>] [<tt>-</tt><var>guard</var>] [<tt>:</tt><var>tag</var><tt>:</tt><var>descr</var><tt>:</tt><var>action</var>]</dt>

<dd>

This is similar to ‘<tt>/</tt><var>pattern</var><tt>/</tt> ...’ but the <var>action</var>s of the current and previously matched patterns are ignored even if the following ‘<var>pattern</var>’ matches the empty string.

</dd>

<dt><tt>(</tt> <var>spec</var> <tt>)</tt></dt>

<dd>

Parentheses may be used to groups <var>spec</var>s; note each parenthesis is a single argument to <tt>_regex_arguments</tt>.

</dd>

<dt><var>spec</var> <tt>#</tt></dt>

<dd>

This allows any number of repetitions of <var>spec</var>.

</dd>

<dt><var>spec</var> <var>spec</var></dt>

<dd>

The two <var>spec</var>s are to be matched one after the other as described above.

</dd>

<dt><var>spec</var> <tt>|</tt> <var>spec</var></dt>

<dd>

Either of the two <var>spec</var>s can be matched.

</dd>

</dl>

The function <tt>_regex_words</tt> can be used as a helper function to generate matches for a set of alternative words possibly with their own arguments as a command line argument.

Examples:

<div class="example">

<pre class="example">_regex_arguments _tst //pre>[^\0]#\0'/ \ 
    //pre>[^\0]#\0'/ :'compadd aaa'
</pre>

</div>

This generates a function <tt>_tst</tt> that completes <tt>aaa</tt> as its only argument. The <var>tag</var> and <var>description</var> for the action have been omitted for brevity (this works but is not recommended in normal use). The first component matches the command word, which is arbitrary; the second matches any argument. As the argument is also arbitrary, any following component would not depend on <tt>aaa</tt> being present.

<div class="example">

<pre class="example">_regex_arguments _tst //pre>[^\0]#\0'/ \ 
    //pre>aaa\0'/ :'compadd aaa'
</pre>

</div>

This is a more typical use; it is similar, but any following patterns would only match if <tt>aaa</tt> was present as the first argument.

<div class="example">

<pre class="example">_regex_arguments _tst //pre>[^\0]#\0'/ \( \ 
    //pre>aaa\0'/ :'compadd aaa' \ 
    //pre>bbb\0'/ :'compadd bbb' \) \#
</pre>

</div>

In this example, an indefinite number of command arguments may be completed. Odd arguments are completed as <tt>aaa</tt> and even arguments as <tt>bbb</tt>. Completion fails unless the set of <tt>aaa</tt> and <tt>bbb</tt> arguments before the current one is matched correctly.

<div class="example">

<pre class="example">_regex_arguments _tst //pre>[^\0]#\0'/ \ 
    \( //pre>aaa\0'/ :'compadd aaa' \| \ 
    //pre>bbb\0'/ :'compadd bbb' \) \#
</pre>

</div>

This is similar, but either <tt>aaa</tt> or <tt>bbb</tt> may be completed for any argument. In this case <tt>_regex_words</tt> could be used to generate a suitable expression for the arguments.

<a name="index-_005fregex_005fwords-_005b-_002dt-term-_005d"></a></dd>

<dt><tt>_regex_words</tt> <var>tag</var> <var>description</var> <var>spec</var> ...</dt>

<dd>

This function can be used to generate arguments for the <tt>_regex_arguments</tt> command which may be inserted at any point where a set of rules is expected. The <var>tag</var> and <var>description</var> give a standard tag and description pertaining to the current context. Each <var>spec</var> contains two or three arguments separated by a colon: note that there is no leading colon in this case.

Each <var>spec</var> gives one of a set of words that may be completed at this point, together with arguments. It is thus roughly equivalent to the <tt>_arguments</tt> function when used in normal (non-regex) completion.

The part of the <var>spec</var> before the first colon is the word to be completed. This may contain a <tt>*</tt>; the entire word, before and after the <tt>*</tt> is completed, but only the text before the <tt>\*</tt> is required for the context to be matched, so that further arguments may be completed after the abbreviated form.

The second part of <var>spec</var> is a description for the word being completed.

The optional third part of the <var>spec</var> describes how words following the one being completed are themselves to be completed. It will be evaluated in order to avoid problems with quoting. This means that typically it contains a reference to an array containing previously generated regex arguments.

The option <tt>-t</tt> <var>term</var> specifies a terminator for the word instead of the usual space. This is handled as an auto-removable suffix in the manner of the option <tt>-s</tt> <var>sep</var> to <tt>_values</tt>.

The result of the processing by <tt>_regex_words</tt> is placed in the array <tt>reply</tt>, which should be made local to the calling function. If the set of words and arguments may be matched repeatedly, a <tt>\#</tt> should be appended to the generated array at that point.

For example:

<div class="example">

<pre class="example">local -a reply
_regex_words mydb-commands 'mydb commands' \ 
  'add:add an entry to mydb:$mydb_add_cmds' \ 
  'show:show entries in mydb'
_regex_arguments _mydb "$reply[@]"
_mydb "$@"
</pre>

</div>

This shows a completion function for a command <tt>mydb</tt> which takes two command arguments, <tt>add</tt> and <tt>show</tt>. <tt>show</tt> takes no arguments, while the arguments for <tt>add</tt> have already been prepared in an array <tt>mydb_add_cmds</tt>, quite possibly by a previous call to <tt>_regex_words</tt>.

<a name="index-_005frequested"></a></dd>

<dt><tt>_requested</tt> [ <tt>-x</tt> ] [ <tt>-12VJ</tt> ] <var>tag</var> [ <var>name</var> <var>descr</var> [ <var>command</var> [ <var>arg</var> ... ] ]</dt>

<dd>

This function is called to decide whether a tag already registered by a call to <tt>_tags</tt> (see below) has been requested by the user and hence completion should be performed for it. It returns status zero if the tag is requested and non-zero otherwise. The function is typically used as part of a loop over different tags as follows:

<div class="example">

<pre class="example">_tags foo bar baz
while _tags; do
  if _requested foo; then
    ... # perform completion for foo
  fi
  ... # test the tags bar and baz in the same way
  ... # exit loop if matches were generated
done
</pre>

</div>

Note that the test for whether matches were generated is not performed until the end of the <tt>_tags</tt> loop. This is so that the user can set the <tt>tag-order</tt> style to specify a set of tags to be completed at the same time.

If <var>name</var> and <var>descr</var> are given, <tt>_requested</tt> calls the <tt>_description</tt> function with these arguments together with the options passed to <tt>_requested</tt>.

If <var>command</var> is given, the <tt>_all_labels</tt> function will be called immediately with the same arguments. In simple cases this makes it possible to perform the test for the tag and the matching in one go. For example:

<div class="example">

<pre class="example">local expl ret=1
_tags foo bar baz
while _tags; do
  _requested foo expl 'description' \ 
      compadd foobar foobaz && ret=0
  ...
  (( ret )) || break
done
</pre>

</div>

If the <var>command</var> is not <tt>compadd</tt>, it must nevertheless be prepared to handle the same options.

<a name="index-_005fretrieve_005fcache"></a></dd>

<dt><tt>_retrieve_cache</tt> <var>cache_identifier</var></dt>

<dd>

This function retrieves completion information from the file given by <var>cache_identifier</var>, stored in a directory specified by the <tt>cache-path</tt> style which defaults to <tt>~/.zcompcache</tt>. The return status is zero if retrieval was successful. It will only attempt retrieval if the <tt>use-cache</tt> style is set, so you can call this function without worrying about whether the user wanted to use the caching layer.

See <tt>_store_cache</tt> below for more details.

<a name="index-_005fsep_005fparts"></a></dd>

<dt><tt>_sep_parts</tt></dt>

<dd>

This function is passed alternating arrays and separators as arguments. The arrays specify completions for parts of strings to be separated by the separators. The arrays may be the names of array parameters or a quoted list of words in parentheses. For example, with the array ‘<tt>hosts=(ftp news)</tt>’ the call ‘<tt>_sep_parts ’(foo bar)’ @ hosts</tt>’ will complete the string ‘<tt>f</tt>’ to ‘<tt>foo</tt>’ and the string ‘<tt>b@n</tt>’ to ‘<tt>bar@news</tt>’.

This function accepts the <tt>compadd</tt> options ‘<tt>-V</tt>’, ‘<tt>-J</tt>’, ‘<tt>-1</tt>’, ‘<tt>-2</tt>’, ‘<tt>-n</tt>’, ‘<tt>-X</tt>’, ‘<tt>-M</tt>’, ‘<tt>-P</tt>’, ‘<tt>-S</tt>’, ‘<tt>-r</tt>’, ‘<tt>-R</tt>’, and ‘<tt>-q</tt>’ and passes them on to the <tt>compadd</tt> builtin used to add the matches.

<a name="index-_005fsequence"></a></dd>

<dt><tt>_sequence</tt> [ <tt>-s</tt> <var>sep</var> ] [ <tt>-n</tt> <var>max</var> ] [ <tt>-d</tt> ] <var>function</var> [ <tt>\-</tt> ] ...</dt>

<dd>

This function is a wrapper to other functions for completing items in a separated list. The same function is used to complete each item in the list. The separator is specified with the <tt>-s</tt> option. If <tt>-s</tt> is omitted it will use ‘<tt>,</tt>’. Duplicate values are not matched unless <tt>-d</tt> is specified. If there is a fixed or maximum number of items in the list, this can be specified with the <tt>-n</tt> option.

Common <tt>compadd</tt> options are passed on to the function. It is possible to use <tt>compadd</tt> directly with <tt>_sequence</tt>, though <tt>_values</tt> may be more appropriate in this situation.

<a name="index-_005fsetup"></a></dd>

<dt><tt>_setup</tt> <var>tag</var> [ <var>group</var> ]</dt>

<dd>

This function sets up the special parameters used by the completion system appropriately for the <var>tag</var> given as the first argument. It uses the styles <tt>list-colors</tt>, <tt>list-packed</tt>, <tt>list-rows-first</tt>, <tt>last-prompt</tt>, <tt>accept-exact</tt>, <tt>menu</tt> and <tt>force-list</tt>.

The optional <var>group</var> supplies the name of the group in which the matches will be placed. If it is not given, the <var>tag</var> is used as the group name.

This function is called automatically from <tt>_description</tt> and hence is not normally called explicitly.

<a name="index-_005fstore_005fcache"></a></dd>

<dt><tt>_store_cache</tt> <var>cache_identifier</var> <var>param</var> ...</dt>

<dd>

This function, together with <tt>_retrieve_cache</tt> and <tt>_cache_invalid</tt>, implements a caching layer which can be used in any completion function. Data obtained by costly operations are stored in parameters; this function then dumps the values of those parameters to a file. The data can then be retrieved quickly from that file via <tt>_retrieve_cache</tt>, even in different instances of the shell.

The <var>cache_identifier</var> specifies the file which the data should be dumped to. The file is stored in a directory specified by the <tt>cache-path</tt> style which defaults to <tt>~/.zcompcache</tt>. The remaining <var>param</var>s arguments are the parameters to dump to the file.

The return status is zero if storage was successful. The function will only attempt storage if the <tt>use-cache</tt> style is set, so you can call this function without worrying about whether the user wanted to use the caching layer.

The completion function may avoid calling <tt>_retrieve_cache</tt> when it already has the completion data available as parameters. However, in that case it should call <tt>_cache_invalid</tt> to check whether the data in the parameters and in the cache are still valid.

See the _perl_modules completion function for a simple example of the usage of the caching layer.

<a name="index-_005ftags"></a></dd>

<dt><tt>_tags</tt> [ [ <tt>-C</tt> <var>name</var> ] <var>tag</var> ... ]</dt>

<dd>

If called with arguments, these are taken to be the names of tags valid for completions in the current context. These tags are stored internally and sorted by using the <tt>tag-order</tt> style.

Next, <tt>_tags</tt> is called repeatedly without arguments from the same completion function. This successively selects the first, second, etc. set of tags requested by the user. The return status is zero if at least one of the tags is requested and non-zero otherwise. To test if a particular tag is to be tried, the <tt>_requested</tt> function should be called (see above).

If ‘<tt>-C</tt> <var>name</var>’ is given, <var>name</var> is temporarily stored in the argument field (the fifth) of the context in the <tt>curcontext</tt> parameter during the call to <tt>_tags</tt>; the field is restored on exit. This allows <tt>_tags</tt> to use a more specific context without having to change and reset the <tt>curcontext</tt> parameter (which has the same effect).

<a name="index-_005fvalues"></a></dd>

<dt><tt>_values</tt> [ <tt>-O</tt> <var>name</var> ] [ <tt>-s</tt> <var>sep</var> ] [ <tt>-S</tt> <var>sep</var> ] [ <tt>-wC</tt> ] <var>desc</var> <var>spec</var> ...</dt>

<dd>

This is used to complete arbitrary keywords (values) and their arguments, or lists of such combinations.

If the first argument is the option ‘<tt>-O</tt> <var>name</var>’, it will be used in the same way as by the <tt>_arguments</tt> function. In other words, the elements of the <var>name</var> array will be passed to <tt>compadd</tt> when executing an action.

If the first argument (or the first argument after ‘<tt>-O</tt> <var>name</var>’) is ‘<tt>-s</tt>’, the next argument is used as the character that separates multiple values. This character is automatically added after each value in an auto-removable fashion (see below); all values completed by ‘<tt>_values -s</tt>’ appear in the same word on the command line, unlike completion using <tt>_arguments</tt>. If this option is not present, only a single value will be completed per word.

Normally, <tt>_values</tt> will only use the current word to determine which values are already present on the command line and hence are not to be completed again. If the <tt>-w</tt> option is given, other arguments are examined as well.

The first non-option argument is used as a string to print as a description before listing the values.

All other arguments describe the possible values and their arguments in the same format used for the description of options by the <tt>_arguments</tt> function (see above). The only differences are that no minus or plus sign is required at the beginning, values can have only one argument, and the forms of action beginning with an equal sign are not supported.

The character separating a value from its argument can be set using the option <tt>-S</tt> (like <tt>-s</tt>, followed by the character to use as the separator in the next argument). By default the equals sign will be used as the separator between values and arguments.

Example:

<div class="example">

<pre class="example">_values -s , 'description' \ 
        '*foo[bar]' \ 
        '(two)*one[number]:first count:' \ 
        'two[another number]::second count:(1 2 3)'
</pre>

</div>

This describes three possible values: ‘<tt>foo</tt>’, ‘<tt>one</tt>’, and ‘<tt>two</tt>’. The first is described as ‘<tt>bar</tt>’, takes no argument and may appear more than once. The second is described as ‘<tt>number</tt>’, may appear more than once, and takes one mandatory argument described as ‘<tt>first count</tt>’; no action is specified, so it will not be completed. The ‘<tt>(two)</tt>’ at the beginning says that if the value ‘<tt>one</tt>’ is on the line, the value ‘<tt>two</tt>’ will no longer be considered a possible completion. Finally, the last value (‘<tt>two</tt>’) is described as ‘<tt>another number</tt>’ and takes an optional argument described as ‘<tt>second count</tt>’ for which the completions (to appear after an ‘<tt>=</tt>’) are ‘<tt>1</tt>’, ‘<tt>2</tt>’, and ‘<tt>3</tt>’. The <tt>_values</tt> function will complete lists of these values separated by commas.

Like <tt>_arguments</tt>, this function temporarily adds another context name component to the arguments element (the fifth) of the current context while executing the <var>action</var>. Here this name is just the name of the value for which the argument is completed.

The style <tt>verbose</tt> is used to decide if the descriptions for the values (but not those for the arguments) should be printed.

The associative array <tt>val_args</tt> is used to report values and their arguments; this works similarly to the <tt>opt_args</tt> associative array used by <tt>_arguments</tt>. Hence the function calling <tt>_values</tt> should declare the local parameters <tt>state</tt>, <tt>state_descr</tt>, <tt>line</tt>, <tt>context</tt> and <tt>val_args</tt>:

<div class="example">

<pre class="example">local context state state_descr line
typeset -A val_args
</pre>

</div>

when using an action of the form ‘<tt>-></tt><var>string</var>’. With this function the <tt>context</tt> parameter will be set to the name of the value whose argument is to be completed. Note that for <tt>_values</tt>, the <tt>state</tt> and <tt>state_descr</tt> are scalars rather than arrays. Only a single matching state is returned.

Note also that <tt>_values</tt> normally adds the character used as the separator between values as an auto-removable suffix (similar to a ‘<tt>/</tt>’ after a directory). However, this is not possible for a ‘<tt>-></tt><var>string</var>’ action as the matches for the argument are generated by the calling function. To get the usual behaviour, the calling function can add the separator <var>x</var> as a suffix by passing the options ‘<tt>-qS</tt> <var>x</var>’ either directly or indirectly to <tt>compadd</tt>.

The option <tt>-C</tt> is treated in the same way as it is by <tt>_arguments</tt>. In that case the parameter <tt>curcontext</tt> should be made local instead of <tt>context</tt> (as described above).

<a name="index-_005fwanted"></a></dd>

<dt><tt>_wanted</tt> [ <tt>-x</tt> ] [ <tt>-C</tt> <var>name</var> ] [ <tt>-12VJ</tt> ] <var>tag</var> <var>name</var> <var>descr</var> <var>command</var> [ <var>arg</var> ...]</dt>

<dd>

In many contexts, completion can only generate one particular set of matches, usually corresponding to a single tag. However, it is still necessary to decide whether the user requires matches of this type. This function is useful in such a case.

The arguments to <tt>_wanted</tt> are the same as those to <tt>_requested</tt>, i.e. arguments to be passed to <tt>_description</tt>. However, in this case the <var>command</var> is not optional; all the processing of tags, including the loop over both tags and tag labels and the generation of matches, is carried out automatically by <tt>_wanted</tt>.

Hence to offer only one tag and immediately add the corresponding matches with the given description:

<div class="example">

<pre class="example">local expl
_wanted tag expl 'description' \ 
    compadd matches...
</pre>

</div>

Note that, as for <tt>_requested</tt>, the <var>command</var> must be able to accept options to be passed down to <tt>compadd</tt>.

Like <tt>_tags</tt> this function supports the <tt>-C</tt> option to give a different name for the argument context field. The <tt>-x</tt> option has the same meaning as for <tt>_description</tt>.

</dd>

</dl>

---

<a name="Completion-Directories"></a>

| [ [\<\<](#Completion-System) ] | [ [\<](#Completion-Functions) ] | [ [Up](#Completion-System) ] | [ [\>](Completion-Using-compctl.html#Completion-Using-compctl) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Completion-Directories-1"></a>

20.7 Completion Directories
---------------------------

<a name="index-completion-system_002c-directory-structure"></a>

In the source distribution, the files are contained in various subdirectories of the <tt>Completion</tt> directory. They may have been installed in the same structure, or into one single function directory. The following is a description of the files found in the original directory structure. If you wish to alter an installed file, you will need to copy it to some directory which appears earlier in your <tt>fpath</tt> than the standard directory where it appears.

<dl compact="compact">

<dt><tt>Base</tt></dt>

<dd>

The core functions and special completion widgets automatically bound to keys. You will certainly need most of these, though will probably not need to alter them. Many of these are documented above.

</dd>

<dt><tt>Zsh</tt></dt>

<dd>

Functions for completing arguments of shell builtin commands and utility functions for this. Some of these are also used by functions from the <tt>Unix</tt> directory.

</dd>

<dt><tt>Unix</tt></dt>

<dd>

Functions for completing arguments of external commands and suites of commands. They may need modifying for your system, although in many cases some attempt is made to decide which version of a command is present. For example, completion for the <tt>mount</tt> command tries to determine the system it is running on, while completion for many other utilities try to decide whether the GNU version of the command is in use, and hence whether the <tt>-</tt><tt>-help</tt> option is supported.

</dd>

<dt><tt>X</tt>, <tt>AIX</tt>, <tt>BSD</tt>, ...</dt>

<dd>

Completion and utility function for commands available only on some systems. These are not arranged hierarchically, so, for example, both the <tt>Linux</tt> and <tt>Debian</tt> directories, as well as the <tt>X</tt> directory, may be useful on your system.

</dd>

</dl>

---

| [ [\<\<](#Completion-System) ] | [ [>>](Completion-Using-compctl.html#Completion-Using-compctl) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<font size="-1">This document was generated on *July 30, 2016* using [*texi2html 5.0*](http://www.nongnu.org/texi2html/).</font>
