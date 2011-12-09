/* Test the `vqRshrun_ns32' ARM Neon intrinsic.  */
/* This file was autogenerated by neon-testgen.  */

/* { dg-do assemble } */
/* { dg-require-effective-target arm_neon_ok } */
/* { dg-options "-save-temps -O0" } */
/* { dg-add-options arm_neon } */

#include "arm_neon.h"

void test_vqRshrun_ns32 (void)
{
  uint16x4_t out_uint16x4_t;
  int32x4_t arg0_int32x4_t;

  out_uint16x4_t = vqrshrun_n_s32 (arg0_int32x4_t, 1);
}

/* { dg-final { scan-assembler "vqrshrun\.s32\[ 	\]+\[dD\]\[0-9\]+, \[qQ\]\[0-9\]+, #\[0-9\]+!?\(\[ 	\]+@\[a-zA-Z0-9 \]+\)?\n" } } */
/* { dg-final { cleanup-saved-temps } } */