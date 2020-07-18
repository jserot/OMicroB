//#include <stdio.h>
/* #include <sys/alt_driver.h> */
#include <sys/alt_stdio.h>
/* #include <priv/alt_file.h> */
#include <unistd.h> // For usleep
#include "sys/alt_timestamp.h" 
#include "sys/alt_alarm.h"  // For alt_nticks()
//#include <sys/times.h> // For times()
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "system.h"  // BSP description generated by nios-bsp and located in <project>/bsp

void nios_serial_write_char(char c)
{
  alt_printf("%c", c);
}

void nios_serial_write_string(char* s)
{
  alt_printf(s);
}

/* void nios_serial_write_int(int n) */
/* { */
/*   alt_printf("%d", n); */
/* } */

char nios_serial_read_char()
{
  return alt_getchar();
}

/* static char serial_buffer[64]; */

/* char* nios_serial_read_string() */
/* { */
/*   scanf("%s", serial_buffer); */
/*   return serial_buffer; */
/* } */

static int char_to_ssd(char c)
{
	/* Convert a character binary code for a 7-segment display.
       The 7-segment has inverted logic so a 0 means the light is on and a 1 means the light is off.
       The rightmost bit starts the index at HEX#[0], and the leftmost bit is HEX#[6], the pattern
       for the 7-segment is shown in the DE0_C5 User Manual. */
  switch ( c ) {
	case '0':
		return 0b1000000;
	case '1':
		return 0b1111001;
	case '2':
		return 0b0100100;
	case '3':
		return 0b0110000;
	case '4':
		return 0b0011001;
	case '5':
	case '6':
		return 0b0000010;
	case '7':
		return 0b1111000;
	case '8':
		return 0b0000000;
	case '9':
		return 0b0010000;
	case 'A':
		return 0b0001000;
	case 'B'://Lowercase
		return 0b0000011;
	case 'C':
		return 0b1000110;
	case 'D'://Lowercase
		return 0b0100001;
	case 'E':
		return 0b0000110;
	case 'F':
		return 0b0001110;
	case 'G':
		return 0b0010000;
	case 'H':
		return 0b0001001;
	case 'I':
		return 0b1111001;
	case 'J':
		return 0b1110001;
	case 'K':
		return 0b0001010;
	case 'L':
		return 0b1000111;
	case 'N':
		return 0b0101011;
	case 'O':
		return 0b1000000;
	case 'P':
		return 0b0001100;
	case 'Q':
		return 0b0011000;
	case 'R'://Lowercase
		return 0b0101111;
	case 'S':
		return 0b0010010;
	case 'T':
		return 0b0000111;
	case 'U':
		return 0b1000001;
	case 'V':
		return 0b1100011;
	case 'X':
		return 0b0011011;
	case 'Y':
		return 0b0010001;
	case 'Z':
		return 0b0100100;
	default:
		return 0b1111111;
	}
}

void nios_ssd_display_char(int i, char c)
{
  switch ( i ) {
  case 5: IOWR_ALTERA_AVALON_PIO_DATA(HEX5_BASE, char_to_ssd(c)); break;
  case 4: IOWR_ALTERA_AVALON_PIO_DATA(HEX4_BASE, char_to_ssd(c)); break;
  case 3: IOWR_ALTERA_AVALON_PIO_DATA(HEX3_BASE, char_to_ssd(c)); break;
  case 2: IOWR_ALTERA_AVALON_PIO_DATA(HEX2_BASE, char_to_ssd(c)); break;
  case 1: IOWR_ALTERA_AVALON_PIO_DATA(HEX1_BASE, char_to_ssd(c)); break;
  case 0: IOWR_ALTERA_AVALON_PIO_DATA(HEX0_BASE, char_to_ssd(c)); break;
  default: break;
  }
}

void nios_led_set(int i, bool b)
{
  int m = IORD_ALTERA_AVALON_PIO_DATA(LED_BASE);
  if ( b ) m |= 1<<i;
  else m &= ~(1<<i);
  IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, m);
}

bool nios_switch_get(int i)
{
  int m = IORD_ALTERA_AVALON_PIO_DATA(SWITCH_BASE);
  return m & (1<<i);
}

bool nios_button_get(int i)
{
  int m = ~IORD_ALTERA_AVALON_PIO_DATA(BUTTON_BASE);  // Button pressed is 0
  return m & (1<<i);
}

static struct {
  unsigned long ticks_per_us;
  unsigned long ticks_per_ms;
} nios_timer_spec;

int nios_timer_init()
{
  int r = alt_timestamp_start();
  unsigned long ticks_per_sec = alt_timestamp_freq();
  nios_timer_spec.ticks_per_ms = ticks_per_sec / 1000;  // Pre-compute these values for limiting the RT overhead
  nios_timer_spec.ticks_per_us = ticks_per_sec / 1000000;
  return r;
}

int nios_timer_get_us()
{
  unsigned long t = alt_timestamp() / nios_timer_spec.ticks_per_us;
  return t;
}

int nios_timer_get_ms()
{
  unsigned long t = alt_timestamp() / nios_timer_spec.ticks_per_ms;
  return t;
}

void delay(int ms) { usleep(ms*1000); } 

#define TPS_SCALE_FACTOR 694 // To be adjusted

int millis()
{
  alt_u32 t = alt_nticks();
  return t*TPS_SCALE_FACTOR/alt_ticks_per_second();
}

// The following fonctions are defined just to ensure compatibility with OMicrob framework.
// They do not have a direct interpretation on NIOS.

void set_bit(uint8_t reg, uint8_t bit) { }

void clear_bit(uint8_t reg, uint8_t bit) { }

bool read_bit(uint8_t reg, uint8_t bit) { return 0; }

void write_register(uint8_t reg, uint8_t val) { }

uint8_t read_register(uint8_t reg) { return 0; }


