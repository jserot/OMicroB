(* type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7
         | PIN8 | PIN9 | PIN10 | PIN11 | PIN12 | PIN13 | PIN14
         | PIN15 | PIN16 | PIN17 | PIN18 | PIN19 | PIN20 | PIN21
         | PIN22 | PIN23 | PIN24 | PIN25 | PIN26 | PIN27 | PIN28
         | PIN29 | PIN30 | PIN31 | PIN32
         | MISO | SCK | MOSI | SS
         | PINA0 | PINA1 | PINA2 | PINA3 | PINA4 | PINA5 | PINA6
         | PINA7 | PINA8 | PINA9 | PINA10 | PINA11 | PINA12
type _pin = pin

type mode = INPUT | OUTPUT | INPUT_PULLUP
type _mode = mode

type level = LOW | HIGH
type _level = level

external pin_mode: pin -> mode -> unit = "caml_pic32_pin_mode" [@@noalloc]
external digital_write: pin -> level -> unit = "caml_pic32_digital_write" [@@noalloc]
external digital_read: pin -> level = "caml_pic32_digital_read" [@@noalloc]
external unsafe_analog_write: pin -> int -> unit = "caml_pic32_analog_write" [@@noalloc]
external lchip_digital_write_lled: level -> unit = "caml_lchip_digital_write_lled" [@@noalloc]
external lchip_digital_write_rled: level -> unit = "caml_lchip_digital_write_rled" [@@noalloc]

let analog_write p l =
  if (l < 0 || l >= 1024) then invalid_arg "analog_write: value should be between 0 and 1023";
  unsafe_analog_write p l

external unsafe_analog_read: pin -> int = "caml_pic32_analog_read" [@@noalloc]

let analog_read p =
  if (p <> PINA0 && p <> PINA1 && p <> PINA2 && p <> PINA3 && p <> PINA4 && p <> PINA5 && p <> PINA6 &&
      p <> PINA7 && p <> PINA8 && p <> PINA9 && p <> PINA10 && p <> PINA11 && p <> PINA12) then invalid_arg "analog_write: only pin PINA0 to PINA12 are supported";
  unsafe_analog_read p

external delay: int -> unit = "caml_pic32_delay" [@@noalloc]
external millis: unit -> int = "caml_pic32_millis" [@@noalloc]

external _init: unit -> unit = "caml_pic32_init" [@@noalloc]
external schedule_task: unit -> unit = "caml_pic32_schedule_task" [@@noalloc]

module Serial = struct
  external init: unit -> unit = "caml_pic32_serial_init" [@@noalloc]

  external write_char: char -> unit = "caml_pic32_serial_write_char" [@@noalloc]
  let write s = String.iter write_char s

  external read_char: unit -> char = "caml_pic32_serial_read_char" [@@noalloc]
  let read () =
    let s = ref ""
    and c = ref (read_char ()) in
    while((int_of_char !c) <> 0) do
      s := (!s^(String.make 1 !c));
      c := (read_char ())
    done;
    if(String.length !s > 0) then String.sub !s 0 ((String.length !s)-1) else ""
end

module MCUConnection = struct
  type pin = _pin
  type mode = _mode
  type level = _level
  let low = LOW
  let high = HIGH
  let input_mode = INPUT
  let output_mode = OUTPUT
  let digital_read = digital_read
  let digital_write = digital_write
  let analog_read = analog_read
  let analog_write = analog_write
  let pin_mode = pin_mode
  let delay = delay
  let millis = millis
end *)



type level = HIGH | LOW
type _level = level

type mode = INPUT | OUTPUT
type _mode = mode

type bit = B0 | B1 | B2 | B3 | B4 | B5 | B6 | B7  
         | B8 | B9 | B10 | B11 | B12 | B13 | B14 | B15 
         | B16 | B17 | B18 | B19 | B20 | B21 | B22 | B23 
         | B24 | B25 | B26 | B27 | B28 | B29 | B30 | B31

type register = TRISA | TRISB | TRISC | TRISD | TRISE | TRISF | TRISG
              | LATA | LATB | LATC | LATD | LATE | LATF | LATG
              | PORTA | PORTB | PORTC | PORTD | PORTE | PORTF | PORTG


external write_register : register -> int -> unit = "caml_pic32_write_register" [@@noalloc]
external read_register : register -> int = "caml_pic32_read_register" [@@noalloc]
external set_bit : register -> bit -> unit = "caml_pic32_set_bit" [@@noalloc]
external clear_bit : register -> bit -> unit = "caml_pic32_clear_bit" [@@noalloc]
external read_bit : register -> bit -> bool = "caml_pic32_read_bit" [@@noalloc]
external delay : int -> unit = "caml_pic32_delay" [@@noalloc]
external millis : unit -> int = "caml_pic32_millis" [@@noalloc]



module FubarinoMiniPins = struct
  type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7
           | PIN8 | PIN9 | PIN10 | PIN11 | PIN12 | PIN13 | PIN14
           | PIN15 | PIN16 | PIN17 | PIN18 | PIN19 | PIN20 | PIN21
           | PIN22 | PIN23 | PIN24 | PIN25 | PIN26 | PIN27 | PIN28
           | PIN29 | PIN30 | PIN31 | PIN32

  type _pin = pin

  let port_of_pin = function
    | PIN0 -> PORTB
    | PIN1 -> PORTA
    | PIN2 -> PORTA
    | PIN3 -> PORTB
    | PIN4 -> PORTB
    | PIN5 -> PORTA
    | PIN6 -> PORTA
    | PIN7 -> PORTB
    | PIN8 -> PORTB
    | PIN9 -> PORTB
    | PIN10 -> PORTB
    | PIN11 -> PORTC
    | PIN12 -> PORTC
    | PIN13 -> PORTC
    | PIN14 -> PORTA
    | PIN15 -> PORTA
    | PIN16 -> PORTA
    | PIN17 -> PORTB
    | PIN18 -> PORTA
    | PIN19 -> PORTA
    | PIN20 -> PORTC
    | PIN21 -> PORTC
    | PIN22 -> PORTC
    | PIN23 -> PORTB
    | PIN24 -> PORTB
    | PIN25 -> PORTB
    | PIN26 -> PORTB
    | PIN27 -> PORTC
    | PIN28 -> PORTC
    | PIN29 -> PORTC
    | PIN30 -> PORTC
    | PIN31 -> PORTB
    | PIN32 -> PORTB

  let lat_of_pin = function
    | PIN0 -> LATB
    | PIN1 -> LATA
    | PIN2 -> LATA
    | PIN3 -> LATB
    | PIN4 -> LATB
    | PIN5 -> LATA
    | PIN6 -> LATA
    | PIN7 -> LATB
    | PIN8 -> LATB
    | PIN9 -> LATB
    | PIN10 -> LATB
    | PIN11 -> LATC
    | PIN12 -> LATC
    | PIN13 -> LATC
    | PIN14 -> LATA
    | PIN15 -> LATA
    | PIN16 -> LATA
    | PIN17 -> LATB
    | PIN18 -> LATA
    | PIN19 -> LATA
    | PIN20 -> LATC
    | PIN21 -> LATC
    | PIN22 -> LATC
    | PIN23 -> LATB
    | PIN24 -> LATB
    | PIN25 -> LATB
    | PIN26 -> LATB
    | PIN27 -> LATC
    | PIN28 -> LATC
    | PIN29 -> LATC
    | PIN30 -> LATC
    | PIN31 -> LATB
    | PIN32 -> LATB


  let tris_of_pin = function
    | PIN0 -> TRISB
    | PIN1 -> TRISA
    | PIN2 -> TRISA
    | PIN3 -> TRISB
    | PIN4 -> TRISB
    | PIN5 -> TRISA
    | PIN6 -> TRISA
    | PIN7 -> TRISB
    | PIN8 -> TRISB
    | PIN9 -> TRISB
    | PIN10 -> TRISB
    | PIN11 -> TRISC
    | PIN12 -> TRISC
    | PIN13 -> TRISC
    | PIN14 -> TRISA
    | PIN15 -> TRISA
    | PIN16 -> TRISA
    | PIN17 -> TRISB
    | PIN18 -> TRISA
    | PIN19 -> TRISA
    | PIN20 -> TRISC
    | PIN21 -> TRISC
    | PIN22 -> TRISC
    | PIN23 -> TRISB
    | PIN24 -> TRISB
    | PIN25 -> TRISB
    | PIN26 -> TRISB
    | PIN27 -> TRISC
    | PIN28 -> TRISC
    | PIN29 -> TRISC
    | PIN30 -> TRISC
    | PIN31 -> TRISB
    | PIN32 -> TRISB

  let bit_of_pin = function
    | PIN0 -> B13
    | PIN1 -> B10
    | PIN2 -> B7
    | PIN3 -> B14
    | PIN4 -> B15
    | PIN5 -> B0
    | PIN6 -> B1
    | PIN7 -> B0
    | PIN8 -> B1
    | PIN9 -> B2
    | PIN10 -> B3
    | PIN11 -> B0
    | PIN12 -> B1
    | PIN13 -> B2
    | PIN14 -> B2
    | PIN15 -> B3
    | PIN16 -> B8
    | PIN17 -> B4
    | PIN18 -> B4
    | PIN19 -> B9
    | PIN20 -> B3
    | PIN21 -> B4
    | PIN22 -> B5
    | PIN23 -> B5
    | PIN24 -> B7
    | PIN25 -> B8
    | PIN26 -> B9
    | PIN27 -> B6
    | PIN28 -> B7
    | PIN29 -> B8
    | PIN30 -> B9
    | PIN31 -> B10
    | PIN32 -> B11

  let pin_mode p m =
    let tris = tris_of_pin p in 
    let bit = bit_of_pin p in
    match m with
      | OUTPUT -> clear_bit tris bit
      | INPUT -> set_bit tris bit

  let digital_write p l = 
    let lat = lat_of_pin p in 
    let bit = bit_of_pin p in
    match l with
      | HIGH -> set_bit lat bit
      | LOW -> clear_bit lat bit

  let digital_read p =
    let port = port_of_pin p in 
    let bit = bit_of_pin p in 
    match read_bit port bit with
    | true -> HIGH
    | false -> LOW

  module MCUConnection = struct
    type pin = _pin
    type mode = _mode 
    type level = _level
    let high = HIGH
    let low = LOW
    let input_mode = INPUT
    let output_mode = OUTPUT
    let digital_read = digital_read
    let digital_write = digital_write
    let delay = delay
    let millis = millis
  end
end



module LchipPins = struct
    type pin = PIN1 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7 | PIN8 | PIN9 | PIN10 | PIN11
           | PIN12 | PIN14 | PIN17 | PIN18 | PIN19 | PIN20 | PIN21 | PIN22 | PIN23 
           | PIN24 | PIN25 | PIN26 | PIN27 | PIN28 | PIN29 | PIN32 | PIN33 | PIN34
           | PIN35 | PIN38 | PIN39 | PIN40 | PIN41 | PIN42 | PIN43 | PIN44 | PIN47
           | PIN48 | PIN49 | PIN50 | PIN51 | PIN52 | PIN53 | PIN56 | PIN57 | PIN58
           | PIN59 | PIN60 | PIN61 | PIN63 | PIN64 | PIN66 | PIN67 | PIN68 | PIN69
           | PIN70 | PIN71 | PIN72 | PIN73 | PIN74 | PIN76 | PIN77 | PIN78 | PIN79
           | PIN80 | PIN81 | PIN82 | PIN83 | PIN84 | PIN87 | PIN88 | PIN89 | PIN90
           | PIN91 | PIN92 | PIN93 | PIN94 | PIN95 | PIN96 | PIN97 | PIN98 | PIN99
           | PIN100

    type _pin = pin

    let port_of_pin = function
      | PIN1 -> PORTG
      | PIN3 -> PORTE
      | PIN4 -> PORTE
      | PIN5 -> PORTE
      | PIN6 -> PORTC
      | PIN7 -> PORTC
      | PIN8 -> PORTC
      | PIN9 -> PORTC
      | PIN10 -> PORTC
      | PIN11 -> PORTC
      | PIN12 -> PORTC
      | PIN14 -> PORTC
      | PIN17 -> PORTA
      | PIN18 -> PORTE
      | PIN19 -> PORTE
      | PIN20 -> PORTB
      | PIN21 -> PORTB
      | PIN22 -> PORTB
      | PIN23 -> PORTB
      | PIN24 -> PORTB
      | PIN25 -> PORTB
      | PIN26 -> PORTB
      | PIN27 -> PORTB
      | PIN28 -> PORTA
      | PIN29 -> PORTA
      | PIN32 -> PORTB
      | PIN33 -> PORTB
      | PIN34 -> PORTB
      | PIN35 -> PORTB
      | PIN38 -> PORTA
      | PIN39 -> PORTF
      | PIN40 -> PORTF
      | PIN41 -> PORTB
      | PIN42 -> PORTB
      | PIN43 -> PORTB
      | PIN44 -> PORTB
      | PIN47 -> PORTD
      | PIN48 -> PORTD
      | PIN49 -> PORTF
      | PIN50 -> PORTF
      | PIN51 -> PORTF
      | PIN52 -> PORTF
      | PIN53 -> PORTF
      | PIN56 -> PORTG
      | PIN57 -> PORTG
      | PIN58 -> PORTA
      | PIN59 -> PORTA
      | PIN60 -> PORTA
      | PIN61 -> PORTA
      | PIN63 -> PORTC
      | PIN64 -> PORTC
      | PIN66 -> PORTA
      | PIN67 -> PORTA
      | PIN68 -> PORTD
      | PIN69 -> PORTD
      | PIN70 -> PORTD
      | PIN71 -> PORTD
      | PIN72 -> PORTD
      | PIN73 -> PORTC
      | PIN74 -> PORTC
      | PIN76 -> PORTD
      | PIN77 -> PORTD
      | PIN78 -> PORTD
      | PIN79 -> PORTD
      | PIN80 -> PORTD
      | PIN81 -> PORTD
      | PIN82 -> PORTD
      | PIN83 -> PORTD
      | PIN84 -> PORTD
      | PIN87 -> PORTF
      | PIN88 -> PORTF
      | PIN89 -> PORTG
      | PIN90 -> PORTC
      | PIN91 -> PORTA
      | PIN92 -> PORTA
      | PIN93 -> PORTE
      | PIN94 -> PORTE
      | PIN95 -> PORTG
      | PIN96 -> PORTG
      | PIN97 -> PORTG
      | PIN98 -> PORTE
      | PIN99 -> PORTE
      | PIN100 -> PORTE


end