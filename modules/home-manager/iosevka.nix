{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config = {
    packageOverrides = super: let
      self = super.pkgs;
    in {
      iosevka-legible = self.iosevka.override {
        set = "Legible";
        privateBuildPlan = ''
[buildPlans.IosevkaLegible]
family = "IosevkaLegible"
spacing = "fixed"
serifs = "sans"
noCvSs = true
exportGlyphNames = false

[buildPlans.IosevkaLegible.variants]
inherits = "ss15"

[buildPlans.IosevkaLegible.variants.design]
one = "no-base"
two = "curly-neck-serifless"
four = "closed-non-crossing-serifless"
five = "upright-arched-serifless"
six = "closed-contour"
seven = "straight-serifless"
eight = "two-circles"
nine = "closed-contour"
zero = "slashed-split"
capital-a = "round-top-serifless"
capital-k = "curly-serifless"
capital-n = "standard-serifless"
capital-q = "crossing-baseline"
capital-v = "curly-serifless"
capital-w = "straight-vertical-sides-serifless"
capital-x = "curly-serifless"
capital-y = "curly-serifless"
capital-z = "curly-serifless"
a = "double-storey-serifless"
f = "serifless"
g = "single-storey-serifless"
i = "zshaped"
j = "serifed"
k = "curly-serifless"
l = "zshaped"
m = "short-leg-serifless"
r = "serifless"
t = "bent-hook"
v = "curly-serifless"
w = "straight-vertical-sides-serifless"
x = "curly-serifless"
y = "cursive-serifless"
z = "curly-serifless"
paren = "large-contour"
brace = "curly-flat-boundary"
number-sign = "slanted"
at = "threefold"
dollar = "through"
percent = "rings-continuous-slash"
question = "smooth"
decorative-angle-brackets = "middle"
lig-neq = "slightly-slanted"

[buildPlans.IosevkaLegible.weights.Regular]
shape = 400
menu = 400
css = 400

[buildPlans.IosevkaLegible.weights.Bold]
shape = 700
menu = 700
css = 700

[buildPlans.IosevkaLegible.weights.Medium]
shape = 500
menu = 500
css = 500

[buildPlans.IosevkaLegible.widths.Normal]
shape = 500
menu = 5
css = "normal"

[buildPlans.IosevkaLegible.widths.SemiExtended]
shape = 548
menu = 6
css = "semi-expanded"

[buildPlans.IosevkaLegible.slopes.Upright]
angle = 0
shape = "upright"
menu = "upright"
css = "normal"

[buildPlans.IosevkaLegible.slopes.Italic]
angle = 9.4
shape = "italic"
menu = "italic"
css = "italic"
        '';
      };
    };
  };
}
