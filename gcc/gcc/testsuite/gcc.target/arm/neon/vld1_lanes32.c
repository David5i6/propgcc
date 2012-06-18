/* Test the `vld1_lanes32' ARM Neon intrinsic.  */
/* This file was autogenerated by neon-testgen.  */

/* { dg-do assemble } */
/* { dg-require-effective-target arm_neon_ok } */
/* { dg-options "-save-temps -O0" } */
/* { dg-add-options arm_neon } */

#include "arm_neon.h"

void test_vld1_lanes32 (void)
{
  int32x2_t out_int32x2_t;
  int32x2_t arg1_int32x2_t;

  out_int32x2_t = vld1_lane_s32 (0, arg1_int32x2_t, 1);
}

/* { dg-final { scan-assembler "vld1\.32\[ 	\]+((\\\{\[dD\]\[0-9\]+\\\[\[0-9\]+\\\]\\\})|(\[dD\]\[0-9\]+\\\[\[0-9\]+\\\])), \\\[\[rR\]\[0-9\]+\\\]!?\(\[ 	\]+@\[a-zA-Z0-9 \]+\)?\n" } } */
/* { dg-final { cleanup-saved-temps } } */
