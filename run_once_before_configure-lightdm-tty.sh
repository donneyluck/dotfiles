#!/bin/bash
# @chezmoi: run_once_before_configure-lightdm-tty.sh
# Installs and configures lightdm-tty theme for lightdm-webkit2-greeter

set -euo pipefail

THEME_DIR="/usr/share/lightdm-webkit/themes/tty"
GREETER_CONF="/etc/lightdm/lightdm-webkit2-greeter.conf"
LIGHTDM_CONF="/etc/lightdm/lightdm.conf"

# 1. Install lightdm-webkit2-greeter if missing
if ! pacman -Q lightdm-webkit2-greeter &>/dev/null; then
    sudo pacman -S --noconfirm lightdm-webkit2-greeter
fi

# 2. Clone theme if not present
if [ ! -d "$THEME_DIR" ]; then
    sudo mkdir -p /usr/share/lightdm-webkit/themes
    sudo git clone https://github.com/eNzyOfficial/lightdm-tty.git "$THEME_DIR"
fi

# 3. Patch commands.js with custom MOTD
sudo tee "$THEME_DIR/js/commands.js" > /dev/null << 'JSEOF'
let commands = {
    login: {
        help: function(args) {
            return '<br><strong>NAME</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;login<br><br>'+
            '<strong>SYNOPSIS</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;login [USER]<br><br>'+
            '<strong>DESCRIPTION</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;Login using the given username.<br><br>';
        },

        callback: function (args) {            
            let user = this.utils.arrayOfObjectsHasKeyValue(lightdm.users, 'name', args[0]);

            if (!user) {
                this.stderr(`bash: no such user: ${args[0]}`);
                return false;
            }

            if(lightdm.in_authentication) {
                lightdm.cancel_authentication();
            }
            
            this.session = user.session !== null && user.session === this.session ? user.session : this.session;
            lightdm.start_authentication(user.name);    
            return true;
        },

        password: function(password, response) {
            if (lightdm.in_authentication) {
                setTimeout(function(){ 
                    lightdm.respond(password);
                }, 200);
    
                return null;
            }
    
            return `call login [user]<br>`;
        }
    },
    passwd: {
        help: function(args) {
            return '<br><strong>NAME</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;passwd<br><br>'+
            '<strong>SYNOPSIS</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;passwd<br><br>'+
            '<strong>DESCRIPTION</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;Login to an existing session.<br><br>';
        },

        callback: function (args) {            
            let user = this.utils.arrayOfObjectsHasKeyValue(lightdm.users, 'logged_in', true);

            if (!user) {
                this.stderr(`bash: no sessions exist`);
                return false;
            }

            if(lightdm.in_authentication) {
                lightdm.cancel_authentication();
            }
            
            this.session = user.session !== null ? user.session : lightdm.default_session;
            lightdm.start_authentication(user[0].name);
            return true;
        },

        password: function(password, response) {
            if (lightdm.in_authentication) {
                setTimeout(function(){ 
                    lightdm.respond(password);
                }, 200);
    
                return null;
            }
    
            return `call login [user]<br>`;
        }
    },
    users: {
        help: function(args) {
            return '<br><strong>NAME</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;users<br><br>'+
            '<strong>SYNOPSIS</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;users<br><br>'+
            '<strong>DESCRIPTION</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;List out all available users.<br><br>';
        },

        callback: function(args) {
            let users = '';
            
            lightdm.users.forEach(function(user) {
                users += '<span class="stdout-off-white">' + user.name + "</span><br>";
            });

            return users;
        }
    },
    ls: {
        help: function(args) {
            return '<br><strong>NAME</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;ls<br><br>'+
            '<strong>SYNOPSIS</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;ls<br><br>'+
            '<strong>DESCRIPTION</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;List out all available sessions.<br><br>';
        },

        callback: function(args) {
            sessions = '';
            
            lightdm.sessions.forEach(function(session) {
                sessions += '<span class="stdout-off-white">' + session.key + "</span><br>";
            });

            return sessions;
        }
    },
    session: {
        help: function(args) {
            return '<br><strong>NAME</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;session<br><br>'+
            '<strong>SYNOPSIS</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;session [NAME]<br><br>'+
            '<strong>DESCRIPTION</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;Set the session to login to.<br><br>';
        },

        callback: function(args) {
            let session = args[0];
            session = this.utils.arrayOfObjectsHasKeyValue(lightdm.sessions, 'key', session);

            if (!session) {
                this.stderr(`bash: no such session: ${session}`);
                return false;
            }

            this.session = session.key;
            return true;
        }
    },
    poweroff: {
        help: function(args) {
            return '<br><strong>NAME</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;poweroff<br><br>'+
            '<strong>SYNOPSIS</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;poweroff<br><br>'+
            '<strong>DESCRIPTION</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;May be used to power off the machine.<br><br>';
        },

        callback: function(args) {
            lightdm.shutdown();
            return true;
        }
    },
    reboot: {
        help: function(args) {
            return '<br><strong>NAME</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;reboot<br><br>'+
            '<strong>SYNOPSIS</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;reboot<br><br>'+
            '<strong>DESCRIPTION</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;May be used to restart the machine.<br><br>';
        },

        callback: function(args) {
            lightdm.restart();
            return true;
        }
    },
    suspend: {
        help: function(args) {
            return '<br><strong>NAME</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;suspend<br><br>'+
            '<strong>SYNOPSIS</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;suspend<br><br>'+
            '<strong>DESCRIPTION</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;May be used to suspend the machine.<br><br>';
        },

        callback: function(args) {
            lightdm.suspend();
            return true;
        }
    },
    clear: {
        help: function(args) {
            return '<br><strong>NAME</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;clear<br><br>'+
            '<strong>SYNOPSIS</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;clear<br><br>'+
            '<strong>DESCRIPTION</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;Clear the terminal screen.<br><br>';
        },

        callback: function(args) {
            this.output.innerHTML = '';
            return true;
        }
    },
    help: {
        callback: function(args) {
            let keys = this.commands.keys();
            let stdout = '';

            for (var i in keys) {
                stdout += `${keys[i]}&emsp;&emsp;&emsp;`;
            };

            return stdout + "<br>";
        }
    },
    man: {
        help: function(args) {
            return '<br><strong>NAME</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;man<br><br>'+
            '<strong>SYNOPSIS</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;man [COMMAND]<br><br>'+
            '<strong>DESCRIPTION</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;A refence manual to give information about a specific command.<br><br>';
        },

        callback: function(args) {
            let keys = this.commands.keys();
            let stdin = args[0];
            let stdout = '';
            let stderr = `<span class="stdout-red">No manual entry for ${stdin}<br>`;

            if(this.utils.isEmpty(stdin)) {
                return '<span class="stdout-red">What manual page do you want?</span><br>';
            }

            if (this.commands.exists(stdin)) {
                let command = this.commands.get(stdin);
                
                if (this.utils.hasProperty(command, 'help')) {
                    stdout += command['help']();
                }
                else {
                    console.log("man");
                    return stderr;
                }
            } else {
                return stderr;
            }

            return stdout;
        }
    },
    motd: {
        help: function(args) {
            return '<br><strong>NAME</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;motd<br><br>'+
            '<strong>SYNOPSIS</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;motd<br><br>'+
            '<strong>DESCRIPTION</strong><br>'+
            '&nbsp;&nbsp;&nbsp;&nbsp;Display the current motd<br><br>';
        },

        callback: function(args) {
            return "&nbsp;██░&nbsp;██&nbsp;▓█████&nbsp;&nbsp;██▓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;██▓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;▒█████&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;█&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;█░&nbsp;▒█████&nbsp;&nbsp;&nbsp;██▀███&nbsp;&nbsp;&nbsp;██▓&nbsp;&nbsp;&nbsp;&nbsp;▓█████▄&nbsp;<br>"+
            "▓██░&nbsp;██▒▓█&nbsp;&nbsp;&nbsp;▀&nbsp;▓██▒&nbsp;&nbsp;&nbsp;&nbsp;▓██▒&nbsp;&nbsp;&nbsp;&nbsp;▒██▒&nbsp;&nbsp;██▒&nbsp;&nbsp;&nbsp;▓█░&nbsp;█&nbsp;░█░▒██▒&nbsp;&nbsp;██▒▓██&nbsp;▒&nbsp;██▒▓██▒&nbsp;&nbsp;&nbsp;&nbsp;▒██▀&nbsp;██▌<br>"+
            "▒██▀▀██░▒███&nbsp;&nbsp;&nbsp;▒██░&nbsp;&nbsp;&nbsp;&nbsp;▒██░&nbsp;&nbsp;&nbsp;&nbsp;▒██░&nbsp;&nbsp;██▒&nbsp;&nbsp;&nbsp;▒█░&nbsp;█&nbsp;░█&nbsp;▒██░&nbsp;&nbsp;██▒▓██&nbsp;░▄█&nbsp;▒▒██░&nbsp;&nbsp;&nbsp;&nbsp;░██&nbsp;&nbsp;&nbsp;█▌<br>"+
            "░▓█&nbsp;░██&nbsp;▒▓█&nbsp;&nbsp;▄&nbsp;▒██░&nbsp;&nbsp;&nbsp;&nbsp;▒██░&nbsp;&nbsp;&nbsp;&nbsp;▒██&nbsp;&nbsp;&nbsp;██░&nbsp;&nbsp;&nbsp;░█░&nbsp;█&nbsp;░█&nbsp;▒██&nbsp;&nbsp;&nbsp;██░▒██▀▀█▄&nbsp;&nbsp;▒██░&nbsp;&nbsp;&nbsp;&nbsp;░▓█▄&nbsp;&nbsp;&nbsp;▌<br>"+
            "░▓█▒░██▓░▒████▒░██████▒░██████▒░&nbsp;████▓▒░&nbsp;&nbsp;&nbsp;░░██▒██▓&nbsp;░&nbsp;████▓▒░░██▓&nbsp;▒██▒░██████▒░▒████▓&nbsp;<br>"+
            "&nbsp;▒&nbsp;░░▒░▒░░&nbsp;▒░&nbsp;░░&nbsp;▒░▓&nbsp;&nbsp;░░&nbsp;▒░▓&nbsp;&nbsp;░░&nbsp;▒░▒░▒░&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;▓░▒&nbsp;▒&nbsp;&nbsp;░&nbsp;▒░▒░▒░&nbsp;░&nbsp;▒▓&nbsp;░▒▓░░&nbsp;▒░▓&nbsp;&nbsp;░&nbsp;▒▒▓&nbsp;&nbsp;▒&nbsp;<br>"+
            "&nbsp;▒&nbsp;░▒░&nbsp;░&nbsp;░&nbsp;░&nbsp;&nbsp;░░&nbsp;░&nbsp;▒&nbsp;&nbsp;░░&nbsp;░&nbsp;▒&nbsp;&nbsp;░&nbsp;&nbsp;░&nbsp;▒&nbsp;▒░&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;▒&nbsp;░&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;▒&nbsp;▒░&nbsp;&nbsp;&nbsp;░▒&nbsp;░&nbsp;▒░░&nbsp;░&nbsp;▒&nbsp;&nbsp;░&nbsp;░&nbsp;▒&nbsp;&nbsp;▒&nbsp;<br>"+
            "&nbsp;░&nbsp;&nbsp;░░&nbsp;░&nbsp;&nbsp;&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;░&nbsp;&nbsp;&nbsp;░&nbsp;░&nbsp;░&nbsp;▒&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;&nbsp;&nbsp;░&nbsp;&nbsp;░&nbsp;░&nbsp;░&nbsp;▒&nbsp;&nbsp;&nbsp;&nbsp;░░&nbsp;&nbsp;&nbsp;░&nbsp;&nbsp;&nbsp;░&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;░&nbsp;&nbsp;░&nbsp;<br>"+
            "&nbsp;░&nbsp;&nbsp;░&nbsp;&nbsp;░&nbsp;&nbsp;&nbsp;░&nbsp;&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;<br>"+
            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;░&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>";
        }
    }
}
JSEOF

# 4. Configure webkit2 greeter to use tty theme
if grep -q "^webkit_theme\b" "$GREETER_CONF" 2>/dev/null; then
    sudo sed -i 's/^webkit_theme[[:space:]]*=.*/webkit_theme        = tty/' "$GREETER_CONF"
else
    echo "webkit_theme = tty" | sudo tee -a "$GREETER_CONF" > /dev/null
fi

# 5. Set greeter-session to webkit2
if grep -q "^greeter-session=" "$LIGHTDM_CONF" 2>/dev/null; then
    sudo sed -i 's/^greeter-session=.*/greeter-session=lightdm-webkit2-greeter/' "$LIGHTDM_CONF"
else
    echo "greeter-session=lightdm-webkit2-greeter" | sudo tee -a "$LIGHTDM_CONF" > /dev/null
fi

echo "✓ lightdm-tty configured. Log out or reboot to see the new login screen."
