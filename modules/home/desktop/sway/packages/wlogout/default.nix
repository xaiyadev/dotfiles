{ pkgs, ... }:

{
  programs.wlogout = {
    enable = true;

    # took https://github.com/ArtsyMacaw/wlogout/blob/master/style.css
    # and replaced the colors with rose pine colors
    style = ''
      * {
      	background-image: none;
      	box-shadow: none;
      }

      window {
      	background-color: rgba(25, 23, 36, 0.8);
      }

      button {
        border-radius: 0;
        border-color: black;
      	text-decoration-color: rgb(224, 222, 244);
        color: rgb(224, 222, 244);
      	background-color: rgb(31, 29, 46);
      	border-style: solid;
      	border-width: 1px;
      	background-repeat: no-repeat;
      	background-position: center;
      	background-size: 25%;
      }

      button:focus, button:active, button:hover {
      	background-color: rgb(25, 23, 36);
      	outline-style: none;
      }
    '';

  };
}