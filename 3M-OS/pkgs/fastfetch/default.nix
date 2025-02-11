{
  programs.fastfetch = {
    enable = true;

    settings = {
      display = {
        color = {
          keys = "35";
          output = "90";
        };
      };

  "logo"= {
       source = ./extras/ashleygun.png;
       type = "kitty-direct";
       height = 15;
       width = 30;
       padding = {
         top = 3;
         left = 3;
      };
  };
  
  modules = [
      "break"
      {
          type = "custom";
          format = "\u001b[90m┌──────────────────────Hardware──────────────────────┐";
      }
      {
          type = "cpu";
          key = "│ ";
      }
      {
          type = "gpu";
          key = "│ 󰍛";
      }
      {
          type = "memory";
          key = "│ 󰑭";
      }
      {
          type = "custom";
          format = "\u001b[90m└────────────────────────────────────────────────────┘";
      }
      "break"
      {
          type = "custom";
          format = "\u001b[90m┌──────────────────────Software──────────────────────┐";
      }
      {
          type = "custom";
          format = "\u001b[31m OS -> MadManMo";
      }
      {
          type = "kernel";
          key = "│ ├";
      }
      {
          type = "packages";
          key = "│ ├󰏖";
      }
      {
          type = "shell";
          key = "└ └";
      }
      "break"
      {
          type = "wm";
          key = " WM";
      }
      {
          type = "wmtheme";
          key = "│ ├󰉼";
      }
      {
          type = "terminal";
          key = "└ └";
      }
      {
          type = "custom";
          format = "\u001b[90m└────────────────────────────────────────────────────┘";
      }
      "break"
      {
          type = "custom";
          format = "\u001b[90m┌────────────────────Uptime / Age────────────────────┐";
      }
      {
          type = "command";
          key = "│ 󰭧";
          text = #bash
	  "
	  birth_install=$(stat -c %W /)
	  current=$(date +%s)
	  time_progression=$((current - birth_install))
	  days_difference=$((time_progression / 86400))
	  echo $delta_days days
	  ";
      }
      {
          type = "uptime";
          key = "│ ";
      }
      {
          type = "custom";
          format = "\u001b[90m└────────────────────────────────────────────────────┘";
      }
      "break"
   ];
  };
 };
}
