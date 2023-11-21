{ pkgs, hyprland, ... }: {
  systemd.user.sessionVariables = {
    "NIXOS_OZONE_WL" = "1"; # for any ozone-based browser & electron apps to run on wayland
    "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
    "MOZ_WEBRENDER" = "1";

    # for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/
    "LIBVA_DRIVER_NAME" = "nvidia";
    "XDG_SESSION_TYPE" = "wayland";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "WLR_EGL_NO_MODIFIRES" = "1";
  };


  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    extraConfig = ''
      monitor = eDP-1, 1920x1080, 0x0, 1

      $mod = SUPER
      bind = $mod, Return, exec, alacritty
      bind = $mod, B, exec, google-chrome-stable
      bind = $mod, Q, killactive

      bind = $mod, F, fullscreen

      bind = ALT, H, movefocus, l
      bind = ALT, J, movefocus, d
      bind = ALT, K, movefocus, u
      bind = ALT, L, movefocus, d

      bind = $mod, H, workspace, -1
      bind = $mod, L, workspace, +1
      bind = $mod SHIFT, H, movetoworkspace, -1
      bind = $mod SHIFT, L, movetoworkspace, +1

      bind = $mod, F, fullscreen, 0
      bind = $mod, S, togglefloating

      # switch workspace
      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4
      bind = $mod, 5, workspace, 5
      bind = $mod, 6, workspace, 6
      bind = $mod, 7, workspace, 7
      bind = $mod, 8, workspace, 8
      bind = $mod, 9, workspace, 9
      bind = $mod, 0, workspace, 10

      bind = $mod SHIFT, 1, movetoworkspace, 1
      bind = $mod SHIFT, 2, movetoworkspace, 2
      bind = $mod SHIFT, 3, movetoworkspace, 3
      bind = $mod SHIFT, 4, movetoworkspace, 4
      bind = $mod SHIFT, 5, movetoworkspace, 5
      bind = $mod SHIFT, 6, movetoworkspace, 6
      bind = $mod SHIFT, 7, movetoworkspace, 7
      bind = $mod SHIFT, 8, movetoworkspace, 8
      bind = $mod SHIFT, 9, movetoworkspace, 9
      bind = $mod SHIFT, 0, movetoworkspace, 10

      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow

      bindle = , XF86MonBrightnessUp,   exec, light -A 10
      bindle = , XF86MonBrightnessDown, exec, light -U 10
      bindle = , XF86AudioRaiseVolume,  exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindle = , XF86AudioLowerVolume,  exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%
      bind   = , XF86AudioMute,         exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle
      bind   = , XF86AudioMicMute,      exec, ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle

      bind = $mod, P, exec, wofi --show drun

      bind = $mod, I, exec, swww img --transition-type any --transition-fps 60 ~/wallpapers/dj-dark.png
      bind = $mod, O, exec, swww img --transition-type any --transition-fps 60 ~/wallpapers/dj-light.png

      bind = ALT CTRL, H, exec, wtype -m alt -m ctrl -P Left
      bind = ALT CTRL, J, exec, wtype -m alt -m ctrl -P Down
      bind = ALT CTRL, K, exec, wtype -m alt -m ctrl -P Up
      bind = ALT CTRL, L, exec, wtype -m alt -m ctrl -P Right

      general {
          gaps_in = 3
          gaps_out = 2
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)
      }

      decoration {
          rounding = 5
          blur {
              enabled = yes
              size = 3
              passes = 1
              new_optimizations = on
          }
          drop_shadow = no
      }

      animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 1, default
      }

      input {
        kb_layout = us, ru
        kb_options = ctrl:nocaps, grp:win_space_toggle

        touchpad {
          natural_scroll = true
        }

        follow_mouse = 1
      }

      gestures {
        workspace_swipe = true
      }

      # autostart
      exec-once = swww init
      exec-once = waybar &
    '';
  };

  programs = {
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          "position" = "top";
          "layer" = "top";

          "modules-left" = [
            "custom/launcher"
            "temperature"
            "wlr/workspaces"
          ];
          "modules-center" = [
            "custom/playerctl"
          ];
          "modules-right" = [
            "mpd"
            "pulseaudio"
            "backlight"
            "memory"
            "cpu"
            "network"
            "clock"
            "custom/powermenu"
            "tray"
          ];
          "wlr/workspaces" = {
            "format" = "{icon}";
            "on-click" = "activate";
            "format-icons" = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "6" = "";
              "7" = "";
              "8" = "";
              "9" = "";
              "10" = "〇";
              "focused" = "";
              "default" = "";
            };
          };

          "clock" = {
            "interval" = 60;
            "align" = 0;
            "rotate" = 0;
            "tooltip-format" = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
            "format" = " {:%H:%M}";
            "format-alt" = " {:%a %b %d; %G}";
          };
          "cpu" = {
            "format" = "�� {usage}%";
            "interval" = 1;
          };
          "custom/launcher" = {
            "format" = " ";
            "on-click" = "$HOME/.config/hypr/scripts/menu";
            "on-click-middle" = "exec default_wall";
            "on-click-right" = "exec wallpaper_random";
            "tooltip" = false;
          };
          "custom/powermenu" = {
            "format" = "";
            "on-click" = "$HOME/.config/hypr/scripts/wlogout";
            "tooltip" = false;
          };
          "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {
              "activated" = "";
              "deactivated" = "";
            };
            "tooltip" = false;
          };
          "memory" = {
            "format" = "�� {percentage}%";
            "interval" = 1;
            "states" = {
              "warning" = 85;
            };
          };
          "mpd" = {
            "interval" = 2;
            "unknown-tag" = "N/A";
            "format" = "{stateIcon} {artist} - {title}";
            "format-disconnected" = " Disconnected";
            "format-paused" = "{stateIcon} {artist} - {title}";
            "format-stopped" = "Stopped ";
            "state-icons" = {
              "paused" = "";
              "playing" = "";
            };
            "tooltip-format" = "MPD (connected)";
            "tooltip-format-disconnected" = "MPD (disconnected)";
            "on-click" = "mpc toggle";
            "on-click-middle" = "mpc prev";
            "on-click-right" = "mpc next";
            "on-update" = "";
            "on-scroll-up" = "mpc seek +00:00:01";
            "on-scroll-down" = "mpc seek -00:00:01";
            "smooth-scrolling-threshold" = 1;
          };
          "custom/playerctl" = {
            "format" = "{icon}  <span>{}</span>";
            "return-type" = "json";
            "max-length" = 55;
            "exec" = "playerctl -a metadata #format '{\"text\": \"  {{markup_escape(title)}}\"; \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
            "on-click-middle" = "playerctl previous";
            "on-click" = "playerctl play-pause";
            "on-click-right" = "playerctl next";
            "format-icons" = {
              "Paused" = "<span foreground='#6dd9d9'></span>";
              "Playing" = "<span foreground='#82db97'></span>";
            };
          };
          "network" = {
            "interval" = 5;
            #"interface" = "wlan*"; // (Optional) To force the use of this interface, set it for netspeed to work
            "format-wifi" = " {essid}";
            "format-ethernet" = " {ipaddr}/{cidr}";
            "format-linked" = " {ifname} (No IP)";
            "format-disconnected" = "睊 Disconnected";
            "format-disabled" = "睊 Disabled";
            "format-alt" = " {bandwidthUpBits} |  {bandwidthDownBits}";
            "tooltip-format" = " {ifname} via {gwaddr}";
          };
          "pulseaudio" = {
            #"format" = "{volume}% {icon} {format_source}";
            "format" = "{icon} {volume}%";
            "format-muted" = " Mute";
            "format-bluetooth" = " {volume}% {format_source}";
            "format-bluetooth-muted" = " Mute";
            "format-source" = " {volume}%";
            "format-source-muted" = "";
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [
                ""
                ""
                ""
              ];
            };
            "scroll-step" = 5.0;
            # Commands to execute on events
            "on-click" = "amixer set Master toggle";
            "on-click-right" = "pavucontrol";
            "smooth-scrolling-threshold" = 1;
          };
          "temperature" = {
            "format" = " {temperatureC}°C";
            "tooltip" = false;
          };
          "tray" = {
            "icon-size" = 15;
            "spacing" = 5;
          };
        };
      };
      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 12pt;
          font-weight: bold;
          border-radius: 8px;
          transition-property: background-color;
          transition-duration: 0.5s;
        }
        @keyframes blink_red {
          to {
            background-color: rgb(242, 143, 173);
            color: rgb(26, 24, 38);
          }
        }
        .warning,
        .critical,
        .urgent {
          animation-name: blink_red;
          animation-duration: 1s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
        window#waybar {
          background-color: transparent;
        }
        window > box {
          margin-left: 5px;
          margin-right: 5px;
          margin-top: 5px;
          background-color: #1e1e2a;
          padding: 3px;
          padding-left: 8px;
          border: 2px none #33ccff;
        }
        #workspaces {
          padding-left: 0px;
          padding-right: 4px;
        }
        #workspaces button {
          padding-top: 5px;
          padding-bottom: 5px;
          padding-left: 6px;
          padding-right: 6px;
        }
        #workspaces button.active {
          background-color: rgb(181, 232, 224);
          color: rgb(26, 24, 38);
        }
        #workspaces button.urgent {
          color: rgb(26, 24, 38);
        }
        #workspaces button:hover {
          background-color: rgb(248, 189, 150);
          color: rgb(26, 24, 38);
        }
        tooltip {
          background: rgb(48, 45, 65);
        }
        tooltip label {
          color: rgb(217, 224, 238);
        }
        #custom-launcher {
          font-size: 20px;
          padding-left: 8px;
          padding-right: 6px;
          color: #7ebae4;
        }
        #mode,
        #clock,
        #memory,
        #temperature,
        #cpu,
        #mpd,
        #custom-wall,
        #temperature,
        #backlight,
        #pulseaudio,
        #network,
        #battery,
        #custom-powermenu {
          padding-left: 10px;
          padding-right: 10px;
        }

        /* #mode { */
        /* 	margin-left: 10px; */
        /* 	background-color: rgb(248, 189, 150); */
        /*     color: rgb(26, 24, 38); */
        /* } */
        #memory {
          color: rgb(181, 232, 224);
        }
        #cpu {
          color: rgb(245, 194, 231);
        }
        #clock {
          color: rgb(217, 224, 238);
        }
        /* #idle_inhibitor {
                         color: rgb(221, 182, 242);
                       }*/
        #custom-wall {
          color: #33ccff;
        }
        #temperature {
          color: rgb(150, 205, 251);
        }
        #backlight {
          color: rgb(248, 189, 150);
        }
        #pulseaudio {
          color: rgb(245, 224, 220);
        }
        #network {
          color: #abe9b3;
        }
        #network.disconnected {
          color: rgb(255, 255, 255);
        }
        #custom-powermenu {
          color: rgb(242, 143, 173);
          padding-right: 8px;
        }
        #tray {
          padding-right: 8px;
          padding-left: 10px;
        }
        #mpd.paused {
          color: #414868;
          font-style: italic;
        }
        #mpd.stopped {
          background: transparent;
        }
        #mpd {
          color: #c0caf5;
        }
      '';
    };
  };


}
