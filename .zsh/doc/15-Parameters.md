<a name="Parameters"></a>

| [ [\<\<](Expansion.html#Expansion) ] | [ [\<](Expansion.html#Glob-Qualifiers) ] | [ [Up](index.html#Top) ] | [ [\>](#Description-3) ] | [ [>>](Options.html#Options) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Parameters-2"></a>

15 Parameters
=============

<a name="index-parameters"></a><a name="index-variables"></a>

---

<a name="Description-3"></a>

| [ [\<\<](#Parameters) ] | [ [\<](#Parameters) ] | [ [Up](#Parameters) ] | [ [\>](#Array-Parameters) ] | [ [>>](Options.html#Options) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

15.1 Description
----------------

A parameter has a name, a value, and a number of attributes. A name may be any sequence of alphanumeric characters and underscores, or the single characters ‘<tt>\*</tt>’, ‘<tt>@</tt>’, ‘<tt>\#</tt>’, ‘<tt>?</tt>’, ‘<tt>\-</tt>’, ‘<tt>$</tt>’, or ‘<tt>!</tt>’. A parameter whose name begins with an alphanumeric or underscore is also referred to as a *variable*.

<a name="index-scalar"></a><a name="index-parameters_002c-scalar"></a><a name="index-parameters_002c-array"></a><a name="index-parameters_002c-associative-array"></a><a name="index-hash"></a>

The attributes of a parameter determine the *type* of its value, often referred to as the parameter type or variable type, and also control other processing that may be applied to the value when it is referenced. The value type may be a *scalar* (a string, an integer, or a floating point number), an array (indexed numerically), or an *associative* array (an unordered set of name-value pairs, indexed by name, also referred to as a *hash*).

<a name="index-export"></a><a name="index-environment"></a><a name="index-environment-variables"></a><a name="index-variables_002c-environment"></a>

Named scalar parameters may have the *exported*, <tt>-x</tt>, attribute, to copy them into the process environment, which is then passed from the shell to any new processes that it starts. Exported parameters are called *environment variables*. The shell also *imports* environment variables at startup time and automatically marks the corresponding parameters as exported. Some environment variables are not imported for reasons of security or because they would interfere with the correct operation of other shell features.

<a name="index-special-parameters"></a><a name="index-parameters_002c-special"></a>

Parameters may also be *special*, that is, they have a predetermined meaning to the shell. Special parameters cannot have their type changed or their readonly attribute turned off, and if a special parameter is unset, then later recreated, the special properties will be retained.

To declare the type of a parameter, or to assign a string or numeric value to a scalar parameter, use the <tt>typeset</tt> builtin.<a name="index-typeset_002c-use-of"></a>

The value of a scalar parameter may also be assigned by writing:<a name="index-assignment"></a>

> <var>name</var><tt>=</tt><var>value</var>

In scalar assignment, <var>value</var> is expanded as a single string, in which the elements of arrays are joined together; filename expansion is not performed unless the option <tt>GLOB_ASSIGN</tt> is set.

When the integer attribute, <tt>-i</tt>, or a floating point attribute, <tt>-E</tt> or <tt>-F</tt>, is set for <var>name</var>, the <var>value</var> is subject to arithmetic evaluation. Furthermore, by replacing ‘<tt>=</tt>’ with ‘<tt>+=</tt>’, a parameter can be incremented or appended to. See [Array Parameters](#Array-Parameters) and [Arithmetic Evaluation](Arithmetic-Evaluation.html#Arithmetic-Evaluation) for additional forms of assignment.

Note that assignment may implicitly change the attributes of a parameter. For example, assigning a number to a variable in arithmetic evaluation may change its type to integer or float, and with <tt>GLOB_ASSIGN</tt> assigning a pattern to a variable may change its type to an array.

To reference the value of a parameter, write ‘<tt>$</tt><var>name</var>’ or ‘<tt>${</tt><var>name</var><tt>\}</tt>’. See [Parameter Expansion](Expansion.html#Parameter-Expansion) for complete details. That section also explains the effect of the difference between scalar and array assignment on parameter expansion.

| [15.2 Array Parameters](#Array-Parameters) | | [15.3 Positional Parameters](#Positional-Parameters) | | [15.4 Local Parameters](#Local-Parameters) | | [15.5 Parameters Set By The Shell](#Parameters-Set-By-The-Shell) | | [15.6 Parameters Used By The Shell](#Parameters-Used-By-The-Shell) |

---

<a name="Array-Parameters"></a>

| [ [\<\<](#Parameters) ] | [ [\<](#Description-3) ] | [ [Up](#Parameters) ] | [ [\>](#Array-Subscripts) ] | [ [>>](Options.html#Options) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Array-Parameters-1"></a>

15.2 Array Parameters
---------------------

To assign an array value, write one of:<a name="index-set_002c-use-of"></a><a name="index-array-assignment"></a>

> <tt>set -A</tt> <var>name</var> <var>value</var> ...
>
> <var>name</var><tt>=(</tt><var>value</var> ...<tt>\)</tt>

If no parameter <var>name</var> exists, an ordinary array parameter is created. If the parameter <var>name</var> exists and is a scalar, it is replaced by a new array. To append to an array without changing the existing values, use the syntax:

> <var>name</var><tt>+=(</tt><var>value</var> ...<tt>\)</tt>

Within the parentheses on the right hand side of either form of the assignment, newlines and semicolons are treated the same as white space, separating individual <var>value</var>s. Any consecutive sequence of such characters has the same effect.

Ordinary array parameters may also be explicitly declared with:<a name="index-typeset_002c-use-of-1"></a>

> <tt>typeset -a</tt> <var>name</var>

Associative arrays *must* be declared before assignment, by using:

> <tt>typeset -A</tt> <var>name</var>

When <var>name</var> refers to an associative array, the list in an assignment is interpreted as alternating keys and values:

> <tt>set -A</tt> <var>name</var> <var>key</var> <var>value</var> ...
>
> <var>name</var><tt>=(</tt><var>key</var> <var>value</var> ...<tt>\)</tt>

Every <var>key</var> must have a <var>value</var> in this case. Note that this assigns to the entire array, deleting any elements that do not appear in the list. The append syntax may also be used with an associative array:

> <var>name</var><tt>+=(</tt><var>key</var> <var>value</var> ...<tt>\)</tt>

This adds a new key/value pair if the key is not already present, and replaces the value for the existing key if it is.

To create an empty array (including associative arrays), use one of:

> <tt>set -A</tt> <var>name</var>
>
> <var>name</var><tt>=()</tt>

---

<a name="Array-Subscripts"></a>

| [ [\<\<](#Parameters) ] | [ [\<](#Array-Parameters) ] | [ [Up](#Array-Parameters) ] | [ [\>](#Array-Element-Assignment) ] | [ [>>](Options.html#Options) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

### 15.2.1 Array Subscripts

<a name="index-subscripts"></a>

Individual elements of an array may be selected using a subscript. A subscript of the form ‘<tt>\[</tt><var>exp</var><tt>\]</tt>’ selects the single element <var>exp</var>, where <var>exp</var> is an arithmetic expression which will be subject to arithmetic expansion as if it were surrounded by ‘<tt>$((</tt>...<tt>))</tt>’. The elements are numbered beginning with 1, unless the <tt>KSH_ARRAYS</tt> option is set in which case they are numbered from zero.<a name="index-KSH_005fARRAYS_002c-use-of"></a>

Subscripts may be used inside braces used to delimit a parameter name, thus ‘<tt>${foo[2]}</tt>’ is equivalent to ‘<tt>$foo[2]</tt>’. If the <tt>KSH_ARRAYS</tt> option is set, the braced form is the only one that works, as bracketed expressions otherwise are not treated as subscripts.

If the <tt>KSH_ARRAYS</tt> option is not set, then by default accesses to an array element with a subscript that evaluates to zero return an empty string, while an attempt to write such an element is treated as an error. For backward compatibility the <tt>KSH_ZERO_SUBSCRIPT</tt> option can be set to cause subscript values 0 and 1 to be equivalent; see the description of the option in [Description of Options](Options.html#Description-of-Options).

The same subscripting syntax is used for associative arrays, except that no arithmetic expansion is applied to <var>exp</var>. However, the parsing rules for arithmetic expressions still apply, which affects the way that certain special characters must be protected from interpretation. See *Subscript Parsing* below for details.

A subscript of the form ‘<tt>\[*\]</tt>’ or ‘<tt>[@]</tt>’ evaluates to all elements of an array; there is no difference between the two except when they appear within double quotes. ‘<tt>"$foo\[*]"</tt>’ evaluates to ‘<tt>"$foo[1] $foo[2]</tt> ...<tt>"</tt>’, whereas ‘<tt>"$foo[@]"</tt>’ evaluates to ‘<tt>"$foo[1]" "$foo[2]"</tt> ...’. For associative arrays, ‘<tt>\[*\]</tt>’ or ‘<tt>[@]</tt>’ evaluate to all the values, in no particular order. Note that this does not substitute the keys; see the documentation for the ‘<tt>k</tt>’ flag under [Parameter Expansion](Expansion.html#Parameter-Expansion) for complete details. When an array parameter is referenced as ‘<tt>$</tt><var>name</var>’ (with no subscript) it evaluates to ‘<tt>$</tt><var>name</var><tt>\[*\]</tt>’, unless the <tt>KSH_ARRAYS</tt> option is set in which case it evaluates to ‘<tt>${</tt><var>name</var><tt>[0]}</tt>’ (for an associative array, this means the value of the key ‘<tt>0</tt>’, which may not exist even if there are values for other keys).

A subscript of the form ‘<tt>\[</tt><var>exp1</var><tt>,</tt><var>exp2</var><tt>\]</tt>’ selects all elements in the range <var>exp1</var> to <var>exp2</var>, inclusive. (Associative arrays are unordered, and so do not support ranges.) If one of the subscripts evaluates to a negative number, say <tt>\-</tt><var>n</var>, then the <var>n</var>th element from the end of the array is used. Thus ‘<tt>$foo[-3]</tt>’ is the third element from the end of the array <tt>foo</tt>, and ‘<tt>$foo[1,-1]</tt>’ is the same as ‘<tt>$foo\[*]</tt>’.

Subscripting may also be performed on non-array values, in which case the subscripts specify a substring to be extracted. For example, if <tt>FOO</tt> is set to ‘<tt>foobar</tt>’, then ‘<tt>echo $FOO[2,5]</tt>’ prints ‘<tt>ooba</tt>’. Note that some forms of subscripting described below perform pattern matching, and in that case the substring extends from the start of the match of the first subscript to the end of the match of the second subscript. For example,

<div class="example">

<pre class="example">string="abcdefghijklm"
print ${string[(r)d?,(r)h?]}
</pre>

</div>

prints ‘<tt>defghi</tt>’. This is an obvious generalisation of the rule for single-character matches. For a single subscript, only a single character is referenced (not the range of characters covered by the match).

Note that in substring operations the second subscript is handled differently by the <tt>r</tt> and <tt>R</tt> subscript flags: the former takes the shortest match as the length and the latter the longest match. Hence in the former case a <tt>\*</tt> at the end is redundant while in the latter case it matches the whole remainder of the string. This does not affect the result of the single subscript case as here the length of the match is irrelevant.

---

<a name="Array-Element-Assignment"></a>

| [ [\<\<](#Parameters) ] | [ [\<](#Array-Subscripts) ] | [ [Up](#Array-Parameters) ] | [ [\>](#Subscript-Flags) ] | [ [>>](Options.html#Options) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

### 15.2.2 Array Element Assignment

A subscript may be used on the left side of an assignment like so:

> <var>name</var><tt>\[</tt><var>exp</var><tt>]=</tt><var>value</var>

In this form of assignment the element or range specified by <var>exp</var> is replaced by the expression on the right side. An array (but not an associative array) may be created by assignment to a range or element. Arrays do not nest, so assigning a parenthesized list of values to an element or range changes the number of elements in the array, shifting the other elements to accommodate the new values. (This is not supported for associative arrays.)

This syntax also works as an argument to the <tt>typeset</tt> command:

> <tt>typeset</tt> <tt>"</tt><var>name</var><tt>\[</tt><var>exp</var><tt>]"=</tt><var>value</var>

The <var>value</var> may *not* be a parenthesized list in this case; only single-element assignments may be made with <tt>typeset</tt>. Note that quotes are necessary in this case to prevent the brackets from being interpreted as filename generation operators. The <tt>noglob</tt> precommand modifier could be used instead.

To delete an element of an ordinary array, assign ‘<tt>()</tt>’ to that element. To delete an element of an associative array, use the <tt>unset</tt> command:

> <tt>unset</tt> <tt>"</tt><var>name</var><tt>\[</tt><var>exp</var><tt>]"</tt>

---

<a name="Subscript-Flags"></a>

| [ [\<\<](#Parameters) ] | [ [\<](#Array-Element-Assignment) ] | [ [Up](#Array-Parameters) ] | [ [\>](#Subscript-Parsing) ] | [ [>>](Options.html#Options) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

### 15.2.3 Subscript Flags

<a name="index-subscript-flags"></a>

If the opening bracket, or the comma in a range, in any subscript expression is directly followed by an opening parenthesis, the string up to the matching closing one is considered to be a list of flags, as in ‘<var>name</var><tt>[(</tt><var>flags</var><tt>\)</tt><var>exp</var><tt>\]</tt>’.

The flags <tt>s</tt>, <tt>n</tt> and <tt>b</tt> take an argument; the delimiter is shown below as ‘<tt>:</tt>’, but any character, or the matching pairs ‘<tt>\(</tt>...<tt>\)</tt>’, ‘<tt>\{</tt>...<tt>\}</tt>’, ‘<tt>\[</tt>...<tt>\]</tt>’, or ‘<tt>\<</tt>...<tt>\></tt>’, may be used, but note that ‘<tt>\<</tt>...<tt>\></tt>’ can only be used if the subscript is inside a double quoted expression or a parameter substitution enclosed in braces as otherwise the expression is interpreted as a redirection.

The flags currently understood are:

<dl compact="compact">

<dt><tt>w</tt></dt>

<dd>

If the parameter subscripted is a scalar then this flag makes subscripting work on words instead of characters. The default word separator is whitespace. This flag may not be used with the <tt>i</tt> or <tt>I</tt> flag.

</dd>

<dt><tt>s:</tt><var>string</var><tt>:</tt></dt>

<dd>

This gives the <var>string</var> that separates words (for use with the <tt>w</tt> flag). The delimiter character <tt>:</tt> is arbitrary; see above.

</dd>

<dt><tt>p</tt></dt>

<dd>

Recognize the same escape sequences as the <tt>print</tt> builtin in the string argument of a subsequent ‘<tt>s</tt>’ flag.

</dd>

<dt><tt>f</tt></dt>

<dd>

If the parameter subscripted is a scalar then this flag makes subscripting work on lines instead of characters, i.e. with elements separated by newlines. This is a shorthand for ‘<tt>pws:\n:</tt>’.

</dd>

<dt><tt>r</tt></dt>

<dd>

Reverse subscripting: if this flag is given, the <var>exp</var> is taken as a pattern and the result is the first matching array element, substring or word (if the parameter is an array, if it is a scalar, or if it is a scalar and the ‘<tt>w</tt>’ flag is given, respectively). The subscript used is the number of the matching element, so that pairs of subscripts such as ‘<tt>$foo[(r)??,3]</tt>’ and ‘<tt>$foo[(r)??,(r)f*]</tt>’ are possible if the parameter is not an associative array. If the parameter is an associative array, only the value part of each pair is compared to the pattern, and the result is that value.

If a search through an ordinary array failed, the search sets the subscript to one past the end of the array, and hence <tt>${array[(r)</tt><var>pattern</var><tt>]}</tt> will substitute the empty string. Thus the success of a search can be tested by using the <tt>(i)</tt> flag, for example (assuming the option <tt>KSH_ARRAYS</tt> is not in effect):

<div class="example">

<pre class="example">[[ ${array[(i)pattern]} -le ${#array} ]]
</pre>

</div>

If <tt>KSH_ARRAYS</tt> is in effect, the <tt>-le</tt> should be replaced by <tt>-lt</tt>.

</dd>

<dt><tt>R</tt></dt>

<dd>

Like ‘<tt>r</tt>’, but gives the last match. For associative arrays, gives all possible matches. May be used for assigning to ordinary array elements, but not for assigning to associative arrays. On failure, for normal arrays this has the effect of returning the element corresponding to subscript 0; this is empty unless one of the options <tt>KSH_ARRAYS</tt> or <tt>KSH_ZERO_SUBSCRIPT</tt> is in effect.

Note that in subscripts with both ‘<tt>r</tt>’ and ‘<tt>R</tt>’ pattern characters are active even if they were substituted for a parameter (regardless of the setting of <tt>GLOB_SUBST</tt> which controls this feature in normal pattern matching). The flag ‘<tt>e</tt>’ can be added to inhibit pattern matching. As this flag does not inhibit other forms of substitution, care is still required; using a parameter to hold the key has the desired effect:

<div class="example">

<pre class="example">key2='original key'
print ${array[(Re)$key2]}
</pre>

</div>

</dd>

<dt><tt>i</tt></dt>

<dd>

Like ‘<tt>r</tt>’, but gives the index of the match instead; this may not be combined with a second argument. On the left side of an assignment, behaves like ‘<tt>r</tt>’. For associative arrays, the key part of each pair is compared to the pattern, and the first matching key found is the result. On failure substitutes the length of the array plus one, as discussed under the description of ‘<tt>r</tt>’, or the empty string for an associative array.

</dd>

<dt><tt>I</tt></dt>

<dd>

Like ‘<tt>i</tt>’, but gives the index of the last match, or all possible matching keys in an associative array. On failure substitutes 0, or the empty string for an associative array. This flag is best when testing for values or keys that do not exist.

</dd>

<dt><tt>k</tt></dt>

<dd>

If used in a subscript on an associative array, this flag causes the keys to be interpreted as patterns, and returns the value for the first key found where <var>exp</var> is matched by the key. Note this could be any such key as no ordering of associative arrays is defined. This flag does not work on the left side of an assignment to an associative array element. If used on another type of parameter, this behaves like ‘<tt>r</tt>’.

</dd>

<dt><tt>K</tt></dt>

<dd>

On an associative array this is like ‘<tt>k</tt>’ but returns all values where <var>exp</var> is matched by the keys. On other types of parameters this has the same effect as ‘<tt>R</tt>’.

</dd>

<dt><tt>n:</tt><var>expr</var><tt>:</tt></dt>

<dd>

If combined with ‘<tt>r</tt>’, ‘<tt>R</tt>’, ‘<tt>i</tt>’ or ‘<tt>I</tt>’, makes them give the <var>n</var>th or <var>n</var>th last match (if <var>expr</var> evaluates to <var>n</var>). This flag is ignored when the array is associative. The delimiter character <tt>:</tt> is arbitrary; see above.

</dd>

<dt><tt>b:</tt><var>expr</var><tt>:</tt></dt>

<dd>

If combined with ‘<tt>r</tt>’, ‘<tt>R</tt>’, ‘<tt>i</tt>’ or ‘<tt>I</tt>’, makes them begin at the <var>n</var>th or <var>n</var>th last element, word, or character (if <var>expr</var> evaluates to <var>n</var>). This flag is ignored when the array is associative. The delimiter character <tt>:</tt> is arbitrary; see above.

</dd>

<dt><tt>e</tt></dt>

<dd>

This flag causes any pattern matching that would be performed on the subscript to use plain string matching instead. Hence ‘<tt>${array[(re)*]}</tt>’ matches only the array element whose value is <tt>*</tt>. Note that other forms of substitution such as parameter substitution are not inhibited.

This flag can also be used to force <tt>*</tt> or <tt>@</tt> to be interpreted as a single key rather than as a reference to all values. It may be used for either purpose on the left side of an assignment.

</dd>

</dl>

See *Parameter Expansion Flags* ([Parameter Expansion](Expansion.html#Parameter-Expansion)) for additional ways to manipulate the results of array subscripting.

---

<a name="Subscript-Parsing"></a>

| [ [\<\<](#Parameters) ] | [ [\<](#Subscript-Flags) ] | [ [Up](#Array-Parameters) ] | [ [\>](#Positional-Parameters) ] | [ [>>](Options.html#Options) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

### 15.2.4 Subscript Parsing

This discussion applies mainly to associative array key strings and to patterns used for reverse subscripting (the ‘<tt>r</tt>’, ‘<tt>R</tt>’, ‘<tt>i</tt>’, etc. flags), but it may also affect parameter substitutions that appear as part of an arithmetic expression in an ordinary subscript.

To avoid subscript parsing limitations in assignments to associative array elements, use the append syntax:

<div class="example">

<pre class="example">aa+=('key with "*strange*" characters' 'value string')
</pre>

</div>

The basic rule to remember when writing a subscript expression is that all text between the opening ‘<tt>\[</tt>’ and the closing ‘<tt>\]</tt>’ is interpreted *as if* it were in double quotes ([Quoting](Shell-Grammar.html#Quoting)). However, unlike double quotes which normally cannot nest, subscript expressions may appear inside double-quoted strings or inside other subscript expressions (or both!), so the rules have two important differences.

The first difference is that brackets (‘<tt>\[</tt>’ and ‘<tt>\]</tt>’) must appear as balanced pairs in a subscript expression unless they are preceded by a backslash (‘<tt>\</tt>’). Therefore, within a subscript expression (and unlike true double-quoting) the sequence ‘<tt>\[</tt>’ becomes ‘<tt>\[</tt>’, and similarly ‘<tt>\]</tt>’ becomes ‘<tt>\]</tt>’. This applies even in cases where a backslash is not normally required; for example, the pattern ‘<tt>[^[]</tt>’ (to match any character other than an open bracket) should be written ‘<tt>[^\[\]</tt>’ in a reverse-subscript pattern. However, note that ‘<tt>\[^\[\]</tt>’ and even ‘<tt>\[^[]</tt>’ mean the *same* thing, because backslashes are always stripped when they appear before brackets!

The same rule applies to parentheses (‘<tt>\(</tt>’ and ‘<tt>\)</tt>’) and braces (‘<tt>\{</tt>’ and ‘<tt>\}</tt>’): they must appear either in balanced pairs or preceded by a backslash, and backslashes that protect parentheses or braces are removed during parsing. This is because parameter expansions may be surrounded by balanced braces, and subscript flags are introduced by balanced parentheses.

The second difference is that a double-quote (‘<tt>"</tt>’) may appear as part of a subscript expression without being preceded by a backslash, and therefore that the two characters ‘<tt>\"</tt>’ remain as two characters in the subscript (in true double-quoting, ‘<tt>\"</tt>’ becomes ‘<tt>"</tt>’). However, because of the standard shell quoting rules, any double-quotes that appear must occur in balanced pairs unless preceded by a backslash. This makes it more difficult to write a subscript expression that contains an odd number of double-quote characters, but the reason for this difference is so that when a subscript expression appears inside true double-quotes, one can still write ‘<tt>\"</tt>’ (rather than ‘<tt>\\\"</tt>’) for ‘<tt>"</tt>’.

To use an odd number of double quotes as a key in an assignment, use the <tt>typeset</tt> builtin and an enclosing pair of double quotes; to refer to the value of that key, again use double quotes:

<div class="example">

<pre class="example">typeset -A aa
typeset "aa[one\"two\"three\"quotes]"=QQQ
print "$aa[one\"two\"three\"quotes]"
</pre>

</div>

It is important to note that the quoting rules do not change when a parameter expansion with a subscript is nested inside another subscript expression. That is, it is not necessary to use additional backslashes within the inner subscript expression; they are removed only once, from the innermost subscript outwards. Parameters are also expanded from the innermost subscript first, as each expansion is encountered left to right in the outer expression.

A further complication arises from a way in which subscript parsing is *not* different from double quote parsing. As in true double-quoting, the sequences ‘<tt>\*</tt>’, and ‘<tt>\@</tt>’ remain as two characters when they appear in a subscript expression. To use a literal ‘<tt>\*</tt>’ or ‘<tt>@</tt>’ as an associative array key, the ‘<tt>e</tt>’ flag must be used:

<div class="example">

<pre class="example">typeset -A aa
aa[(e)*]=star
print $aa[(e)*]
</pre>

</div>

A last detail must be considered when reverse subscripting is performed. Parameters appearing in the subscript expression are first expanded and then the complete expression is interpreted as a pattern. This has two effects: first, parameters behave as if <tt>GLOB_SUBST</tt> were on (and it cannot be turned off); second, backslashes are interpreted twice, once when parsing the array subscript and again when parsing the pattern. In a reverse subscript, it’s necessary to use *four* backslashes to cause a single backslash to match literally in the pattern. For complex patterns, it is often easiest to assign the desired pattern to a parameter and then refer to that parameter in the subscript, because then the backslashes, brackets, parentheses, etc., are seen only when the complete expression is converted to a pattern. To match the value of a parameter literally in a reverse subscript, rather than as a pattern, use ‘<tt>${(q</tt><tt>\)</tt><var>name</var><tt>\}</tt>’ ([Parameter Expansion](Expansion.html#Parameter-Expansion)) to quote the expanded value.

Note that the ‘<tt>k</tt>’ and ‘<tt>K</tt>’ flags are reverse subscripting for an ordinary array, but are *not* reverse subscripting for an associative array! (For an associative array, the keys in the array itself are interpreted as patterns by those flags; the subscript is a plain string in that case.)

One final note, not directly related to subscripting: the numeric names of positional parameters ([Positional Parameters](#Positional-Parameters)) are parsed specially, so for example ‘<tt>$2foo</tt>’ is equivalent to ‘<tt>${2}foo</tt>’. Therefore, to use subscript syntax to extract a substring from a positional parameter, the expansion must be surrounded by braces; for example, ‘<tt>${2[3,5]}</tt>’ evaluates to the third through fifth characters of the second positional parameter, but ‘<tt>$2[3,5]</tt>’ is the entire second parameter concatenated with the filename generation pattern ‘<tt>[3,5]</tt>’.

---

<a name="Positional-Parameters"></a>

| [ [\<\<](#Parameters) ] | [ [\<](#Subscript-Parsing) ] | [ [Up](#Parameters) ] | [ [\>](#Local-Parameters) ] | [ [>>](Options.html#Options) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Positional-Parameters-1"></a>

15.3 Positional Parameters
--------------------------

The positional parameters provide access to the command-line arguments of a shell function, shell script, or the shell itself; see [Invocation](Invocation.html#Invocation), and also [Functions](Functions.html#Functions). The parameter <var>n</var>, where <var>n</var> is a number, is the <var>n</var>th positional parameter. The parameter ‘<tt>$0</tt>’ is a special case, see [Parameters Set By The Shell](#Parameters-Set-By-The-Shell).

The parameters <tt>\*</tt>, <tt>@</tt> and <tt>argv</tt> are arrays containing all the positional parameters; thus ‘<tt>$argv\[</tt><var>n</var><tt>\]</tt>’, etc., is equivalent to simply ‘<tt>$</tt><var>n</var>’. Note that the options <tt>KSH_ARRAYS</tt> or <tt>KSH_ZERO_SUBSCRIPT</tt> apply to these arrays as well, so with either of those options set, ‘<tt>${argv[0]}</tt>’ is equivalent to ‘<tt>$1</tt>’ and so on.

Positional parameters may be changed after the shell or function starts by using the <tt>set</tt> builtin, by assigning to the <tt>argv</tt> array, or by direct assignment of the form ‘<var>n</var><tt>=</tt><var>value</var>’ where <var>n</var> is the number of the positional parameter to be changed. This also creates (with empty values) any of the positions from 1 to <var>n</var> that do not already have values. Note that, because the positional parameters form an array, an array assignment of the form ‘<var>n</var><tt>=(</tt><var>value</var> ...<tt>\)</tt>’ is allowed, and has the effect of shifting all the values at positions greater than <var>n</var> by as many positions as necessary to accommodate the new values.

---

<a name="Local-Parameters"></a>

| [ [\<\<](#Parameters) ] | [ [\<](#Positional-Parameters) ] | [ [Up](#Parameters) ] | [ [\>](#Parameters-Set-By-The-Shell) ] | [ [>>](Options.html#Options) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Local-Parameters-1"></a>

15.4 Local Parameters
---------------------

Shell function executions delimit scopes for shell parameters. (Parameters are dynamically scoped.) The <tt>typeset</tt> builtin, and its alternative forms <tt>declare</tt>, <tt>integer</tt>, <tt>local</tt> and <tt>readonly</tt> (but not <tt>export</tt>), can be used to declare a parameter as being local to the innermost scope.

When a parameter is read or assigned to, the innermost existing parameter of that name is used. (That is, the local parameter hides any less-local parameter.) However, assigning to a non-existent parameter, or declaring a new parameter with <tt>export</tt>, causes it to be created in the _outer_most scope.

Local parameters disappear when their scope ends. <tt>unset</tt> can be used to delete a parameter while it is still in scope; any outer parameter of the same name remains hidden.

Special parameters may also be made local; they retain their special attributes unless either the existing or the newly-created parameter has the <tt>-h</tt> (hide) attribute. This may have unexpected effects: there is no default value, so if there is no assignment at the point the variable is made local, it will be set to an empty value (or zero in the case of integers). The following:

<div class="example">

<pre class="example">typeset PATH=/new/directory:$PATH
</pre>

</div>

is valid for temporarily allowing the shell or programmes called from it to find the programs in <tt>/new/directory</tt> inside a function.

Note that the restriction in older versions of zsh that local parameters were never exported has been removed.

---

<a name="Parameters-Set-By-The-Shell"></a>

| [ [\<\<](#Parameters) ] | [ [\<](#Local-Parameters) ] | [ [Up](#Parameters) ] | [ [\>](#Parameters-Used-By-The-Shell) ] | [ [>>](Options.html#Options) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Parameters-Set-By-The-Shell-1"></a>

15.5 Parameters Set By The Shell
--------------------------------

In the parameter lists that follow, the mark ‘<S>’ indicates that the parameter is special. ‘<Z>’ indicates that the parameter does not exist when the shell initializes in <tt>sh</tt> or <tt>ksh</tt> emulation mode.

The following parameters are automatically set by the shell:

<dl compact="compact">

<dd><a name="index-_0021"></a></dd>

<dt><tt>!</tt> <S></dt>

<dd>

The process ID of the last command started in the background with <tt>&</tt>, or put into the background with the <tt>bg</tt> builtin.

<a name="index-_0023"></a></dd>

<dt><tt>#</tt> <S></dt>

<dd>

The number of positional parameters in decimal. Note that some confusion may occur with the syntax <tt>$#</tt><var>param</var> which substitutes the length of <var>param</var>. Use <tt>${#}</tt> to resolve ambiguities. In particular, the sequence ‘<tt>$#-</tt><var>...</var>’ in an arithmetic expression is interpreted as the length of the parameter <tt>-</tt>, q.v.

<a name="index-ARGC"></a></dd>

<dt><tt>ARGC</tt> <S> <Z></dt>

<dd>

Same as <tt>#</tt>.

<a name="index-_0024"></a></dd>

<dt><tt>$</tt> <S></dt>

<dd>

The process ID of this shell. Note that this indicates the original shell started by invoking <tt>zsh</tt>; all processes forked from the shells without executing a new program, such as subshells started by <tt>(</tt><var>...</var><tt>)</tt>, substitute the same value.

<a name="index-_002d-1"></a></dd>

<dt><tt>-</tt> <S></dt>

<dd>

Flags supplied to the shell on invocation or by the <tt>set</tt> or <tt>setopt</tt> commands.

<a name="index-_002a"></a></dd>

<dt><tt>*</tt> <S></dt>

<dd>

An array containing the positional parameters.

<a name="index-argv"></a></dd>

<dt><tt>argv</tt> <S> <Z></dt>

<dd>

Same as <tt>*</tt>. Assigning to <tt>argv</tt> changes the local positional parameters, but <tt>argv</tt> is _not_ itself a local parameter. Deleting <tt>argv</tt> with <tt>unset</tt> in any function deletes it everywhere, although only the innermost positional parameter array is deleted (so <tt>*</tt> and <tt>@</tt> in other scopes are not affected).

<a name="index-_0040"></a></dd>

<dt><tt>@</tt> <S></dt>

<dd>

Same as <tt>argv[@]</tt>, even when <tt>argv</tt> is not set.

<a name="index-_003f"></a></dd>

<dt><tt>?</tt> <S></dt>

<dd>

The exit status returned by the last command.

<a name="index-0"></a></dd>

<dt><tt>0</tt> <S></dt>

<dd>

The name used to invoke the current shell, or as set by the <tt>-c</tt> command line option upon invocation. If the <tt>FUNCTION_ARGZERO</tt> option is set, <tt>$0</tt> is set upon entry to a shell function to the name of the function, and upon entry to a sourced script to the name of the script, and reset to its previous value when the function or script returns.

<a name="index-status"></a></dd>

<dt><tt>status</tt> <S> <Z></dt>

<dd>

Same as <tt>?</tt>.

<a name="index-pipestatus"></a></dd>

<dt><tt>pipestatus</tt> <S> <Z></dt>

<dd>

An array containing the exit statuses returned by all commands in the last pipeline.

<a name="index-_005f"></a></dd>

<dt><tt>_</tt> <S></dt>

<dd>

The last argument of the previous command. Also, this parameter is set in the environment of every command executed to the full pathname of the command.

<a name="index-CPUTYPE"></a></dd>

<dt><tt>CPUTYPE</tt></dt>

<dd>

The machine type (microprocessor class or machine model), as determined at run time.

<a name="index-EGID"></a></dd>

<dt><tt>EGID</tt> <S></dt>

<dd>

The effective group ID of the shell process. If you have sufficient privileges, you may change the effective group ID of the shell process by assigning to this parameter. Also (assuming sufficient privileges), you may start a single command with a different effective group ID by ‘<tt>(EGID=</tt><var>gid</var><tt>; command)</tt>’

If this is made local, it is not implicitly set to 0, but may be explicitly set locally.

<a name="index-EUID"></a></dd>

<dt><tt>EUID</tt> <S></dt>

<dd>

The effective user ID of the shell process. If you have sufficient privileges, you may change the effective user ID of the shell process by assigning to this parameter. Also (assuming sufficient privileges), you may start a single command with a different effective user ID by ‘<tt>(EUID=</tt><var>uid</var><tt>; command)</tt>’

If this is made local, it is not implicitly set to 0, but may be explicitly set locally.

<a name="index-ERRNO"></a></dd>

<dt><tt>ERRNO</tt> <S></dt>

<dd>

The value of errno (see man page errno(3)) as set by the most recently failed system call. This value is system dependent and is intended for debugging purposes. It is also useful with the <tt>zsh/system</tt> module which allows the number to be turned into a name or message.

<a name="index-GID"></a></dd>

<dt><tt>GID</tt> <S></dt>

<dd>

The real group ID of the shell process. If you have sufficient privileges, you may change the group ID of the shell process by assigning to this parameter. Also (assuming sufficient privileges), you may start a single command under a different group ID by ‘<tt>(GID=</tt><var>gid</var><tt>; command)</tt>’

If this is made local, it is not implicitly set to 0, but may be explicitly set locally.

<a name="index-HISTCMD"></a></dd>

<dt><tt>HISTCMD</tt></dt>

<dd>

The current history event number in an interactive shell, in other words the event number for the command that caused <tt>$HISTCMD</tt> to be read. If the current history event modifies the history, <tt>HISTCMD</tt> changes to the new maximum history event number.

<a name="index-HOST"></a></dd>

<dt><tt>HOST</tt></dt>

<dd>

The current hostname.

<a name="index-LINENO"></a></dd>

<dt><tt>LINENO</tt> <S></dt>

<dd>

The line number of the current line within the current script, sourced file, or shell function being executed, whichever was started most recently. Note that in the case of shell functions the line number refers to the function as it appeared in the original definition, not necessarily as displayed by the <tt>functions</tt> builtin.

<a name="index-LOGNAME"></a></dd>

<dt><tt>LOGNAME</tt></dt>

<dd>

If the corresponding variable is not set in the environment of the shell, it is initialized to the login name corresponding to the current login session. This parameter is exported by default but this can be disabled using the <tt>typeset</tt> builtin. The value is set to the string returned by the man page getlogin(3) system call if that is available.

<a name="index-MACHTYPE"></a></dd>

<dt><tt>MACHTYPE</tt></dt>

<dd>

The machine type (microprocessor class or machine model), as determined at compile time.

<a name="index-OLDPWD"></a></dd>

<dt><tt>OLDPWD</tt></dt>

<dd>

The previous working directory. This is set when the shell initializes and whenever the directory changes.

<a name="index-OPTARG"></a></dd>

<dt><tt>OPTARG</tt> <S></dt>

<dd>

The value of the last option argument processed by the <tt>getopts</tt> command.

<a name="index-OPTIND"></a></dd>

<dt><tt>OPTIND</tt> <S></dt>

<dd>

The index of the last option argument processed by the <tt>getopts</tt> command.

<a name="index-OSTYPE"></a></dd>

<dt><tt>OSTYPE</tt></dt>

<dd>

The operating system, as determined at compile time.

<a name="index-PPID"></a></dd>

<dt><tt>PPID</tt> <S></dt>

<dd>

The process ID of the parent of the shell. As for <tt>$</tt>, the value indicates the parent of the original shell and does not change in subshells.

<a name="index-PWD"></a></dd>

<dt><tt>PWD</tt></dt>

<dd>

The present working directory. This is set when the shell initializes and whenever the directory changes.

<a name="index-RANDOM"></a></dd>

<dt><tt>RANDOM</tt> <S></dt>

<dd>

A pseudo-random integer from 0 to 32767, newly generated each time this parameter is referenced. The random number generator can be seeded by assigning a numeric value to <tt>RANDOM</tt>.

The values of <tt>RANDOM</tt> form an intentionally-repeatable pseudo-random sequence; subshells that reference <tt>RANDOM</tt> will result in identical pseudo-random values unless the value of <tt>RANDOM</tt> is referenced or seeded in the parent shell in between subshell invocations.

<a name="index-SECONDS"></a></dd>

<dt><tt>SECONDS</tt> <S></dt>

<dd>

The number of seconds since shell invocation. If this parameter is assigned a value, then the value returned upon reference will be the value that was assigned plus the number of seconds since the assignment.

Unlike other special parameters, the type of the <tt>SECONDS</tt> parameter can be changed using the <tt>typeset</tt> command. Only integer and one of the floating point types are allowed. For example, ‘<tt>typeset -F SECONDS</tt>’ causes the value to be reported as a floating point number. The value is available to microsecond accuracy, although the shell may show more or fewer digits depending on the use of <tt>typeset</tt>. See the documentation for the builtin <tt>typeset</tt> in [Shell Builtin Commands](Shell-Builtin-Commands.html#Shell-Builtin-Commands) for more details.

<a name="index-SHLVL"></a></dd>

<dt><tt>SHLVL</tt> <S></dt>

<dd>

Incremented by one each time a new shell is started.

<a name="index-signals"></a></dd>

<dt><tt>signals</tt></dt>

<dd>

An array containing the names of the signals. Note that with the standard zsh numbering of array indices, where the first element has index 1, the signals are offset by 1 from the signal number used by the operating system. For example, on typical Unix-like systems <tt>HUP</tt> is signal number 1, but is referred to as <tt>$signals[2]</tt>. This is because of <tt>EXIT</tt> at position 1 in the array, which is used internally by zsh but is not known to the operating system.

<a name="index-TRY_005fBLOCK_005fERROR"></a></dd>

<dt><tt>TRY_BLOCK_ERROR</tt> <S></dt>

<dd>

In an <tt>always</tt> block, indicates whether the preceding list of code caused an error. The value is 1 to indicate an error, 0 otherwise. It may be reset, clearing the error condition. See [Complex Commands](Shell-Grammar.html#Complex-Commands)

<a name="index-TRY_005fBLOCK_005fINTERRUPT"></a></dd>

<dt><tt>TRY_BLOCK_INTERRUPT</tt> <S></dt>

<dd>

This variable works in a similar way to <tt>TRY_BLOCK_ERROR</tt>, but represents the status of an interrupt from the signal SIGINT, which typically comes from the keyboard when the user types <tt>^C</tt>. If set to 0, any such interrupt will be reset; otherwise, the interrupt is propagated after the <tt>always</tt> block.

Note that it is possible that an interrupt arrives during the execution of the <tt>always</tt> block; this interrupt is also propagated.

<a name="index-TTY"></a></dd>

<dt><tt>TTY</tt></dt>

<dd>

The name of the tty associated with the shell, if any.

<a name="index-TTYIDLE"></a></dd>

<dt><tt>TTYIDLE</tt> <S></dt>

<dd>

The idle time of the tty associated with the shell in seconds or -1 if there is no such tty.

<a name="index-UID"></a></dd>

<dt><tt>UID</tt> <S></dt>

<dd>

The real user ID of the shell process. If you have sufficient privileges, you may change the user ID of the shell by assigning to this parameter. Also (assuming sufficient privileges), you may start a single command under a different user ID by ‘<tt>(UID=</tt><var>uid</var><tt>; command)</tt>’

If this is made local, it is not implicitly set to 0, but may be explicitly set locally.

<a name="index-USERNAME"></a></dd>

<dt><tt>USERNAME</tt> <S></dt>

<dd>

The username corresponding to the real user ID of the shell process. If you have sufficient privileges, you may change the username (and also the user ID and group ID) of the shell by assigning to this parameter. Also (assuming sufficient privileges), you may start a single command under a different username (and user ID and group ID) by ‘<tt>(USERNAME=</tt><var>username</var><tt>; command)</tt>’

<a name="index-VENDOR"></a></dd>

<dt><tt>VENDOR</tt></dt>

<dd>

The vendor, as determined at compile time.

<a name="index-zsh_005feval_005fcontext"></a><a name="index-ZSH_005fEVAL_005fCONTEXT"></a></dd>

<dt><tt>zsh_eval_context</tt> <S> <Z> (<tt>ZSH_EVAL_CONTEXT</tt> <S>)</dt>

<dd>

An array (colon-separated list) indicating the context of shell code that is being run. Each time a piece of shell code that is stored within the shell is executed a string is temporarily appended to the array to indicate the type of operation that is being performed. Read in order the array gives an indication of the stack of operations being performed with the most immediate context last.

Note that the variable does not give information on syntactic context such as pipelines or subshells. Use <tt>$ZSH_SUBSHELL</tt> to detect subshells.

The context is one of the following:

<dl compact="compact">

<dt><tt>cmdarg</tt></dt>

<dd>

Code specified by the <tt>-c</tt> option to the command line that invoked the shell.

</dd>

<dt><tt>cmdsubst</tt></dt>

<dd>

Command substitution using the <tt>‘</tt><var>...</var><tt>‘</tt> or <tt>$(</tt><var>...</var><tt>)</tt> construct.

</dd>

<dt><tt>equalsubst</tt></dt>

<dd>

File substitution using the <tt>=(</tt><var>...</var><tt>)</tt> construct.

</dd>

<dt><tt>eval</tt></dt>

<dd>

Code executed by the <tt>eval</tt> builtin.

</dd>

<dt><tt>evalautofunc</tt></dt>

<dd>

Code executed with the <tt>KSH_AUTOLOAD</tt> mechanism in order to define an autoloaded function.

</dd>

<dt><tt>fc</tt></dt>

<dd>

Code from the shell history executed by the <tt>-e</tt> option to the <tt>fc</tt> builtin.

</dd>

<dt><tt>file</tt></dt>

<dd>

Lines of code being read directly from a file, for example by the <tt>source</tt> builtin.

</dd>

<dt><tt>filecode</tt></dt>

<dd>

Lines of code being read from a <tt>.zwc</tt> file instead of directly from the source file.

</dd>

<dt><tt>globqual</tt></dt>

<dd>

Code executed by the <tt>e</tt> or <tt>+</tt> glob qualifier.

</dd>

<dt><tt>globsort</tt></dt>

<dd>

Code executed to order files by the <tt>o</tt> glob qualifier.

</dd>

<dt><tt>insubst</tt></dt>

<dd>

File substitution using the <tt><(</tt><var>...</var><tt>)</tt> construct.

</dd>

<dt><tt>loadautofunc</tt></dt>

<dd>

Code read directly from a file to define an autoloaded function.

</dd>

<dt><tt>outsubst</tt></dt>

<dd>

File substitution using the <tt>>(</tt><var>...</var><tt>)</tt> construct.

</dd>

<dt><tt>sched</tt></dt>

<dd>

Code executed by the <tt>sched</tt> builtin.

</dd>

<dt><tt>shfunc</tt></dt>

<dd>

A shell function.

</dd>

<dt><tt>stty</tt></dt>

<dd>

Code passed to <tt>stty</tt> by the <tt>STTY</tt> environment variable. Normally this is passed directly to the system’s <tt>stty</tt> command, so this value is unlikely to be seen in practice.

</dd>

<dt><tt>style</tt></dt>

<dd>

Code executed as part of a style retrieved by the <tt>zstyle</tt> builtin from the <tt>zsh/zutil</tt> module.

</dd>

<dt><tt>toplevel</tt></dt>

<dd>

The highest execution level of a script or interactive shell.

</dd>

<dt><tt>trap</tt></dt>

<dd>

Code executed as a trap defined by the <tt>trap</tt> builtin. Traps defined as functions have the context <tt>shfunc</tt>. As traps are asynchronous they may have a different hierarchy from other code.

</dd>

<dt><tt>zpty</tt></dt>

<dd>

Code executed by the <tt>zpty</tt> builtin from the <tt>zsh/zpty</tt> module.

</dd>

<dt><tt>zregexparse-guard</tt></dt>

<dd>

Code executed as a guard by the <tt>zregexparse</tt> command from the <tt>zsh/zutil</tt> module.

</dd>

<dt><tt>zregexparse-action</tt></dt>

<dd>

Code executed as an action by the <tt>zregexparse</tt> command from the <tt>zsh/zutil</tt> module.

</dd>

</dl>

<a name="index-ZSH_005fARGZERO"></a></dd>

<dt><tt>ZSH_ARGZERO</tt></dt>

<dd>

If zsh was invoked to run a script, this is the name of the script. Otherwise, it is the name used to invoke the current shell. This is the same as the value of <tt>$0</tt> when the <tt>POSIX_ARGZERO</tt> option is set, but is always available.

<a name="index-ZSH_005fEXECUTION_005fSTRING"></a></dd>

<dt><tt>ZSH_EXECUTION_STRING</tt></dt>

<dd>

If the shell was started with the option <tt>-c</tt>, this contains the argument passed to the option. Otherwise it is not set.

<a name="index-ZSH_005fNAME"></a></dd>

<dt><tt>ZSH_NAME</tt></dt>

<dd>

Expands to the basename of the command used to invoke this instance of zsh.

<a name="index-ZSH_005fPATCHLEVEL"></a></dd>

<dt><tt>ZSH_PATCHLEVEL</tt></dt>

<dd>

The revision string for the version number of the ChangeLog file in the zsh distribution. This is most useful in order to keep track of versions of the shell during development between releases; hence most users should not use it and should instead rely on <tt>$ZSH_VERSION</tt>.

</dd>

<dt><tt>zsh_scheduled_events</tt></dt>

<dd>

See [The zsh/sched Module](Zsh-Modules.html#The-zsh_002fsched-Module).

<a name="index-ZSH_005fSCRIPT"></a></dd>

<dt><tt>ZSH_SCRIPT</tt></dt>

<dd>

If zsh was invoked to run a script, this is the name of the script, otherwise it is unset.

<a name="index-ZSH_005fSUBSHELL-_003cS_003e"></a></dd>

<dt><tt>ZSH_SUBSHELL</tt></dt>

<dd>

Readonly integer. Initially zero, incremented each time the shell forks to create a subshell for executing code. Hence ‘<tt>(print $ZSH_SUBSHELL)</tt>’ and ‘<tt>print $(print $ZSH_SUBSHELL)</tt>’ output 1, while ‘<tt>( (print $ZSH_SUBSHELL) )</tt>’ outputs 2.

<a name="index-ZSH_005fVERSION"></a></dd>

<dt><tt>ZSH_VERSION</tt></dt>

<dd>

The version number of the release of zsh.

</dd>

</dl>

---

<a name="Parameters-Used-By-The-Shell"></a>

| [ [\<\<](#Parameters) ] | [ [\<](#Parameters-Set-By-The-Shell) ] | [ [Up](#Parameters) ] | [ [\>](Options.html#Options) ] | [ [>>](Options.html#Options) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<a name="Parameters-Used-By-The-Shell-1"></a>

15.6 Parameters Used By The Shell
---------------------------------

The following parameters are used by the shell. Again, ‘<S>’ indicates that the parameter is special and ‘<Z>’ indicates that the parameter does not exist when the shell initializes in <tt>sh</tt> or <tt>ksh</tt> emulation mode.

In cases where there are two parameters with an upper- and lowercase form of the same name, such as <tt>path</tt> and <tt>PATH</tt>, the lowercase form is an array and the uppercase form is a scalar with the elements of the array joined together by colons. These are similar to tied parameters created via ‘<tt>typeset -T</tt>’. The normal use for the colon-separated form is for exporting to the environment, while the array form is easier to manipulate within the shell. Note that unsetting either of the pair will unset the other; they retain their special properties when recreated, and recreating one of the pair will recreate the other.

<dl compact="compact">

<dd><a name="index-ARGV0"></a></dd>

<dt><tt>ARGV0</tt></dt>

<dd>

If exported, its value is used as the <tt>argv[0]</tt> of external commands. Usually used in constructs like ‘<tt>ARGV0=emacs nethack</tt>’.

<a name="index-editing-over-slow-connection"></a><a name="index-slow-connection_002c-editing-over"></a><a name="index-BAUD"></a></dd>

<dt><tt>BAUD</tt></dt>

<dd>

The rate in bits per second at which data reaches the terminal. The line editor will use this value in order to compensate for a slow terminal by delaying updates to the display until necessary. If the parameter is unset or the value is zero the compensation mechanism is turned off. The parameter is not set by default.

This parameter may be profitably set in some circumstances, e.g. for slow modems dialing into a communications server, or on a slow wide area network. It should be set to the baud rate of the slowest part of the link for best performance.

<a name="index-cdpath"></a><a name="index-CDPATH"></a></dd>

<dt><tt>cdpath</tt> <S> <Z> (<tt>CDPATH</tt> <S>)</dt>

<dd>

An array (colon-separated list) of directories specifying the search path for the <tt>cd</tt> command.

<a name="index-COLUMNS"></a></dd>

<dt><tt>COLUMNS</tt> <S></dt>

<dd>

The number of columns for this terminal session. Used for printing select lists and for the line editor.

<a name="index-CORRECT_005fIGNORE"></a></dd>

<dt><tt>CORRECT_IGNORE</tt></dt>

<dd>

If set, is treated as a pattern during spelling correction. Any potential correction that matches the pattern is ignored. For example, if the value is ‘<tt>_*</tt>’ then completion functions (which, by convention, have names beginning with ‘<tt>_</tt>’) will never be offered as spelling corrections. The pattern does not apply to the correction of file names, as applied by the <tt>CORRECT_ALL</tt> option (so with the example just given files beginning with ‘<tt>_</tt>’ in the current directory would still be completed).

<a name="index-CORRECT_005fIGNORE_005fFILE"></a></dd>

<dt><tt>CORRECT_IGNORE_FILE</tt></dt>

<dd>

If set, is treated as a pattern during spelling correction of file names. Any file name that matches the pattern is never offered as a correction. For example, if the value is ‘<tt>.*</tt>’ then dot file names will never be offered as spelling corrections. This is useful with the <tt>CORRECT_ALL</tt> option.

<a name="index-DIRSTACKSIZE"></a></dd>

<dt><tt>DIRSTACKSIZE</tt></dt>

<dd>

The maximum size of the directory stack, by default there is no limit. If the stack gets larger than this, it will be truncated automatically. This is useful with the <tt>AUTO_PUSHD</tt> option.<a name="index-AUTO_005fPUSHD_002c-use-of"></a>

<a name="index-ENV"></a></dd>

<dt><tt>ENV</tt></dt>

<dd>

If the <tt>ENV</tt> environment variable is set when zsh is invoked as <tt>sh</tt> or <tt>ksh</tt>, <tt>$ENV</tt> is sourced after the profile scripts. The value of <tt>ENV</tt> is subjected to parameter expansion, command substitution, and arithmetic expansion before being interpreted as a pathname. Note that <tt>ENV</tt> is _not_ used unless zsh is emulating <cite>sh</cite> or <cite>ksh</cite>.

<a name="index-FCEDIT"></a></dd>

<dt><tt>FCEDIT</tt></dt>

<dd>

The default editor for the <tt>fc</tt> builtin. If <tt>FCEDIT</tt> is not set, the parameter <tt>EDITOR</tt> is used; if that is not set either, a builtin default, usually <tt>vi</tt>, is used.

<a name="index-fignore"></a><a name="index-FIGNORE"></a></dd>

<dt><tt>fignore</tt> <S> <Z> (<tt>FIGNORE</tt> <S>)</dt>

<dd>

An array (colon separated list) containing the suffixes of files to be ignored during filename completion. However, if completion only generates files with suffixes in this list, then these files are completed anyway.

<a name="index-fpath"></a><a name="index-FPATH"></a></dd>

<dt><tt>fpath</tt> <S> <Z> (<tt>FPATH</tt> <S>)</dt>

<dd>

An array (colon separated list) of directories specifying the search path for function definitions. This path is searched when a function with the <tt>-u</tt> attribute is referenced. If an executable file is found, then it is read and executed in the current environment.

<a name="index-histchars"></a></dd>

<dt><tt>histchars</tt> <S></dt>

<dd>

Three characters used by the shell’s history and lexical analysis mechanism. The first character signals the start of a history expansion (default ‘<tt>!</tt>’). The second character signals the start of a quick history substitution (default ‘<tt>^</tt>’). The third character is the comment character (default ‘<tt>#</tt>’).

The characters must be in the ASCII character set; any attempt to set <tt>histchars</tt> to characters with a locale-dependent meaning will be rejected with an error message.

<a name="index-HISTCHARS"></a></dd>

<dt><tt>HISTCHARS</tt> <S> <Z></dt>

<dd>

Same as <tt>histchars</tt>. (Deprecated.)

<a name="index-HISTFILE"></a></dd>

<dt><tt>HISTFILE</tt></dt>

<dd>

The file to save the history in when an interactive shell exits. If unset, the history is not saved.

<a name="index-HISTORY_005fIGNORE"></a></dd>

<dt><tt>HISTORY_IGNORE</tt></dt>

<dd>

If set, is treated as a pattern at the time history files are written. Any potential history entry that matches the pattern is skipped. For example, if the value is ‘<tt>fc *</tt>’ then commands that invoke the interactive history editor are never written to the history file.

Note that <tt>HISTORY_IGNORE</tt> defines a single pattern: to specify alternatives use the ‘<tt>(</tt><var>first</var><tt>|</tt><var>second</var><tt>|</tt><var>...</var><tt>)</tt>’ syntax.

Compare the <tt>HIST_NO_STORE</tt> option or the <tt>zshaddhistory</tt> hook, either of which would prevent such commands from being added to the interactive history at all. If you wish to use <tt>HISTORY_IGNORE</tt> to stop history being added in the first place, you can define the following hook:

<div class="example">

<pre class="example">zshaddhistory() {
  emulate -L zsh
  ## uncomment if HISTORY_IGNORE
  ## should use EXTENDED_GLOB syntax
  # setopt extendedglob
  [[ $1 != ${~HISTORY_IGNORE} ]]
}
</pre>

</div>

<a name="index-HISTSIZE"></a></dd>

<dt><tt>HISTSIZE</tt> <S></dt>

<dd>

The maximum number of events stored in the internal history list. If you use the <tt>HIST_EXPIRE_DUPS_FIRST</tt> option, setting this value larger than the <tt>SAVEHIST</tt> size will give you the difference as a cushion for saving duplicated history events.

If this is made local, it is not implicitly set to 0, but may be explicitly set locally.

<a name="index-HOME"></a></dd>

<dt><tt>HOME</tt> <S></dt>

<dd>

The default argument for the <tt>cd</tt> command. This is not set automatically by the shell in <tt>sh</tt>, <tt>ksh</tt> or <tt>csh</tt> emulation, but it is typically present in the environment anyway, and if it becomes set it has its usual special behaviour.

<a name="index-IFS"></a></dd>

<dt><tt>IFS</tt> <S></dt>

<dd>

Internal field separators (by default space, tab, newline and NUL), that are used to separate words which result from command or parameter expansion and words read by the <tt>read</tt> builtin. Any characters from the set space, tab and newline that appear in the IFS are called _IFS white space_. One or more IFS white space characters or one non-IFS white space character together with any adjacent IFS white space character delimit a field. If an IFS white space character appears twice consecutively in the IFS, this character is treated as if it were not an IFS white space character.

If the parameter is unset, the default is used. Note this has a different effect from setting the parameter to an empty string.

<a name="index-KEYBOARD_005fHACK"></a></dd>

<dt><tt>KEYBOARD_HACK</tt></dt>

<dd>

This variable defines a character to be removed from the end of the command line before interpreting it (interactive shells only). It is intended to fix the problem with keys placed annoyingly close to return and replaces the <tt>SUNKEYBOARDHACK</tt> option which did this for backquotes only. Should the chosen character be one of singlequote, doublequote or backquote, there must also be an odd number of them on the command line for the last one to be removed.

For backward compatibility, if the <tt>SUNKEYBOARDHACK</tt> option is explicitly set, the value of <tt>KEYBOARD_HACK</tt> reverts to backquote. If the option is explicitly unset, this variable is set to empty.

<a name="index-KEYTIMEOUT"></a></dd>

<dt><tt>KEYTIMEOUT</tt></dt>

<dd>

The time the shell waits, in hundredths of seconds, for another key to be pressed when reading bound multi-character sequences.

<a name="index-LANG"></a></dd>

<dt><tt>LANG</tt> <S></dt>

<dd>

This variable determines the locale category for any category not specifically selected via a variable starting with ‘<tt>LC_</tt>’.

<a name="index-LC_005fALL"></a></dd>

<dt><tt>LC_ALL</tt> <S></dt>

<dd>

This variable overrides the value of the ‘<tt>LANG</tt>’ variable and the value of any of the other variables starting with ‘<tt>LC_</tt>’.

<a name="index-LC_005fCOLLATE"></a></dd>

<dt><tt>LC_COLLATE</tt> <S></dt>

<dd>

This variable determines the locale category for character collation information within ranges in glob brackets and for sorting.

<a name="index-LC_005fCTYPE"></a></dd>

<dt><tt>LC_CTYPE</tt> <S></dt>

<dd>

This variable determines the locale category for character handling functions. If the <tt>MULTIBYTE</tt> option is in effect this variable or <tt>LANG</tt> should contain a value that reflects the character set in use, even if it is a single-byte character set, unless only the 7-bit subset (ASCII) is used. For example, if the character set is ISO-8859-1, a suitable value might be <tt>en_US.iso88591</tt> (certain Linux distributions) or <tt>en_US.ISO8859-1</tt> (MacOS).

<a name="index-LC_005fMESSAGES"></a></dd>

<dt><tt>LC_MESSAGES</tt> <S></dt>

<dd>

This variable determines the language in which messages should be written. Note that zsh does not use message catalogs.

<a name="index-LC_005fNUMERIC"></a></dd>

<dt><tt>LC_NUMERIC</tt> <S></dt>

<dd>

This variable affects the decimal point character and thousands separator character for the formatted input/output functions and string conversion functions. Note that zsh ignores this setting when parsing floating point mathematical expressions.

<a name="index-LC_005fTIME"></a></dd>

<dt><tt>LC_TIME</tt> <S></dt>

<dd>

This variable determines the locale category for date and time formatting in prompt escape sequences.

<a name="index-LINES"></a></dd>

<dt><tt>LINES</tt> <S></dt>

<dd>

The number of lines for this terminal session. Used for printing select lists and for the line editor.

<a name="index-LISTMAX"></a></dd>

<dt><tt>LISTMAX</tt></dt>

<dd>

In the line editor, the number of matches to list without asking first. If the value is negative, the list will be shown if it spans at most as many lines as given by the absolute value. If set to zero, the shell asks only if the top of the listing would scroll off the screen.

<a name="index-LOGCHECK"></a></dd>

<dt><tt>LOGCHECK</tt></dt>

<dd>

The interval in seconds between checks for login/logout activity using the <tt>watch</tt> parameter.

<a name="index-MAIL"></a></dd>

<dt><tt>MAIL</tt></dt>

<dd>

If this parameter is set and <tt>mailpath</tt> is not set, the shell looks for mail in the specified file.

<a name="index-MAILCHECK"></a></dd>

<dt><tt>MAILCHECK</tt></dt>

<dd>

The interval in seconds between checks for new mail.

<a name="index-mailpath"></a><a name="index-MAILPATH"></a></dd>

<dt><tt>mailpath</tt> <S> <Z> (<tt>MAILPATH</tt> <S>)</dt>

<dd>

An array (colon-separated list) of filenames to check for new mail. Each filename can be followed by a ‘<tt>?</tt>’ and a message that will be printed. The message will undergo parameter expansion, command substitution and arithmetic expansion with the variable <tt>$_</tt> defined as the name of the file that has changed. The default message is ‘<tt>You have new mail</tt>’. If an element is a directory instead of a file the shell will recursively check every file in every subdirectory of the element.

<a name="index-manpath"></a><a name="index-MANPATH"></a></dd>

<dt><tt>manpath</tt> <S> <Z> (<tt>MANPATH</tt> <S> <Z>)</dt>

<dd>

An array (colon-separated list) whose value is not used by the shell. The <tt>manpath</tt> array can be useful, however, since setting it also sets <tt>MANPATH</tt>, and vice versa.

</dd>

<dt><tt>match</tt></dt>

<dt><tt>mbegin</tt></dt>

<dt><tt>mend</tt></dt>

<dd>

Arrays set by the shell when the <tt>b</tt> globbing flag is used in pattern matches. See the subsection _Globbing flags_ in [Filename Generation](Expansion.html#Filename-Generation).

</dd>

<dt><tt>MATCH</tt></dt>

<dt><tt>MBEGIN</tt></dt>

<dt><tt>MEND</tt></dt>

<dd>

Set by the shell when the <tt>m</tt> globbing flag is used in pattern matches. See the subsection _Globbing flags_ in [Filename Generation](Expansion.html#Filename-Generation).

<a name="index-module_005fpath"></a><a name="index-MODULE_005fPATH"></a></dd>

<dt><tt>module_path</tt> <S> <Z> (<tt>MODULE_PATH</tt> <S>)</dt>

<dd>

An array (colon-separated list) of directories that <tt>zmodload</tt> searches for dynamically loadable modules. This is initialized to a standard pathname, usually ‘<tt>/usr/local/lib/zsh/$ZSH_VERSION</tt>’. (The ‘<tt>/usr/local/lib</tt>’ part varies from installation to installation.) For security reasons, any value set in the environment when the shell is started will be ignored.

These parameters only exist if the installation supports dynamic module loading.

<a name="index-NULLCMD"></a><a name="index-null-command-style"></a><a name="index-csh_002c-null-command-style"></a><a name="index-ksh_002c-null-command-style"></a></dd>

<dt><tt>NULLCMD</tt> <S></dt>

<dd>

The command name to assume if a redirection is specified with no command. Defaults to <tt>cat</tt>. For <cite>sh</cite>/<cite>ksh</cite> behavior, change this to <tt>:</tt>. For <cite>csh</cite>-like behavior, unset this parameter; the shell will print an error message if null commands are entered.

<a name="index-path"></a><a name="index-PATH"></a></dd>

<dt><tt>path</tt> <S> <Z> (<tt>PATH</tt> <S>)</dt>

<dd>

An array (colon-separated list) of directories to search for commands. When this parameter is set, each directory is scanned and all files found are put in a hash table.

<a name="index-POSTEDIT"></a></dd>

<dt><tt>POSTEDIT</tt> <S></dt>

<dd>

This string is output whenever the line editor exits. It usually contains termcap strings to reset the terminal.

<a name="index-PROMPT"></a></dd>

<dt><tt>PROMPT</tt> <S> <Z></dt>

<dd><a name="index-PROMPT2"></a></dd>

<dt><tt>PROMPT2</tt> <S> <Z></dt>

<dd><a name="index-PROMPT3"></a></dd>

<dt><tt>PROMPT3</tt> <S> <Z></dt>

<dd><a name="index-PROMPT4"></a></dd>

<dt><tt>PROMPT4</tt> <S> <Z></dt>

<dd>

Same as <tt>PS1</tt>, <tt>PS2</tt>, <tt>PS3</tt> and <tt>PS4</tt>, respectively.

<a name="index-prompt"></a></dd>

<dt><tt>prompt</tt> <S> <Z></dt>

<dd>

Same as <tt>PS1</tt>.

<a name="index-PROMPT_005fEOL_005fMARK"></a></dd>

<dt><tt>PROMPT_EOL_MARK</tt></dt>

<dd>

When the <tt>PROMPT_CR</tt> and <tt>PROMPT_SP</tt> options are set, the <tt>PROMPT_EOL_MARK</tt> parameter can be used to customize how the end of partial lines are shown. This parameter undergoes prompt expansion, with the <tt>PROMPT_PERCENT</tt> option set. If not set, the default behavior is equivalent to the value ‘<tt>%B%S%#%s%b</tt>’.

<a name="index-PS1"></a></dd>

<dt><tt>PS1</tt> <S></dt>

<dd>

The primary prompt string, printed before a command is read. It undergoes a special form of expansion before being displayed; see [Prompt Expansion](Prompt-Expansion.html#Prompt-Expansion). The default is ‘<tt>%m%#</tt> ’.

<a name="index-PS2"></a></dd>

<dt><tt>PS2</tt> <S></dt>

<dd>

The secondary prompt, printed when the shell needs more information to complete a command. It is expanded in the same way as <tt>PS1</tt>. The default is ‘<tt>%_></tt> ’, which displays any shell constructs or quotation marks which are currently being processed.

<a name="index-PS3"></a></dd>

<dt><tt>PS3</tt> <S></dt>

<dd>

Selection prompt used within a <tt>select</tt> loop. It is expanded in the same way as <tt>PS1</tt>. The default is ‘<tt>?#</tt> ’.

<a name="index-PS4"></a></dd>

<dt><tt>PS4</tt> <S></dt>

<dd>

The execution trace prompt. Default is ‘<tt>+%N:%i></tt> ’, which displays the name of the current shell structure and the line number within it. In sh or ksh emulation, the default is ‘<tt>+</tt> ’.

<a name="index-psvar"></a><a name="index-PSVAR"></a></dd>

<dt><tt>psvar</tt> <S> <Z> (<tt>PSVAR</tt> <S>)</dt>

<dd>

An array (colon-separated list) whose elements can be used in <tt>PROMPT</tt> strings. Setting <tt>psvar</tt> also sets <tt>PSVAR</tt>, and vice versa.

<a name="index-READNULLCMD"></a></dd>

<dt><tt>READNULLCMD</tt> <S></dt>

<dd>

The command name to assume if a single input redirection is specified with no command. Defaults to <tt>more</tt>.

<a name="index-REPORTMEMORY"></a></dd>

<dt><tt>REPORTMEMORY</tt></dt>

<dd>

If nonnegative, commands whose maximum resident set size (roughly speaking, main memory usage) in megabytes is greater than this value have timing statistics reported. The format used to output statistics is the value of the <tt>TIMEFMT</tt> parameter, which is the same as for the <tt>REPORTTIME</tt> variable and the <tt>time</tt> builtin; note that by default this does not output memory usage. Appending <tt>" max RSS %M"</tt> to the value of <tt>TIMEFMT</tt> causes it to output the value that triggered the report. If <tt>REPORTTIME</tt> is also in use, at most a single report is printed for both triggers. This feature requires the <tt>getrusage()</tt> system call, commonly supported by modern Unix-like systems.

<a name="index-REPORTTIME"></a></dd>

<dt><tt>REPORTTIME</tt></dt>

<dd>

If nonnegative, commands whose combined user and system execution times (measured in seconds) are greater than this value have timing statistics printed for them. Output is suppressed for commands executed within the line editor, including completion; commands explicitly marked with the <tt>time</tt> keyword still cause the summary to be printed in this case.

<a name="index-REPLY"></a></dd>

<dt><tt>REPLY</tt></dt>

<dd>

This parameter is reserved by convention to pass string values between shell scripts and shell builtins in situations where a function call or redirection are impossible or undesirable. The <tt>read</tt> builtin and the <tt>select</tt> complex command may set <tt>REPLY</tt>, and filename generation both sets and examines its value when evaluating certain expressions. Some modules also employ <tt>REPLY</tt> for similar purposes.

<a name="index-reply"></a></dd>

<dt><tt>reply</tt></dt>

<dd>

As <tt>REPLY</tt>, but for array values rather than strings.

<a name="index-RPROMPT"></a></dd>

<dt><tt>RPROMPT</tt> <S></dt>

<dd><a name="index-RPS1"></a></dd>

<dt><tt>RPS1</tt> <S></dt>

<dd>

This prompt is displayed on the right-hand side of the screen when the primary prompt is being displayed on the left. This does not work if the <tt>SINGLE_LINE_ZLE</tt> option is set. It is expanded in the same way as <tt>PS1</tt>.

<a name="index-RPROMPT2"></a></dd>

<dt><tt>RPROMPT2</tt> <S></dt>

<dd><a name="index-RPS2"></a></dd>

<dt><tt>RPS2</tt> <S></dt>

<dd>

This prompt is displayed on the right-hand side of the screen when the secondary prompt is being displayed on the left. This does not work if the <tt>SINGLE_LINE_ZLE</tt> option is set. It is expanded in the same way as <tt>PS2</tt>.

<a name="index-SAVEHIST"></a></dd>

<dt><tt>SAVEHIST</tt></dt>

<dd>

The maximum number of history events to save in the history file.

If this is made local, it is not implicitly set to 0, but may be explicitly set locally.

<a name="index-SPROMPT"></a></dd>

<dt><tt>SPROMPT</tt> <S></dt>

<dd>

The prompt used for spelling correction. The sequence ‘<tt>%R</tt>’ expands to the string which presumably needs spelling correction, and ‘<tt>%r</tt>’ expands to the proposed correction. All other prompt escapes are also allowed.

<a name="index-STTY"></a></dd>

<dt><tt>STTY</tt></dt>

<dd>

If this parameter is set in a command’s environment, the shell runs the <tt>stty</tt> command with the value of this parameter as arguments in order to set up the terminal before executing the command. The modes apply only to the command, and are reset when it finishes or is suspended. If the command is suspended and continued later with the <tt>fg</tt> or <tt>wait</tt> builtins it will see the modes specified by <tt>STTY</tt>, as if it were not suspended. This (intentionally) does not apply if the command is continued via ‘<tt>kill -CONT</tt>’. <tt>STTY</tt> is ignored if the command is run in the background, or if it is in the environment of the shell but not explicitly assigned to in the input line. This avoids running stty at every external command by accidentally exporting it. Also note that <tt>STTY</tt> should not be used for window size specifications; these will not be local to the command.

<a name="index-TERM"></a></dd>

<dt><tt>TERM</tt> <S></dt>

<dd>

The type of terminal in use. This is used when looking up termcap sequences. An assignment to <tt>TERM</tt> causes zsh to re-initialize the terminal, even if the value does not change (e.g., ‘<tt>TERM=$TERM</tt>’). It is necessary to make such an assignment upon any change to the terminal definition database or terminal type in order for the new settings to take effect.

<a name="index-TERMINFO"></a></dd>

<dt><tt>TERMINFO</tt> <S></dt>

<dd>

A reference to a compiled description of the terminal, used by the ‘terminfo’ library when the system has it; see man page terminfo(5). If set, this causes the shell to reinitialise the terminal, making the workaround ‘<tt>TERM=$TERM</tt>’ unnecessary.

<a name="index-TIMEFMT"></a></dd>

<dt><tt>TIMEFMT</tt></dt>

<dd>

The format of process time reports with the <tt>time</tt> keyword. The default is ‘<tt>%J %U user %S system %P cpu %*E total</tt>’. Recognizes the following escape sequences, although not all may be available on all systems, and some that are available may not be useful:

<dl compact="compact">

<dt><tt>%%</tt></dt>

<dd>

A ‘<tt>%</tt>’.

</dd>

<dt><tt>%U</tt></dt>

<dd>

CPU seconds spent in user mode.

</dd>

<dt><tt>%S</tt></dt>

<dd>

CPU seconds spent in kernel mode.

</dd>

<dt><tt>%E</tt></dt>

<dd>

Elapsed time in seconds.

</dd>

<dt><tt>%P</tt></dt>

<dd>

The CPU percentage, computed as 100*(<tt>%U</tt>+<tt>%S</tt>)/<tt>%E</tt>.

</dd>

<dt><tt>%W</tt></dt>

<dd>

Number of times the process was swapped.

</dd>

<dt><tt>%X</tt></dt>

<dd>

The average amount in (shared) text space used in kilobytes.

</dd>

<dt><tt>%D</tt></dt>

<dd>

The average amount in (unshared) data/stack space used in kilobytes.

</dd>

<dt><tt>%K</tt></dt>

<dd>

The total space used (<tt>%X</tt>+<tt>%D</tt>) in kilobytes.

</dd>

<dt><tt>%M</tt></dt>

<dd>

The maximum memory the process had in use at any time in megabytes.

</dd>

<dt><tt>%F</tt></dt>

<dd>

The number of major page faults (page needed to be brought from disk).

</dd>

<dt><tt>%R</tt></dt>

<dd>

The number of minor page faults.

</dd>

<dt><tt>%I</tt></dt>

<dd>

The number of input operations.

</dd>

<dt><tt>%O</tt></dt>

<dd>

The number of output operations.

</dd>

<dt><tt>%r</tt></dt>

<dd>

The number of socket messages received.

</dd>

<dt><tt>%s</tt></dt>

<dd>

The number of socket messages sent.

</dd>

<dt><tt>%k</tt></dt>

<dd>

The number of signals received.

</dd>

<dt><tt>%w</tt></dt>

<dd>

Number of voluntary context switches (waits).

</dd>

<dt><tt>%c</tt></dt>

<dd>

Number of involuntary context switches.

</dd>

<dt><tt>%J</tt></dt>

<dd>

The name of this job.

</dd>

</dl>

A star may be inserted between the percent sign and flags printing time. This cause the time to be printed in ‘<var>hh</var><tt>:</tt><var>mm</var><tt>:</tt><var>ss</var><tt>\.</tt><var>ttt</var>’ format (hours and minutes are only printed if they are not zero).

<a name="index-TMOUT"></a></dd>

<dt><tt>TMOUT</tt></dt>

<dd>

If this parameter is nonzero, the shell will receive an <tt>ALRM</tt> signal if a command is not entered within the specified number of seconds after issuing a prompt. If there is a trap on <tt>SIGALRM</tt>, it will be executed and a new alarm is scheduled using the value of the <tt>TMOUT</tt> parameter after executing the trap. If no trap is set, and the idle time of the terminal is not less than the value of the <tt>TMOUT</tt> parameter, zsh terminates. Otherwise a new alarm is scheduled to <tt>TMOUT</tt> seconds after the last keypress.

<a name="index-TMPPREFIX"></a></dd>

<dt><tt>TMPPREFIX</tt></dt>

<dd>

A pathname prefix which the shell will use for all temporary files. Note that this should include an initial part for the file name as well as any directory names. The default is ‘<tt>/tmp/zsh</tt>’.

<a name="index-watch"></a><a name="index-WATCH"></a></dd>

<dt><tt>watch</tt> <S> <Z> (<tt>WATCH</tt> <S>\)</dt>

<dd>

An array (colon-separated list) of login/logout events to report.

If it contains the single word ‘<tt>all</tt>’, then all login/logout events are reported. If it contains the single word ‘<tt>notme</tt>’, then all events are reported as with ‘<tt>all</tt>’ except <tt>$USERNAME</tt>.

An entry in this list may consist of a username, an ‘<tt>@</tt>’ followed by a remote hostname, and a ‘<tt>%</tt>’ followed by a line (tty). Any of these may be a pattern (be sure to quote this during the assignment to <tt>watch</tt> so that it does not immediately perform file generation); the setting of the <tt>EXTENDED_GLOB</tt> option is respected. Any or all of these components may be present in an entry; if a login/logout event matches all of them, it is reported.

For example, with the <tt>EXTENDED_GLOB</tt> option set, the following:

<div class="example">

<pre class="example">watch=('^(pws|barts)')
</pre>

</div>

causes reports for activity assoicated with any user other than <tt>pws</tt> or <tt>barts</tt>.

<a name="index-WATCHFMT"></a></dd>

<dt><tt>WATCHFMT</tt></dt>

<dd>

The format of login/logout reports if the <tt>watch</tt> parameter is set. Default is ‘<tt>%n has %a %l from %m</tt>’. Recognizes the following escape sequences:

<dl compact="compact">

<dt><tt>%n</tt></dt>

<dd>

The name of the user that logged in/out.

</dd>

<dt><tt>%a</tt></dt>

<dd>

The observed action, i.e. "logged on" or "logged off".

</dd>

<dt><tt>%l</tt></dt>

<dd>

The line (tty) the user is logged in on.

</dd>

<dt><tt>%M</tt></dt>

<dd>

The full hostname of the remote host.

</dd>

<dt><tt>%m</tt></dt>

<dd>

The hostname up to the first ‘<tt>.</tt>’. If only the IP address is available or the utmp field contains the name of an X-windows display, the whole name is printed.

_NOTE:_ The ‘<tt>%m</tt>’ and ‘<tt>%M</tt>’ escapes will work only if there is a host name field in the utmp on your machine. Otherwise they are treated as ordinary strings.

</dd>

<dt><tt>%S</tt> (<tt>%s</tt>)</dt>

<dd>

Start (stop) standout mode.

</dd>

<dt><tt>%U</tt> (<tt>%u</tt>)</dt>

<dd>

Start (stop) underline mode.

</dd>

<dt><tt>%B</tt> (<tt>%b</tt>)</dt>

<dd>

Start (stop) boldface mode.

</dd>

<dt><tt>%t</tt></dt>

<dt><tt>%@</tt></dt>

<dd>

The time, in 12-hour, am/pm format.

</dd>

<dt><tt>%T</tt></dt>

<dd>

The time, in 24-hour format.

</dd>

<dt><tt>%w</tt></dt>

<dd>

The date in ‘<var>day</var><tt>-</tt><var>dd</var>’ format.

</dd>

<dt><tt>%W</tt></dt>

<dd>

The date in ‘<var>mm</var><tt>/</tt><var>dd</var><tt>/</tt><var>yy</var>’ format.

</dd>

<dt><tt>%D</tt></dt>

<dd>

The date in ‘<var>yy</var><tt>-</tt><var>mm</var><tt>-</tt><var>dd</var>’ format.

</dd>

<dt><tt>%D{</tt><var>string</var><tt>}</tt></dt>

<dd>

The date formatted as <var>string</var> using the <tt>strftime</tt> function, with zsh extensions as described by [Prompt Expansion](Prompt-Expansion.html#Prompt-Expansion).

</dd>

<dt><tt>%(</tt><var>x</var><tt>:</tt><var>true-text</var><tt>:</tt><var>false-text</var><tt>)</tt></dt>

<dd>

Specifies a ternary expression. The character following the <var>x</var> is arbitrary; the same character is used to separate the text for the "true" result from that for the "false" result. Both the separator and the right parenthesis may be escaped with a backslash. Ternary expressions may be nested.

The test character <var>x</var> may be any one of ‘<tt>l</tt>’, ‘<tt>n</tt>’, ‘<tt>m</tt>’ or ‘<tt>M</tt>’, which indicate a ‘true’ result if the corresponding escape sequence would return a non-empty value; or it may be ‘<tt>a</tt>’, which indicates a ‘true’ result if the watched user has logged in, or ‘false’ if he has logged out. Other characters evaluate to neither true nor false; the entire expression is omitted in this case.

If the result is ‘true’, then the <var>true-text</var> is formatted according to the rules above and printed, and the <var>false-text</var> is skipped. If ‘false’, the <var>true-text</var> is skipped and the <var>false-text</var> is formatted and printed. Either or both of the branches may be empty, but both separators must be present in any case.

</dd>

</dl>

<a name="index-WORDCHARS"></a></dd>

<dt><tt>WORDCHARS</tt> <S></dt>

<dd>

A list of non-alphanumeric characters considered part of a word by the line editor.

<a name="index-ZBEEP"></a></dd>

<dt><tt>ZBEEP</tt></dt>

<dd>

If set, this gives a string of characters, which can use all the same codes as the <tt>bindkey</tt> command as described in [The zsh/zle Module](Zsh-Modules.html#The-zsh_002fzle-Module), that will be output to the terminal instead of beeping. This may have a visible instead of an audible effect; for example, the string ‘<tt>\e[?5h\e[?5l</tt>’ on a vt100 or xterm will have the effect of flashing reverse video on and off (if you usually use reverse video, you should use the string ‘<tt>\e[?5l\e[?5h</tt>’ instead). This takes precedence over the <tt>NOBEEP</tt> option.

<a name="index-ZDOTDIR"></a></dd>

<dt><tt>ZDOTDIR</tt></dt>

<dd>

The directory to search for shell startup files (.zshrc, etc), if not <tt>$HOME</tt>.

<a name="index-zle_005fbracketed_005fpaste"></a><a name="index-bracketed-paste"></a><a name="index-enabling-bracketed-paste"></a></dd>

<dt><tt>zle_bracketed_paste</tt></dt>

<dd>

Many terminal emulators have a feature that allows applications to identify when text is pasted into the terminal rather than being typed normally. For ZLE, this means that special characters such as tabs and newlines can be inserted instead of invoking editor commands. Furthermore, pasted text forms a single undo event and if the region is active, pasted text will replace the region.

This two-element array contains the terminal escape sequences for enabling and disabling the feature. These escape sequences are used to enable bracketed paste when ZLE is active and disable it at other times. Unsetting the parameter has the effect of ensuring that bracketed paste remains disabled.

<a name="index-zle_005fhighlight"></a></dd>

<dt><tt>zle_highlight</tt></dt>

<dd>

An array describing contexts in which ZLE should highlight the input text. See [Character Highlighting](Zsh-Line-Editor.html#Character-Highlighting).

<a name="index-ZLE_005fLINE_005fABORTED"></a></dd>

<dt><tt>ZLE_LINE_ABORTED</tt></dt>

<dd>

This parameter is set by the line editor when an error occurs. It contains the line that was being edited at the point of the error. ‘<tt>print -zr – $ZLE_LINE_ABORTED</tt>’ can be used to recover the line. Only the most recent line of this kind is remembered.

<a name="index-ZLE_005fREMOVE_005fSUFFIX_005fCHARS"></a><a name="index-ZLE_005fSPACE_005fSUFFIX_005fCHARS"></a></dd>

<dt><tt>ZLE_REMOVE_SUFFIX_CHARS</tt></dt>

<dt><tt>ZLE_SPACE_SUFFIX_CHARS</tt></dt>

<dd>

These parameters are used by the line editor. In certain circumstances suffixes (typically space or slash) added by the completion system will be removed automatically, either because the next editing command was not an insertable character, or because the character was marked as requiring the suffix to be removed.

These variables can contain the sets of characters that will cause the suffix to be removed. If <tt>ZLE_REMOVE_SUFFIX_CHARS</tt> is set, those characters will cause the suffix to be removed; if <tt>ZLE_SPACE_SUFFIX_CHARS</tt> is set, those characters will cause the suffix to be removed and replaced by a space.

If <tt>ZLE_REMOVE_SUFFIX_CHARS</tt> is not set, the default behaviour is equivalent to:

<div class="example">

<pre class="example">ZLE_REMOVE_SUFFIX_CHARS=/pre> \t\n;&|'
</pre>

</div>

If <tt>ZLE_REMOVE_SUFFIX_CHARS</tt> is set but is empty, no characters have this behaviour. <tt>ZLE_SPACE_SUFFIX_CHARS</tt> takes precedence, so that the following:

<div class="example">

<pre class="example">ZLE_SPACE_SUFFIX_CHARS=/pre>&|'
</pre>

</div>

causes the characters ‘<tt>&</tt>’ and ‘<tt>|</tt>’ to remove the suffix but to replace it with a space.

To illustrate the difference, suppose that the option <tt>AUTO_REMOVE_SLASH</tt> is in effect and the directory <tt>DIR</tt> has just been completed, with an appended <tt>/</tt>, following which the user types ‘<tt>&</tt>’. The default result is ‘<tt>DIR&</tt>’. With <tt>ZLE_REMOVE_SUFFIX_CHARS</tt> set but without including ‘<tt>&</tt>’ the result is ‘<tt>DIR/&</tt>’. With <tt>ZLE_SPACE_SUFFIX_CHARS</tt> set to include ‘<tt>&</tt>’ the result is ‘<tt>DIR &</tt>’.

Note that certain completions may provide their own suffix removal or replacement behaviour which overrides the values described here. See the completion system documentation in [Completion System](Completion-System.html#Completion-System).

<a name="index-ZLE_005fRPROMPT_005fINDENT"></a></dd>

<dt><tt>ZLE_RPROMPT_INDENT</tt> <S></dt>

<dd>

If set, used to give the indentation between the right hand side of the right prompt in the line editor as given by <tt>RPS1</tt> or <tt>RPROMPT</tt> and the right hand side of the screen. If not set, the value 1 is used.

Typically this will be used to set the value to 0 so that the prompt appears flush with the right hand side of the screen. This is not the default as many terminals do not handle this correctly, in particular when the prompt appears at the extreme bottom right of the screen. Recent virtual terminals are more likely to handle this case correctly. Some experimentation is necessary.

</dd>

</dl>

---

| [ [\<\<](#Parameters) ] | [ [>>](Options.html#Options) ] | \[[Top](index.html#Top "Cover (top) of document")] | \[[Contents](zsh_toc.html#SEC_Contents)] | \[[Index](Concept-Index.html#Concept-Index)] | [ [?](zsh_abt.html#SEC_About "About (help)") ] |

<font size="-1">This document was generated on *July 30, 2016* using [*texi2html 5.0*](http://www.nongnu.org/texi2html/).</font>
