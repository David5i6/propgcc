/* db_types.h - type definitions for a simple virtual machine
 *
 * Copyright (c) 2009 by David Michael Betz.  All rights reserved.
 *
 */

#ifndef __DB_TYPES_H__
#define __DB_TYPES_H__

/**********/
/* Common */
/**********/

#define VMTRUE		1
#define VMFALSE   	0

//#define RAMSIZE             (12 * 1024)
#define RAMSIZE             (6 * 1024)
#define MAX_OBJECTS         32

/*********/
/* WIN32 */
/*********/

#ifdef WIN32

#include "db_inttypes.h"

#include <stdio.h>
#include <string.h>

#define ALIGN_MASK				3

#define FLASH_SPACE

#define VMCODEBYTE(p)           *(uint8_t *)(p)
#define VMINTRINSIC(i)          Intrinsics[i]

#endif  // WIN32

/*******/
/* MAC */
/*******/

#if defined(MAC) || defined(LINUX)

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define ALIGN_MASK				3

#define FLASH_SPACE

#define VMCODEBYTE(p)           *(uint8_t *)(p)
#define VMINTRINSIC(i)          Intrinsics[i]

#endif  // MAC

/**********/
/* XGSPIC */
/**********/

#ifdef XGSPIC

#include "FSIO.h"

#define XGS_COMMON
#define PIC_COMMON

#endif  // XGSPIC

/****************/
/* CHAMELEONPIC */
/****************/

#ifdef CHAMELEONPIC

#define PIC_COMMON

#endif  // CHAMELEONPIC

/**************/
/* PIC common */
/**************/

#ifdef PIC_COMMON

#include "db_inttypes.h"

#include <stdio.h>
#include <string.h>
#include <libpic30.h>

#ifdef PIC24
#include <p24hxxxx.h>
#endif
#ifdef dsPIC33
#include <p33fxxxx.h>
#endif

#define ALIGN_MASK				3

#define FLASH_SPACE             const

#define VMCODEBYTE(p)           *(p)                               
#define VMINTRINSIC(i)          Intrinsics[i]

#endif  // PIC_COMMON

/*********************/
/* PIC32 STARTER KIT */
/*********************/

#ifdef PIC32_STARTER_KIT

#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#define ALIGN_MASK				3

#define FLASH_SPACE             const

#define VMCODEBYTE(p)           *(p)                               
#define VMINTRINSIC(i)          Intrinsics[i]

#endif  // PIC32

/**********/
/* XGSAVR */
/**********/

#ifdef XGSAVR

#define XGS_COMMON
#define AVR_COMMON

#endif  // XGSAVR

/****************/
/* CHAMELEONAVR */
/****************/

#ifdef CHAMELEONAVR

#define AVR_COMMON

#endif  // XGSAVR

/**********/
/* AVR328 */
/**********/

#ifdef AVR328

#define AVR_COMMON

#endif  // AVR328

/**********/
/* UZEBOX */
/**********/

#ifdef UZEBOX

#define AVR_COMMON

#endif  // UZEBOX

/**************/
/* AVR common */
/**************/

#ifdef AVR_COMMON

#include <stdint.h>
#include <string.h>
#include <avr/boot.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>

#define ALIGN_MASK				1

#define FLASH_SPACE             PROGMEM

#define VMCODEBYTE(p)	        pgm_read_byte(p)
#define VMINTRINSIC(i)          ((IntrinsicFcn *)pgm_read_word(&Intrinsics[i]))

#endif  // AVR

/*****************/
/* PROPELLER_CAT */
/*****************/

#ifdef PROPELLER_CAT

#include <string.h>
#include <stdint.h>

int strcasecmp(const char *s1, const char *s2);

#define ALIGN_MASK				3

#define FLASH_SPACE

#define VMCODEBYTE(p)           *(uint8_t *)(p)
#define VMINTRINSIC(i)          Intrinsics[i]

#define PROPELLER

#endif  // PROPELLER_CAT

/*****************/
/* PROPELLER_ZOG */
/*****************/

#ifdef PROPELLER_ZOG

#include <string.h>
#include "db_inttypes.h"

int strcasecmp(const char *s1, const char *s2);

#define ALIGN_MASK				3

#define FLASH_SPACE

#define VMCODEBYTE(p)           *(uint8_t *)(p)
#define VMINTRINSIC(i)          Intrinsics[i]

#define PROPELLER

#endif  // PROPELLER_ZOG

/*****************/
/* PROPELLER_GCC */
/*****************/

#ifdef PROPELLER_GCC

#include <string.h>
#include "db_inttypes.h"

int strcasecmp(const char *s1, const char *s2);

#define ALIGN_MASK				3

#define FLASH_SPACE

#define VMCODEBYTE(p)           *(uint8_t *)(p)
#define VMINTRINSIC(i)          Intrinsics[i]

#define PROPELLER
//#define LINE_EDIT

#endif  // PROPELLER_GCC

#endif
