setting | type | description | default
--------|------|-------------|--------
searchlimit | integer | set the amount of results displayed in the command bar | 20
scrollstep | integer | set the amount of pixels scrolled when using the scrollUp and scrollDown commands | 75
timeoutlen | integer | The amount of time to wait for a <Leader> mapping in milliseconds | 1000
fullpagescrollpercent | integer | set the percent of the page to be scrolled by when using the scrollFullPageUp and scrollFullPageDown commands | 85
typelinkhintsdelay | integer | the amount of time (in milliseconds) to wait before taking input after opening a link hint with typelinkhints and numerichints enabled | 500
scrollduration | integer | the duration of smooth scrolling | 20
vimport | integer | set the port to be used with the editWithVim insert mode command | 8001
zoomfactor | integer / double | the step size when zooming the page in/out | 0.1
scalehints | boolean | animate link hints as they appear | false
hud | boolean | show the heads-up-display | true
regexp | boolean | use regexp in find mode | true
ignorecase | boolean | ignore search case in find mode | true
linkanimations | boolean | show fade effect when link hints open and close | false
numerichints | boolean | use numbers for link hints instead of a set of characters | false
dimhintcharacters | boolean | dim letter matches in hint characters rather than remove them from the hint | true
defaultnewtabpage | boolean | use the default chrome://newtab page instead of a blank page | false
cncpcompletion | boolean | use <C-n> and <C-p> to cycle through completion results (requires you to set the nextCompletionResult keybinding in the chrome://extensions page (bottom right) | false
smartcase | boolean | case-insensitive find mode searches except when input contains a capital letter | true
incsearch | boolean | begin auto-highlighting find mode matches when input length is greater thant two characters | true
typelinkhints | boolean | (numerichints required) type text in the link to narrow down numeric hints | false
autohidecursor | boolean | hide the mouse cursor when scrolling (useful for Linux, which doesn't auto-hide the cursor on keydown) | false
autofocus | boolean | allows websites to automatically focus an input box when they are first loaded | true
insertmappings | boolean | use insert mappings to navigate the cursor in text boxes (see bindings below) | true
smoothscroll | boolean | use smooth scrolling | false
autoupdategist | boolean | if a GitHub Gist is used to sync settings, pull updates every hour (and when Chrome restarts) | false
nativelinkorder | boolean | Open new tabs like Chrome does rather than next to the currently opened tab | false
showtabindices | boolean | Display the tab index in the tab's title | false
sortlinkhints | boolean | Sort link hint lettering by the link's distance from the top-left corner of the page | false
localconfig | boolean | Read the cVimrc config from configpath (when this is set, you connot save from cVim's options page | false
completeonopen | boolean | Automatically show a list of command completions when the command bar is opened | false
configpath | string | Read the cVimrc from this local file when configpath is set | ""
changelog | boolean | Auto open the changelog when cVim is updated | true
completionengines | array of strings | use only the specified search engines | ["google", "duckduckgo", "wikipedia", "amazon"]
blacklists | array of strings | disable cVim on the sites matching one of the patterns | []
mapleader | string | The default <Leader> key | \
highlight | string | the highlight color in find mode | "#ffff00"
defaultengine | string | set the default search engine | "google"
locale | string | set the locale of the site being completed/searched on (see example configuration below) | ""
activehighlight | string | the highlight color for the current find match | "#ff9632"
homedirectory | string | the directory to replace ~ when using the file command | ""
qmark <alphanumeric charcter> | string | add a persistent QuickMark (e.g. let qmark a = ["http://google.com", "http://reddit.com"]) | none
previousmatchpattern | string (regexp) | the pattern looked for when navigating a page's back button | ((?!last)(prev(ious)?|back|«|less|<|‹| )+)
nextmatchpattern | string (regexp) | the pattern looked for when navigation a page's next button | ((?!first)(next|more|>|›|»|forward| )+)
hintcharacters | string (alphanumeric) | set the default characters to be used in link hint mode | "asdfgqwertzxcvb"
barposition | string ["top", "bottom"] | set the default position of the command bar | "top"
vimcommand | string | set the command to be issued with the editWithVim command | "gvim -f"
langmap | string | set a list of characters to be remapped (see vims langmap) | ""

```viml
" Settings
set nohud
set nosmoothscroll
set noautofocus " The opposite of autofocus; this setting stops
                " sites from focusing on an input box when they load
set typelinkhints
let searchlimit = 30
let scrollstep = 70
let barposition = "bottom"

let locale = "uk" " Current choices are 'jp' and 'uk'. This allows cVim to use sites like google.co.uk
                  " or google.co.jp to search rather than google.com. Support is currently limited.
                  " Let me know if you need a different locale for one of the completion/search engines
let hintcharacters = "abc123"

let searchengine dogpile = "http://www.dogpile.com/search/web?q=%s" " If you leave out the '%s' at the end of the URL,
                                                                    " your query will be appended to the link.
                                                                    " Otherwise, your query will replace the '%s'.

" alias ':g' to ':tabnew google'
command g tabnew google

let completionengines = ["google", "amazon", "imdb", "dogpile"]

let searchalias g = "google" " Create a shortcut for search engines.
                             " For example, typing ':tabnew g example'
                             " would act the same way as ':tabnew google example'

" Open all of these in a tab with `gnb` or open one of these with <N>goa where <N>
let qmark a = ["http://www.reddit.com", "http://www.google.com", "http://twitter.com"]

let blacklists = ["https://mail.google.com/*", "*://mail.google.com/*", "@https://mail.google.com/mail/*"]
" blacklists prefixed by '@' act as a whitelist

let mapleader = ","

" Mappings

map <Leader>r reloadTabUncached
map <Leader>x :restore<Space>

" This remaps the default 'j' mapping
map j scrollUp

" You can use <Space>, which is interpreted as a
" literal " " character, to enter buffer completion mode
map gb :buffer<Space>

" The unmaps the default 'k' mapping
unmap k

" This remaps the default 'f' mapping to the current 'F' mapping
map f F

" Toggle the current HUD display value
map <C-h> :set hud!<CR>

" Switch between alphabetical hint characters and numeric hints
map <C-i> :set numerichints!<CR>

map <C-u> rootFrame
map <M-h> previousTab
map <C-d> scrollPageDown
map <C-e> scrollPageUp
iunmap <C-y>
imap <C-m> deleteWord

" Create a variable that can be used/referenced in the command bar
let @@reddit_prog = 'http://www.reddit.com/r/programming'
let @@top_all = 'top?sort=top&t=all'
let @@top_day = 'top?sort=top&t=day'

" TA binding opens 'http://www.reddit.com/r/programming/top?sort=top&t=all' in a new tab
map TA :to @@reddit_prog/@@top_all<CR>
map TD :to @@reddit_prog/@@top_day<CR>

" Code blocks (see below for more info)
getIP() -> {{
httpRequest({url: 'http://api.ipify.org/?format=json', json: true},
            function(res) { Status.setMessage('IP: ' + res.ip); });
}}
" Displays your public IP address in the status bar
map ci :call getIP<CR>

" Script hints
echo(link) -> {{
  alert(link.href);
}}
map <C-f> createScriptHint(echo)

let configpath = '/path/to/your/.cvimrc'
set localconfig " Update settings via a local file (and the `:source` command) rather
                " than the default options page in chrome
" As long as localconfig is set in the .cvimrc file. cVim will continue to read
" settings from there
```
