# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import absolute_import, division, print_function

import collections
import curses
import os
import re
import subprocess

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command


# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!
class my_edit(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.acitons, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    # tabnum is 1 for <TAB> and -1 for <S-TAB> by default
    def tab(self, tabnum):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()


class mkcd(Command):
    """
    :mkcd <dirname>

    Creates a directory with the name <dirname> and enters it.
    """

    def execute(self):
        import re
        from os import makedirs
        from os.path import expanduser, join, lexists

        dirname = join(self.fm.thisdir.path, expanduser(self.rest(1)))
        if not lexists(dirname):
            makedirs(dirname)

            match = re.search("^/|^~[^/]*/", dirname)
            if match:
                self.fm.cd(match.group(0))
                dirname = dirname[match.end(0) :]

            for m in re.finditer("[^/]+", dirname):
                s = m.group(0)
                if s == ".." or (
                    s.startswith(".") and not self.fm.settings["show_hidden"]
                ):
                    self.fm.cd(s)
                else:
                    ## We force ranger to load content before calling `scout`.
                    self.fm.thisdir.load_content(schedule=False)
                    self.fm.execute_console("scout -ae ^{}$".format(s))
        else:
            self.fm.notify("file/directory exists!", bad=True)


def show_error_in_console(msg, fm):
    fm.notify(msg, bad=True)


def navigate_path(fm, selected):
    if not selected:
        return

    selected = os.path.abspath(selected)
    if os.path.isdir(selected):
        fm.cd(selected)
    elif os.path.isfile(selected):
        fm.select_file(selected)
    else:
        show_error_in_console(f"Neither directory nor file: {selected}", fm)
        return


def execute(cmd, input=None):
    stdin = None
    if input:
        stdin = subprocess.PIPE

    proc = subprocess.Popen(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=stdin, text=True
    )
    stdout, stderr = proc.communicate(input=input)

    if proc.returncode != 0:
        raise Exception(
            f"Bad process exit code: {proc.returncode}, stdout={stdout}, stderr={stderr}"
        )

    return stdout, stderr


URL = collections.namedtuple("URL", ["user", "hostname", "path"])


def parse_url(url):
    if len(t := url.split(sep="@", maxsplit=1)) > 1:
        user = t[0]
        rest = t[1]
    else:
        user = None
        rest = t[0]
    if len(t := rest.rsplit(sep=":", maxsplit=1)) > 1:
        hostname = t[0]
        path = t[1]
    else:
        hostname = t[0]
        path = None

    return URL(user=user, hostname=hostname, path=path)


def url2str(u: URL):
    res = u.hostname
    if u.user:
        res = f"{u.user}@{res}"
    path = u.path
    if path is None:
        path = ""

    return f"{res}:{path}"


def search_mount_path(mount_path):
    stdout, _ = execute(["mount"])
    return re.search(re.escape(mount_path) + r"\b", stdout)


def hostname2mount_path(hostname):
    mount_path = os.path.expanduser(f"~/.config/ranger/mounts/{hostname}")

    # check whether it is already mounted
    if search_mount_path(mount_path):
        raise Exception(f"Already mounted: {mount_path}")

    os.makedirs(mount_path, exist_ok=True)
    return mount_path


class sshfs_mount(Command):
    def execute(self):
        url = self.arg(1)
        u = parse_url(url)

        mount_path = hostname2mount_path(u.hostname)
        cmd = ["sshfs", url2str(u), mount_path]

        execute(cmd)

        # before navigating we should load it otherwise we see
        # "not accessible"
        d = self.fm.get_directory(mount_path)
        d.load()

        navigate_path(self.fm, mount_path)

    # options:
    # - None
    # - string: just one complete without iterating
    # - list, tuple, generator: to iterate options around
    def tab(self, tabnum):
        u = parse_url(self.rest(1))

        def path_options():
            lst = []
            for path in ["", "/"]:
                lst.append(self.start(1) + url2str(u._replace(path=path)))

            return lst

        # autocomplete hostname
        if u.path is None:
            hostname = select_with_fzf(
                ["fzf", "-q", u.hostname], compose_hostname_list(), self.fm
            )
            # hostname = "ilya-thinkpad"

            # after suspend/init we should manually show the cursor
            # the same way console.open() does
            try:
                curses.curs_set(1)
            except curses.error:
                pass

            if not hostname:
                return None

            u = u._replace(hostname=hostname)
            return path_options()

        # autocomplete path
        return path_options()


def umount(mount_path):
    prefix = os.path.expanduser(f"~/.config/ranger/mounts/")
    if not mount_path.startswith(prefix):
        raise Exception(f"May umount only inside: {prefix}")

    if not search_mount_path(mount_path):
        raise Exception(f"Not mounted: {mount_path}")

    cmd = ["diskutil", "unmount", "force", mount_path]
    execute(cmd)

    os.rmdir(mount_path)


class sshfs_umount(Command):
    def execute(self):
        tab = self.fm.tabs[self.fm.current_tab]
        mount_path = tab.thisfile.path
        umount(mount_path)


def compose_hostname_list():
    # list of possible hostnames
    # stolen from fzf, https://github.com/junegunn/fzf/blob/master/shell/completion.bash
    stdout, _ = execute(
        ["bash"],
        input="""
command cat <(
    command tail -n +1 ~/.ssh/config ~/.ssh/config.d/* /etc/ssh/ssh_config 2> /dev/null | command grep -i '^\s*host\(name\)\? ' | awk '{for (i = 2; i <= NF; i++) print $1 " " $i}' | command grep -v '[*?]') \
        <(command grep -oE '^[[a-z0-9.,:-]+' ~/.ssh/known_hosts | tr ',' '\n' | tr -d '[' | awk '{ print $1 " " $1 }') \
        <(command grep -v '^\s*\(#\|$\)' /etc/hosts | command grep -Fv '0.0.0.0') |
        awk '{if (length($2) > 0) {print $2}}' | sort -u
""",
    )
    return stdout


class fzf_select(Command):
    """
    :fzf_select
    Find a file using fzf.
    With a prefix argument to select only directories.

    See: https://github.com/junegunn/fzf
    """

    def execute(self):
        import os
        import subprocess

        from ranger.ext.get_executables import get_executables

        if "fzf" not in get_executables():
            self.fm.notify("Could not find fzf in the PATH.", bad=True)
            return

        fd = None
        if "fdfind" in get_executables():
            fd = "fdfind"
        elif "fd" in get_executables():
            fd = "fd"

        if fd is not None:
            hidden = "--hidden" if self.fm.settings.show_hidden else ""
            exclude = "--no-ignore-vcs --exclude '.git' --exclude '*.py[co]' --exclude '__pycache__'"
            only_directories = "--type directory" if self.quantifier else ""
            fzf_default_command = "{} --follow {} {} {} --color=always".format(
                fd, hidden, exclude, only_directories
            )
        else:
            hidden = (
                "-false" if self.fm.settings.show_hidden else r"-path '*/\.*' -prune"
            )
            exclude = r"\( -name '\.git' -o -name '*.py[co]' -o -fstype 'dev' -o -fstype 'proc' \) -prune"
            only_directories = "-type d" if self.quantifier else ""
            fzf_default_command = (
                "find -L . -mindepth 1 {} -o {} -o {} -print | cut -b3-".format(
                    hidden, exclude, only_directories
                )
            )

        env = os.environ.copy()
        env["FZF_DEFAULT_COMMAND"] = fzf_default_command
        env["FZF_DEFAULT_OPTS"] = (
            '--height=40% --layout=reverse --ansi --preview="{}"'.format("""
            (
                batcat --color=always {} ||
                bat --color=always {} ||
                cat {} ||
                tree -ahpCL 3 -I '.git' -I '*.py[co]' -I '__pycache__' {}
            ) 2>/dev/null | head -n 100
        """)
        )

        fzf = self.fm.execute_command(
            "fzf --no-multi", env=env, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)


class fzf_locate(Command):
    """
    :fzf_locate
    Find a file using fzf.
    With a prefix argument select only directories.
    See: https://github.com/junegunn/fzf
    """

    def execute(self):
        import subprocess

        if self.quantifier:
            command = "locate home | fzf -e -i"
        else:
            command = "locate home | fzf -e -i"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode("utf-8").rstrip("\n"))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)
