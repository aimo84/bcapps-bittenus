(* formulas start here *)

vol2sd[v_,t_] = Sqrt[t]*Log[1+v];

(* this is only accurate for x>0 *)

cdf[v_,t_,x_] = Simplify[CDF[HalfNormalDistribution[1/vol2sd[v,t]]][x],x>0]

sol[v_,t_,p_,s_] = s/Exp[x /. Solve[cdf[v,t,x]==1-p,x][[1]]]

(* formulas end here *)

(*

http://quant.stackexchange.com/questions/24970/estimate-probability-of-limit-order-execution-over-a-large-time-frame

<h1>My Answer</h1>

You should set your limit order to: $s (v+1)^{-0.0314192 \sqrt{t}}$
where $s$ is the current price, $t$ is the time in years you're
willing to wait, and $v$ is the annual volatility as a percentage.

If you want to be $p$ percent sure (instead of 0.98), set your limit
order to:

$s (v+1)^{-\sqrt{\pi } \sqrt{t} \text{erf}^{-1}(1-p)}$

Of course, this is based on many assumptions and disclaimers later in
this message.

<h1>Other Answers</h1>

It turns out this question has been studied extensively, and there are
some papers on it:

http://fiquant.mas.ecp.fr/wp-content/uploads/2015/10/Limit-Order-Book-modelling.pdf

http://arxiv.org/pdf/1311.5661

I'll use a much simpler model (see disclaimers at end of message).

<h1>Example</h1>

If a stock has a volatility of 15%, that means there's a 68% chance
it's price after 1 year will be between 87% and 115% of its current
price. Note that the lower limit is 87% (= 1/1.15), not 85%.

Overall, the price probability for a stock with volatility 15% forms
this bell curve:

[[image11.gif]]

Note that:

  - Because volatility is inherently based on logrithms, the tick
  marks aren't evenly numbered, and aren't symmetric. For example, the
  numbers +65% and -39% are symmetric because it takes a 39% loss to
  offset a 65% gain and vice versa. In other words: `(1+
  (-39/100))*(1+ (65/100))` is approximately one.

  - The parenthesized numbers under the x axis (for this and the
  following graphs) refer to change in the logarithm of the security's
  price. These *are* evenly numbered and we will use them in the
  "General Case" section.

  - The labels on the y axis are relative to each other and don't
  refer to percentages.

Of course, this isn't the probability curve you're looking for: I drew
it just for reference.

Instead, let's look at the probability distribution of the *minimum*
value over the next year for our 15% volatility stock.

[[image12.gif]]

The same caveats apply to this graph as the previous one.

Suppose you set your limit order at 5% below the current price (ie,
95% of its current price). There is a ~77% chance your order will be
filled:

[[image13.gif]]

You can also see this using the cumulative distribution function (CDF):

[[image14.gif]]

In this case, the y values do represent percentages, namely the
cumulative percentage change that the stock's lowest value will the
percentage value on the x axis.

For this volatility, if you want be 98% sure you order is filled, you
could only set your limit order to 0.44% below the current price.

<h1>General Case</h1>

Of course, that was for a specific volatility over a specific period
of time.

In general, a volatility of v% means the stock is ~68% (1 standard
deviation) likely to remain within v% of its current price in the next
year. More conveniently, it means the logarithm of the price is 68%
likely to remain within (plus/minus) $\log (v+1)$ of its current value
(within the next year). For example, a volatility of 15% means the log
of the stock price is 68% likely to remain within .1398 of its current
value, since $e^{0.1398}$ is approximately $1.15$

More generally, the $\log (\text{price})$ one year from now has a
normal distribution with mean $\log (\text{price})$ and standard
deviation $\log (v+1)$.

Thus, the *change* in the $\log (\text{price})$ for one year is
normally distributed with a mean of 0 and a standard deviation of
$\log (v+1)$.

A standard deviation of $\log (v+1)$ translates to a variance of $\log
^2(v+1)$. Since the variance of a process like this scales linearlly,
the variance for $t$ years is given by $t \log ^2(v+1)$ and the
standard deviation for $t$ years is given by $\sqrt{t} \log (v+1)$.

Thus, the change in $\log (\text{price})$ for time $t$ has a normal
distribution with mean 0 and standard deviation $\sqrt{t} \log (v+1)$.

As noted below in another section, this means the minimum (most
negative) value of this change has a halfnormal distribution with
parameter $\frac{1}{\sqrt{t} \log (v+1)}$

The cumulative distribution of a halfnormal distribution with
parameter $\frac{1}{\sqrt{t} \log (v+1)}$ evaluted at x>0 (the only
place the halfnormal distribution is non-zero) is:

$\text{erf}\left(\frac{x}{\sqrt{\pi } \sqrt{t} \log (v+1)}\right)$

where erf() is the standard error function.

Note that when we draw this cumulative distribution for volatility 15%
above, letting the x axis be "change in $\log (\text{price})$ (instead
of the percentage change in price), the x axis looks more like we
expect.

If our limit order is $\lambda$% of the current price (meaning it's
$\lambda s$ where $s$ is the current price), it will only be hit if
the $\log (\text{price})$ moves more than $\left| \log (\lambda )
\right|$ (note that we need the absolute values since we're measuring
the absolute change in $\log (\text{price})$, which is always
positive). The chance of that happening is:

$
   1-\text{erf}\left(\frac{\left| \log (\lambda ) \right|}{\sqrt{\pi } \sqrt{t}
    \log (v+1)}\right)
$

Note that we need the "1-" since we're looking for the probability the
$\log (\text{price})$ moves *more* than the given amount.

Of course, in this case, we're *given* the probability and asked to
solve for the limit price. Using $p$ as the probability we find:

$\lambda \to (v+1)^{-\sqrt{\pi } \sqrt{t} \text{erf}^{-1}(1-p)}$

and the price is thus:

$s (v+1)^{-\sqrt{\pi } \sqrt{t} \text{erf}^{-1}(1-p)}$

as in the answer section. Substituting 0.98 for p, we have:

$s (v+1)^{-0.0314192 \sqrt{t}}$

as noted for this specific example.

<h1>Research and "derivation"</h1>

It turns out this is a well-known problem and has been studied extensively:

  - It's the running maximum/minimum of Brownian motion:
  https://en.wikipedia.org/wiki/Brownian_motion also known as a Wiener
  process
  (https://en.wikipedia.org/wiki/Wiener_process#Running_maximum)

  - Item 37 of http://www.math.uah.edu/stat/brown/Standard.html
  establishes this maximum is the halfnormal distribution:
  https://en.wikipedia.org/wiki/Half-normal_distribution

  - This stackexchange/google search shows many more results:

https://stackexchange.com/search?q=brownian+halfnormal

  - It can also be regarded as the running maximum value of a random walk:

https://stackexchange.com/search?q=brownian+halfnormal

  - Or as the fair value of a one-touch option: http://www.investopedia.com/terms/o/onetouchoption.asp:

http://quant.stackexchange.com/questions/17083

http://quant.stackexchange.com/questions/235

  - I myself wrote two questions to help answer this question, one
  asking about a random walk and the other about what turns out to be
  Brownian motion:

    - https://mathematica.stackexchange.com/questions/110565

    - https://mathematica.stackexchange.com/questions/110657

If you use Mathematica (or just want to read even more about this subject),
you might look at my:

  - https://github.com/barrycarter/bcapps/blob/master/STACK/bc-stock-min.m

  - https://github.com/barrycarter/bcapps/blob/master/box-option-value.m

the latter of which computes the probability that a stock price will
be between two given values at two given times (ie, the fair value of
an O&A "box option") but can be used to answer your question in the
limiting case. See also: http://money.stackexchange.com/questions/4312

<h1>Disclaimers and Notices</h1>

I made several simplifying assumptions above:

  - As noted in the references given in "Other Answers" above, the
  more a stock's price decreases, the less likely it is to decrease
  further. Why? Other people place limit orders, and the further down
  the stock gets from its starting price, the more limit orders will
  be triggered.  Generally, the *volume* of limit orders *also*
  increases as the stock price goes down. In other words, the limit
  orders act as a "buffer", slowing the rate at which a stock's price
  drops. The simple model I use does not account for this.

  - Conversely, I also ignore the "volatility smile", which suggests
  the exact opposite: that a larger change in price is *more* likely
  than what the normal distribution would yield, which means that
  extreme prices are more likely that those given by the halfnormal
  distribution.

  - The two points above aren't necessarily contradictory: under
  normal conditions, the "limit order book" buffers price changes, but
  during unusual circumstances (such as major news), the price can
  change dramatically.

  - I also assume that once a stock reaches your limit price, your
  order will be triggered. However, if there are several orders at
  that price, the larger orders will trigger first, and the stock
  price may rise again before your limit order is triggered at all.

  - Since this is a limit order and not an option, the risk-free
  interest rate is not an issue: I assume you earn the risk-free
  interest rate until the order is filled.

  - If you don't earn the risk-free interest rate while waiting, note
  that the small gain you get from the limit order may be offset by
  the loss of interest.

<h1>Items Not Appearing in This Answer</h1>

Although the inverse error function is well known and "easy" to
compute, I was going to include an approximation, but felt that might
exceed the scope of the question.

(*

http://quant.stackexchange.com/questions/24970/estimate-probability-of-limit-order-execution-over-a-large-time-frame

https://mathematica.stackexchange.com/questions/110565/closed-form-probability-random-walk-will-hit-k-1-times-in-n-steps

Subject: Closed form probability random walk will hit k >=1 times in n steps

I'm using Mathematica to try to solve
http://quant.stackexchange.com/questions/24970 and came across what
seems like a simple question: if you take a standard random walk of
`n` steps, what is the formula for the probability you'll touch `+k`
at least once. More generically, what's the probability distribution
of a random walk of `n` steps.

I can compute this chance using a recursive formula:

<pre><code>
c[n_,0] := 1
c[0, k_] := 0
c[n_,k_] := c[n,k] = 1/2*(c[n-1,k-1] + c[n-1,k+1])
</code></pre>

but Mathematica won't `RSolve` it:

<pre><code>
RSolve[{f[n,0] == 1, f[0,k] == 0, f[n,k] == 1/2*(f[n-1,k-1]+f[n-1,k+1])},
 f[n,k], {n,k}]
</code></pre>

returns unevaluated. I'm not too surprised, since Mathematica isn't
that good with two variable recursion.

However, I'm convinced there's a "simple" formula here, or at least a
good approximation for large `n`.

I did try a few different things to no avail:

  - Trying to find a formula for specific values of `n` or `k`.

  - Using `Log` to see if this was an exponential distribution of some sort.

  - Comparing it to the right half of the normal distribution.

  - Trying to find a formula for the interpolation, since the function
  itself is somewhat "juddery" (ie, f(x+1) = f(x) in many cases).

I'm convinced I can use Pascal's triangle (ie, the binomial theorem
and Mathematica's `Binomial` function) to resolve this, but can't
quite figure out how.

==== CUT HERE ====

Subject: Distribution of max of partial sums of normal distributions

I was surprised not to find this question already answered: if I take
the maximum of the partial sums of `n` normal distributions, what is
the resulting distribution?

I know that http://math.stackexchange.com/questions/68553 "solves"
this in general, but I'm hoping for a simpler form for the normal
distribution.

<pre><code>
t[n_] := t[n] = Histogram[
 Table[Max[Accumulate[Table[RandomVariate[NormalDistribution[]],{i,n}]]],
 {j,1,100000}]];
</code></pre>

The code above convinces me the resulting distribution isn't normal
(except for n=1 of course), although it looks somewhat normal for low
values of `n`.

*)

image11.gif:

xtics = Table[{i, 
 If[i>0,"+",""]<>ToString[Round[100*(Exp[i]-1),1]]<>"%\n("<>ToString[i]<>")"},
 {i,-.5,.5,.05}]

Plot[
 PDF[NormalDistribution[0,Log[1.15]]][x]/
 PDF[NormalDistribution[0,Log[1.15]]][0], 
 {x,-0.5,+0.5}, PlotRange->All,
 TicksStyle -> Directive[Black,12],
 Ticks -> {xtics, Automatic}
]
showit

image12.gif:

xtics2 = Table[{i, 
 ToString[Round[100*(Exp[-i]-1),1]]<>"%\n("<>ToString[-i]<>")"},
 {i,0,.5,.025}]

Plot[PDF[HalfNormalDistribution[1/Log[1.15]]][x]/(2/Pi/Log[1.15]),
 {x,0,0.5},
 TicksStyle -> Directive[Black,10],
 Ticks -> {xtics2, Automatic}
]
showit

image13.gif:

graph[x_] = PDF[HalfNormalDistribution[1/Log[1.15]]][x]/(2/Pi/Log[1.15])

xtics2 = Table[{i, 
 ToString[Round[100*(Exp[-i]-1),1]]<>"%\n("<>ToString[-i]<>")"},
 {i,0,.5,.025}]

plot1 = Plot[graph[x], {x,0,0.05}, TicksStyle -> Directive[Black,10],
 Ticks -> {xtics2, Automatic}, AxesOrigin -> {0,0}
]

plot2 = Plot[graph[x], {x,0.05,0.5}, TicksStyle -> Directive[Black,10],
 Ticks -> {xtics2, Automatic}, AxesOrigin -> {0,0}, Filling -> Axis
]

line = Graphics[{
 Line[{{0.05,0},{0.05, graph[0.05]}}],
 Text[Style["77%", FontSize->100], {0.16,.25}],
 Rotate[Text[Style["23%", FontSize->100], {0.025, .5}],Pi/2]
}
];

Show[{plot2,plot1,line}, PlotRange -> All]
showit

image14.gif:

graph[x_] = CDF[HalfNormalDistribution[1/Log[1.15]]][x]

xtics2 = Table[{i, 
 ToString[Round[100*(Exp[-i]-1),1]]<>"%\n("<>ToString[-i]<>")"},
 {i,0,.5,.025}]

ytics2 = Table[{i, 
 ToString[ToString[Round[i*100]]<>"% "]}, {i,0,1,.1}]

plot2 = Plot[graph[x], {x,0,0.5}, TicksStyle -> Directive[Black,10],
 Ticks -> {xtics2, ytics2}, AxesOrigin -> {0,0}]

line = Graphics[{
 RGBColor[1,0,0], Dashed,
 Line[{{0.05,0},{0.05, graph[0.05]}}],
 Line[{{0,graph[0.05]},{0.05, graph[0.05]}}],
 Text[Style["23%", FontSize-> 30], {0.025,.26}],
 Text[Style["-5%", FontSize-> 30], {0.073,.1}]
}
];

Show[{plot2,line}, PlotRange -> All]
showit

TODO: examples? (did not provide sample values for v other than given)
