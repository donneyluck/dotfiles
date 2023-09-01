if status is-interactive
    # Commands to run in interactive sessions can go here
end

#if test -f /home/donney/.autojump/share/autojump/autojump.fish; . /home/donney/.autojump/share/autojump/autojump.fish; end
if test -f /usr/share/fish/functions/autojump.fish; . /usr/share/fish/functions/autojump.fish; end

export EDITOR=vim
export HTTP_PROXY='127.0.0.1:7890'
export HTTPS_PROXY='127.0.0.1:7890'
export ALL_PROXY='socks5://127.0.0.1:7891'
export TERM=xterm;

alias ll 'ls -la'
alias cd.. 'cd ..'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias unset 'set --erase'
alias genpasswd "strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo"
alias busy "cat /dev/urandom | hexdump -C | grep 'ca fe'"

for host in (awk '/^Host/{if ($2!="*") print $2}' ~/.ssh/config)
  alias $host="ssh $host"
end

#function open -d "open dir use nautilus"
#   nohup nautilus -w $argv[1] > /dev/null 2>&1 &
#end

function open -d "open dir use pcmanfm"
   pcmanfm > /dev/null 2&>1
end

function proxy_on -d "open proxy"
  export http_proxy='127.0.0.1:7890'
  export https_proxy='127.0.0.1:7890'
  export ALL_PROXY='socks5://127.0.0.1:7891'
  echo -e "proxy on"
end

function proxy_off -d "close proxy"
  unset http_proxy
  unset https_proxy
  unset ALL_PROXY
  echo -e "proxy off"
end

function proxy_update -d "update proxy"
    wget -U "Mozilla/6.0" -O ~/.config/clash/config.yaml "https://to.runba.cyou/link/aLULMn4fDIB5trPa?clash=1"
end

function makescript
  history | head -1 > $argv[1]
end

function sbs
  du -b --max-depth 1 | sort -nr | perl -pe 's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e'
end

function mcd -d "mkdir and enter"
  mkdir -p $argv[1]
  cd $argv[1]
end

function cll -d "cd and ll"
      cd $argv[1]
      ll
end

function backup
  cp $argv[1]{,.bak}
end

function sshlist
  for host in (awk '/^Host/{if ($2!="*") print $2}' ~/.ssh/config)
    #set_color red
    set_color green
    echo -n $host
    set_color normal
    rg $host ~/.ssh/config -A2 | awk '/^\s*HostName/{if ($2 != "*") printf " -> IP: %s",$2}'
    rg $host ~/.ssh/config -A2 | awk '/^\s*IdentityFile/{if ($2 != "*") printf " -> ID_FILE: %s",$2}'
    echo ""
  end
end

function wtf -d "Print which and --version output for the given command"
    for arg in $argv
        echo $arg: (which $arg)
        echo $arg: (sh -c "$arg --version")
    end
end

function ranger-cd
  set tempfile '/tmp/chosendir'
  /usr/bin/ranger --choosedir=$tempfile (pwd)

  if test -f $tempfile
      if [ (cat $tempfile) != (pwd) ]
        cd (cat $tempfile)
      end
  end

  rm -f $tempfile

end

function fish_user_key_bindings
    bind \co 'ranger-cd ; fish_prompt'
end

thefuck --alias | source
