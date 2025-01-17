(*

The area swept out from the focus of an ellipse is:

$
   b \left(a \theta -b \sin (\theta ) \sqrt{\frac{(a-b) (a+b)}{a^2 \cos
    ^2(\theta )+b^2 \sin ^2(\theta )}}\right)
$

where $\theta$ is the **central** angle, $a$ is the semimajor axis,
and $b$ is the semiminor axis.

This is actually a simplified version of a portion of @MvG's answer,
and a bit of a cheat, since you normally wouldn't have the central
angle, but I believe the derivation (below) might be useful to some.

The area swept out from the center of an ellipse is $a b \theta$ where
$\theta$ is the central angle, $a$ is the semimajor axis, and $b$ is
the semiminor axis:

[[image1]]

To find the area from the focus, we simply subtract off this purple triangle:

[[image2]]

The distance from the center of an ellipse to either focus is
$\sqrt{a^2-b^2}$ giving us the base of this triangle.

To find the height, we start by knowing two things about $(x,y)$:

  - Since an ellipse can be parametrized as $(a \cos (t),b \sin (t))$,
  we know that:

$\{x=a \cos (t),y=b \sin (t)\}$

for some value of $t$. Note that $t\neq \theta$.

  - Because it's on an origin-crossing line whose slope is $\tan (\theta )$:

$\frac{y}{x}=\tan (\theta )$

Combining the two equations, we have:

$\frac{b \sin (t)}{a \cos (t)}=\tan (\theta )$

Solving for t:

$t=\tan ^{-1}(a \cos (\theta ),b \sin (\theta ))$

Note that we must use the two argument form of $tan ^{-1} ()$ to make
sure $t$ is in the correct quadrant.

Plugging back in for $x$ and $y$ and applying trignometric identities
and other simplifications:

$x=\frac{a^2 \cos (\theta )}{\sqrt{a^2 \cos ^2(\theta )+b^2 \sin ^2(\theta )}}$

$y=\frac{b^2 \sin (\theta )}{\sqrt{a^2 \cos ^2(\theta )+b^2 \sin ^2(\theta )}}$

We now have the height of the triangle, $y$, as above. Apply the area
formula gives us:

$b^2 \sin (\theta ) \sqrt{\frac{(a-b) (a+b)}{a^2 \cos ^2(\theta )+b^2 \sin
^2(\theta )}}$

Subtracting that from the original $a b \theta$, we get:

$
   b \left(a \theta -b \sin (\theta ) \sqrt{\frac{(a-b) (a+b)}{a^2 \cos
    ^2(\theta )+b^2 \sin ^2(\theta )}}\right)
$


*)

a*b*theta

t[theta_] = ArcTan[a*Cos[theta],b*Sin[theta]]

Plot[t[theta],{theta,0,2*Pi}]

ParametricPlot[{a*Cos[t[theta]],b*Sin[t[theta]]}, {theta,0,2*Pi}]


x = (a*b)/Sqrt[b^2 + a^2*Tan[theta]^2]

y = (a*b*Tan[theta])/Sqrt[b^2 + a^2*Tan[theta]^2]

tri[theta_] = (a*b*Sqrt[a^2 -b^2]*Abs[Tan[theta]])/(2*Sqrt[b^2 +
a^2*Tan[theta]^2]);

area[theta_] = a*b*theta - (a*b*Sqrt[a^2 -
b^2]*Abs[Tan[theta]])/(2*Sqrt[b^2 + a^2*Tan[theta]^2]);

a=2; b=1.9;

ang = 45*Degree;

ang = 95*Degree;

f = Sqrt[a^2-b^2];

g1 = Graphics[{
 RGBColor[{1,0,0,0.1}],
 Disk[{0,0}, {a,b}, {0,ang}],
 RGBColor[{0,0,0, 1}],
 PointSize[.02],
 Point[{a*Cos[ang], b*Sin[ang]}],
 Text[Style["(x,y)", FontSize->50], {a*Cos[ang], b*Sin[ang]}, {-1,-1}],
 Text[Style["\[Theta]", Large], {a/7.5,b/15}],
 Text[Style["\[Theta]ab", FontSize->50], {1,0.5}, {-1,0}],
 Text[Style["a", FontSize->50], {1,-0.1}],
 Text[Style["b", FontSize->50], {-0.1,0.5}],
 Circle[{0,0}, {a,b}],
 Circle[{0,0}, a/10., {0,ArcTan[a*Cos[ang], b*Sin[ang]]}],
 Line[{{-a,0}, {0,0}}],
 Line[{{0,-b}, {0,0}}],
 Arrowheads[{-.02,.02}],
 Arrow[{{0,0}, {a,0}}],
 Arrow[{{0,0}, {0,b}}],
 RGBColor[{1,0,0}],
 Line[{{0,0}, {a*Cos[ang], b*Sin[ang]}}],
}]

Show[g1]
showit

g2 = Graphics[{
 RGBColor[{0,0,1,0.2}], EdgeForm[RGBColor[{1,0,1,1}]],
 Polygon[{{0,0}, {f, 0}, {a*Cos[ang], b*Sin[ang]}}],
 RGBColor[{0,0,0,1}],
 PointSize[.02],
 Point[{f,0}],
 Text[Style["F", FontSize->50], {f,0}, {0,1}]
}]

Show[g1,g2]
showit

g3 = Graphics[{
 RGBColor[{0,0,0, 1}],
 Text[Style["\[Theta]", Large], {a/7.5,b/15}],
 Text[Style["a", FontSize->50], {1,-0.1}],
 Text[Style["b", FontSize->50], {-0.1,0.5}],
 Circle[{0,0}, {a,b}],
 Circle[{0,0}, a/10., {0,ArcTan[a*Cos[ang], b*Sin[ang]]}],
 Line[{{-a,0}, {0,0}}],
 Line[{{0,-b}, {0,0}}],
 Arrowheads[{-.02,.02}],
 Arrow[{{0,0}, {a,0}}],
 Arrow[{{0,0}, {0,b}}],
 RGBColor[{1,0,0}],
 Line[{{0,0}, {a*Cos[ang], b*Sin[ang]}}],
 RGBColor[{0,0,1,0.2}], EdgeForm[RGBColor[{1,0,1,1}]],
 Polygon[{{0,0}, {f, 0}, {a*Cos[ang], b*Sin[ang]}}],
 RGBColor[{0,0,0,1}],
 PointSize[.02],
 Point[{f,0}],
 Text[Style["F", FontSize->50], {f,0}, {0,1}]
}];

Show[g3]
showit

