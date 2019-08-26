#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *constellation(double x, double y) {

  // convert to 240ths of a degree
  x *= 240;
  y *= 240;

if ((y <= 7360 && ((x <= 12120 && 140*x + 117*y >= 2230320) || (140*x + \
117*y <= 2230320 && 140*x + 171*y >= 2476560))) || (y >= 4560 && 4*x + 17*y \
<= 126000 && 24*x + 97*y >= 726000) || (305700 + 41*x >= 90*y && ((y >= 6540 \
&& x <= 8700) || (x >= 6900 && 35400 + 34*x <= 45*y))) || (402000 + 68*x >= \
135*y && ((y >= 6000 && 35400 + 34*x <= 45*y) || (4*x + 17*y >= 126000 && \
140*x + 171*y <= 2476560))) || (x <= 11820 && 24*x + 97*y <= 726000 && 181*x \
+ 291*y >= 2832000) || (y >= 2380 && ((181*x + 60*y >= 1446000 && 181*x + \
291*y <= 2832000) || (x >= 6000 && 181*x + 60*y <= 1446000)))) {return \
    "ARI";}

  return "";

}

int main(int argc, char **argv) {

  int i, j;

  // testing: I know 25, 25 is in ARI

  for (i = 0; i <= 180; i++) {
    for (j = -90; j <= 90; j++) {
      printf("%d %d %s\n", i, j, constellation(i,j));
    }
  }
}





