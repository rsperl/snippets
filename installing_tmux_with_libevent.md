install libevent first

When compiling tmux, use the following options (assuming libevent was installed with `prefix=$HOME/apps`):

    DIR=$HOME/apps
    ./configure CFLAGS="-I$DIR/include" LDFLAGS="-L$DIR/lib" --prefix=$HOME/apps
    make && make install

if curses isn't found, you may have to add an extra LDFLAGS:

    ./configure CFLAGS="-$d/include" LDFLAGS="-L$d/lib -L/lib64 -L/usr/openv/pdde/pdopensource/lib" --prefix=/data/sfw/tmux-1.9a

I had to set `LD_LIBRARY_PATH` to `$HOME/apps/lib` and `MANPATH=$HOME/apps/share/man` for tmux to find libevent and for the man pages to work.

On mac, I had to pass `-lresolv` to the linker (`LDFLAGS="-lresolv -L$DIR/lib"`)
