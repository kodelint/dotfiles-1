# Configuration file for jupyter-console.

#------------------------------------------------------------------------------
# Configurable configuration
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# LoggingConfigurable configuration
#------------------------------------------------------------------------------

# A parent class for Configurables that log.
# 
# Subclasses have a log trait, and the default behavior is to get the logger
# from the currently running Application.

#------------------------------------------------------------------------------
# ConnectionFileMixin configuration
#------------------------------------------------------------------------------

# Mixin for configurable classes that work with connection files

# Set the kernel's IP address [default localhost]. If the IP address is
# something other than localhost, then Consoles on other machines will be able
# to connect to the Kernel, so be careful!
# c.ConnectionFileMixin.ip = ''

# set the stdin (ROUTER) port [default: random]
# c.ConnectionFileMixin.stdin_port = 0

# JSON file in which to store connection info [default: kernel-<pid>.json]
# 
# This file will contain the IP, ports, and authentication key needed to connect
# clients to this kernel. By default, this file will be created in the security
# dir of the current profile, but can be specified by absolute path.
# c.ConnectionFileMixin.connection_file = ''

# set the heartbeat port [default: random]
# c.ConnectionFileMixin.hb_port = 0

# set the iopub (PUB) port [default: random]
# c.ConnectionFileMixin.iopub_port = 0

# set the control (ROUTER) port [default: random]
# c.ConnectionFileMixin.control_port = 0

# 
# c.ConnectionFileMixin.transport = 'tcp'

# set the shell (ROUTER) port [default: random]
# c.ConnectionFileMixin.shell_port = 0

#------------------------------------------------------------------------------
# JupyterConsoleApp configuration
#------------------------------------------------------------------------------

# The SSH server to use to connect to the kernel.
# c.JupyterConsoleApp.sshserver = ''

# Connect to an already running kernel
# c.JupyterConsoleApp.existing = ''

# Set to display confirmation dialog on exit. You can always use 'exit' or
# 'quit', to force a direct exit without any confirmation.
c.JupyterConsoleApp.confirm_exit = False

# The name of the default kernel to start.
# c.JupyterConsoleApp.kernel_name = 'python'

# Path to the ssh key to use for logging in to the ssh server.
# c.JupyterConsoleApp.sshkey = ''

#------------------------------------------------------------------------------
# SingletonConfigurable configuration
#------------------------------------------------------------------------------

# A configurable that only allows one instance.
# 
# This class is for classes that should only have one instance of itself or
# *any* subclass. To create and retrieve such a class use the
# :meth:`SingletonConfigurable.instance` method.

#------------------------------------------------------------------------------
# Application configuration
#------------------------------------------------------------------------------

# This is an application.

# The date format used by logging formatters for %(asctime)s
# c.Application.log_datefmt = '%Y-%m-%d %H:%M:%S'

# Set the log level by value or name.
# c.Application.log_level = 30

# The Logging format template
# c.Application.log_format = '[%(name)s]%(highlevel)s %(message)s'

#------------------------------------------------------------------------------
# JupyterApp configuration
#------------------------------------------------------------------------------

# Base class for Jupyter applications

# Answer yes to any prompts.
# c.JupyterApp.answer_yes = False

# Specify a config file to load.
# c.JupyterApp.config_file_name = ''

# Full path of a config file.
# c.JupyterApp.config_file = ''

# Generate default config file.
# c.JupyterApp.generate_config = False

#------------------------------------------------------------------------------
# ZMQTerminalIPythonApp configuration
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# ZMQTerminalInteractiveShell configuration
#------------------------------------------------------------------------------

# Preferred object representation MIME type in order.  First matched MIME type
# will be used.
# c.ZMQTerminalInteractiveShell.mime_preference = traitlets.Undefined

# How many history items to load into memory
# c.ZMQTerminalInteractiveShell.history_load_length = 1000

# Whether to use the kernel's is_complete message handling. If False, then the
# frontend will use its own is_complete handler.
# c.ZMQTerminalInteractiveShell.use_kernel_is_complete = True

# Timeout (in seconds) for giving up on a kernel's is_complete response.
# 
# If the kernel does not respond at any point within this time, the kernel will
# no longer be asked if code is complete, and the console will default to the
# built-in is_complete test.
# c.ZMQTerminalInteractiveShell.kernel_is_complete_timeout = 1

# Override highlighting format for specific tokens
# c.ZMQTerminalInteractiveShell.highlighting_style_overrides = traitlets.Undefined

# Prefix to add to outputs coming from clients other than this one.
# 
# Only relevant if include_other_output is True.
# c.ZMQTerminalInteractiveShell.other_output_prefix = '[remote] '

# Whether to include output from clients other than this one sharing the same
# kernel.
# 
# Outputs are not displayed until enter is pressed.
# c.ZMQTerminalInteractiveShell.include_other_output = False

# Command to invoke an image viewer program when you are using 'stream' image
# handler.  This option is a list of string where the first element is the
# command itself and reminders are the options for the command.  Raw image data
# is given as STDIN to the program.
# c.ZMQTerminalInteractiveShell.stream_image_handler = traitlets.Undefined

# Shortcut style to use at the prompt. 'vi' or 'emacs'.
# c.ZMQTerminalInteractiveShell.editing_mode = 'emacs'

# Handler for image type output.  This is useful, for example, when connecting
# to the kernel in which pylab inline backend is activated.  There are four
# handlers defined.  'PIL': Use Python Imaging Library to popup image; 'stream':
# Use an external program to show the image.  Image will be fed into the STDIN
# of the program.  You will need to configure `stream_image_handler`;
# 'tempfile': Use an external program to show the image.  Image will be saved in
# a temporally file and the program is called with the temporally file.  You
# will need to configure `tempfile_image_handler`; 'callable': You can set any
# Python callable which is called with the image data.  You will need to
# configure `callable_image_handler`.
# c.ZMQTerminalInteractiveShell.image_handler = 'PIL'

# Callable object called via 'callable' image handler with one argument, `data`,
# which is `msg["content"]["data"]` where `msg` is the message from iopub
# channel.  For exmaple, you can find base64 encoded PNG data as
# `data['image/png']`. If your function can't handle the data supplied, it
# should return `False` to indicate this.
# c.ZMQTerminalInteractiveShell.callable_image_handler = None

# Timeout for giving up on a kernel (in seconds).
# 
# On first connect and restart, the console tests whether the kernel is running
# and responsive by sending kernel_info_requests. This sets the timeout in
# seconds for how long the kernel can take before being presumed dead.
# c.ZMQTerminalInteractiveShell.kernel_timeout = 60

# Text to display before the first prompt. Will be formatted with variables
# {version} and {kernel_banner}.
# c.ZMQTerminalInteractiveShell.banner = 'Jupyter console {version}\n\n{kernel_banner}'

# The name of a Pygments style to use for syntax highlighting
# c.ZMQTerminalInteractiveShell.highlighting_style = ''

# Command to invoke an image viewer program when you are using 'tempfile' image
# handler.  This option is a list of string where the first element is the
# command itself and reminders are the options for the command.  You can use
# {file} and {format} in the string to represent the location of the generated
# image file and image format.
# c.ZMQTerminalInteractiveShell.tempfile_image_handler = traitlets.Undefined

#------------------------------------------------------------------------------
# KernelManager configuration
#------------------------------------------------------------------------------

# Manages a single kernel in a subprocess on this host.
# 
# This version starts kernels with Popen.

# Should we autorestart the kernel if it dies.
# c.KernelManager.autorestart = False

# DEPRECATED: Use kernel_name instead.
# 
# The Popen Command to launch the kernel. Override this if you have a custom
# kernel. If kernel_cmd is specified in a configuration file, Jupyter does not
# pass any arguments to the kernel, because it cannot make any assumptions about
# the arguments that the kernel understands. In particular, this means that the
# kernel does not receive the option --debug if it given on the Jupyter command
# line.
# c.KernelManager.kernel_cmd = traitlets.Undefined

#------------------------------------------------------------------------------
# Session configuration
#------------------------------------------------------------------------------

# Object for handling serialization and sending of messages.
# 
# The Session object handles building messages and sending them with ZMQ sockets
# or ZMQStream objects.  Objects can communicate with each other over the
# network via Session objects, and only need to work with the dict-based IPython
# message spec. The Session will handle serialization/deserialization, security,
# and metadata.
# 
# Sessions support configurable serialization via packer/unpacker traits, and
# signing with HMAC digests via the key/keyfile traits.
# 
# Parameters ----------
# 
# debug : bool
#     whether to trigger extra debugging statements
# packer/unpacker : str : 'json', 'pickle' or import_string
#     importstrings for methods to serialize message parts.  If just
#     'json' or 'pickle', predefined JSON and pickle packers will be used.
#     Otherwise, the entire importstring must be used.
# 
#     The functions must accept at least valid JSON input, and output *bytes*.
# 
#     For example, to use msgpack:
#     packer = 'msgpack.packb', unpacker='msgpack.unpackb'
# pack/unpack : callables
#     You can also set the pack/unpack callables for serialization directly.
# session : bytes
#     the ID of this Session object.  The default is to generate a new UUID.
# username : unicode
#     username added to message headers.  The default is to ask the OS.
# key : bytes
#     The key used to initialize an HMAC signature.  If unset, messages
#     will not be signed or checked.
# keyfile : filepath
#     The file containing a key.  If this is set, `key` will be initialized
#     to the contents of the file.

# Metadata dictionary, which serves as the default top-level metadata dict for
# each message.
# c.Session.metadata = traitlets.Undefined

# The UUID identifying this session.
# c.Session.session = ''

# Username for the Session. Default is your system username.
# c.Session.username = 'zchee'

# Debug output in the Session
# c.Session.debug = False

# The name of the unpacker for unserializing messages. Only used with custom
# functions for `packer`.
# c.Session.unpacker = 'json'

# Threshold (in bytes) beyond which a buffer should be sent without copying.
# c.Session.copy_threshold = 65536

# path to file containing execution key.
# c.Session.keyfile = ''

# execution key, for signing messages.
# c.Session.key = b''

# Threshold (in bytes) beyond which an object's buffer should be extracted to
# avoid pickling.
# c.Session.buffer_threshold = 1024

# The maximum number of items for a container to be introspected for custom
# serialization. Containers larger than this are pickled outright.
# c.Session.item_threshold = 64

# The maximum number of digests to remember.
# 
# The digest history will be culled when it exceeds this value.
# c.Session.digest_history_size = 65536

# The digest scheme used to construct the message signatures. Must have the form
# 'hmac-HASH'.
# c.Session.signature_scheme = 'hmac-sha256'

# The name of the packer for serializing messages. Should be one of 'json',
# 'pickle', or an import name for a custom callable serializer.
# c.Session.packer = 'json'
