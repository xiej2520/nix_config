{ pkgs, inputs, ... }:
{
  # import the home manager module
  imports = [
    inputs.noctalia.homeModules.default
  ];


  # noctalia-shell ipc call state all > dotfiles/noctalia-state.json
  programs.noctalia-shell = {
    enable = true;
    #settings = { };
    # this may also be a string or a path to a JSON file.
    #settings = ./noctalia-settings.json;
    # ~/.config/noctalia/settings.json
  };
}
# ~/.config/noctalia/colorschemes/custom/custom.json
#{
#    "dark": {
#        "mPrimary": "#F878FF",
#        "mOnPrimary": "#1E1E22",
#        "mSecondary": "#A090F0",
#        "mOnSecondary": "#1E1E22",
#        "mTertiary": "#3CD357",
#        "mOnTertiary": "#161616",
#        "mError": "#EE5365",
#        "mOnError": "#161616",
#        "mSurface": "#161616",
#        "mOnSurface": "#F2F4F8",
#        "mHover": "#F85EB4",
#        "mOnHover": "#161616",
#        "mSurfaceVariant": "#262626",
#        "mOnSurfaceVariant": "#DDE1E6",
#        "mOutline": "#525252",
#        "mShadow": "#000000"
#    }
#}
#