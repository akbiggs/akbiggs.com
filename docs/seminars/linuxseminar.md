Why Use The Terminal?
-----------------------

The majority of your assignments in school, and the scripts you write in general, will operate on text. The terminal gives you a natural interface with programs that read and return text.

There are also situations where you won’t be able to use the graphical user interface on a computer that you need to connect to. For example, if you're connecting to another computer without graphics, you need to know how to work through the command line.

Basics Of A Command
----------------------

A command is broken up into two sections: The name and the arguments. e.g.
"mv file1 file2" executes the command "mv" on the arguments "file1" and "file2".
This specific command would rename "file1" to be called "file2" instead.

Most commands can have their behavior changed by passing flags to the command.
Flags are passed as arguments prepended with a single -, e.g. "ls -a" lists all the files in the current directory. If you are passing multiple flags to a command, you
can write all the flags together with a single -, e.g. "ls -lh" is a shorthand for
writing "ls -l -h".

Stopping Commands
-------------------

Ctrl+C(hold control, then hit C) will send an interrupt signal to the currently
running process in your terminal, causing it to stop executing.

Redirection
----------------

You can send a file's contents as input to a program using "<". For example,
if you've written a script that takes a bunch of text as input, you could write
"myscript < test".

Similarly, to take the output from a command and move it into a file, you can use ">". e.g. "ls > myfiles.txt" would populate myfiles.txt with all the files in the current directory. Note that this wipes the current contents of the file. If you
want to append to a file, use ">>" instead.

Piping
-----------

To take the output of a command and pass it as input into another command, use "|".
For example, "ps aux | grep username" gets all the running processes and lists out
just the ones that contain the given username somewhere in their info.

Scripting
------------------

For executing multiple commands and iterating over things or branching based on
conditions, you can use shell scripting. [Here's a book](http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html) introducing the shell in the context of writing scripts.

Example script:

```
while true
do
	sleep 1
	echo "I'm scripting!"
end
```

Commands
==========

Miscellaneous
--------------

- Change your account password: ```passwd```
- Get information about a user: ```finger USERNAME```
- Print operating system information: ```uname -a```
- Display the current date and time: ```date```
- Display environment cariables (settings): ```env```
- Clear your terminal: ```clear```

Getting Help
-------------

- Get detailed help for a command: ```man COMMAND```
- Search for a relevant command: ```apropos KEYWORD```
- Find out the full path to a command: ```which COMMAND```

Filesystem Commands
--------------------

- Change to another directory: ```cd DIRECTORY```
- List files in the current directory: ```ls [-alhF]```
- Print the current working directory: ```pwd```
- Copy a file somewhere: ```cp SOURCEFILE DESTFILE```
- Copy an entire directory somewhere: ```cp -r SOURCEFILE DESTFILE```
- Move or rename a file: ```mv SOURCEFILE DESTFILE```
- Delete a file (-f removes without confirming, be careful): ```rm [-f] FILENAME```
- Remove an empty directory (folder): ```rmdir DIRECTORYNAME```
- Remove a directory (folder) and contents: ```rm -r [-f] DIRECTORYNAME```
- Change permissions of files and directories: ```chmod PERMISSIONS FILES```
- Find out how much disk space a file uses: ```du [-sh] FILENAME```
- See the processes being run: "ps [aux]"

Working with (Text) Files
--------------------------

- Display the contents of a file: ```cat FILENAME```
- Display the first few lines of a file: ```head [-n NUM] FILENAME```
- Display the last few lines of a file: ```tail [-n NUM] FILENAME```
- Go through the file one page at a time: ```less FILENAME```
- Display # of lines, words, bytes in a file: ```wc FILENAME```

Remotely Connecting
--------------------

Note that for X forwarding to work for running GUI-based applications, you will
need to install an X server on your computer. You can find instructions on this
by searching for "<your operating system name> X forwarding".

- Connect to CDF: ```ssh cdf.toronto.edu -Xl <username>```
- Disconnecting: ```exit``` or ```Ctrl+D```

Quota Commands
---------------

- Display your current disk quota: ```quota```
- Check what takes up the most space (useful for cleanup): ```diskusage```
- Display your current print quota: ```pquota```
- Get more print quota (if allowed): ```pquota -i```

*(Talk to the CDF admins on the 3rd floor of Bahen to buy more print quota)*

Printer Commands
-----------------

- Print a PDF or PostScript file: ```print [-P PRINTER] FILE```
- Single-sided printing: ```lpr [-P PRINTER] FILE```
- Look at the print queue for a printer: ```lpq [-P PRINTER]```
- Remove a job from the print queue: ```lprm [-P PRINTER] JOBNUM```
- Remove all your jobs from the print queue: ```lprm -a```
