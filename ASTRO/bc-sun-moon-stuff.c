/* determines moon/sun rise/set/twilight times */

// the angular separation from zenith of a given body at a given time
// in a given place; because I plan to feed this routine to gfq, most
// "parameters" are global

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "SpiceUsr.h"
#include "SpiceZfc.h"
// this the wrong way to do things
#include "/home/barrycarter/BCGIT/ASTRO/bclib.h"

// TODO: add this to bclib.h

void isDecreasing(void(* udfuns)(SpiceDouble et,SpiceDouble *value),
		  SpiceDouble et, SpiceBoolean *isdecr) {
  SpiceDouble res1, res2;
  udfuns(et-1, &res1);
  udfuns(et+1, &res2);
  *isdecr = (res2 < res1);
}

int main(int argc, char **argv) {

  SPICEDOUBLE_CELL(result, 10);
  SPICEDOUBLE_CELL(cnfine,2);
  SpiceDouble beg, end;

  furnsh_c("/home/barrycarter/BCGIT/ASTRO/standard.tm");

  // we are testing with fixed lat/lon
  SpiceDouble fixedlat = 35.05*rpd_c();
  SpiceDouble fixedlon = -106.5*rpd_c();

  // the function that gives the value we want
  void testf1(SpiceDouble et, SpiceDouble *value) {
    *value = altitude(10, et, fixedlat, fixedlon);
  }

  // today
  wninsd_c(unix2et(1554962400),unix2et(1554962400+86400*1),&cnfine);

  gfuds_c(testf1, isDecreasing, "=", 0., 0., 60., 100, &cnfine,&result);
  SpiceInt count = wncard_c( &result );

  for (int i=0; i<count; i++) {
    wnfetd_c(&result,i,&beg,&end);
    printf("0deg %f %f\n",et2unix(beg),et2unix(end));
  }

  return 0;

}

