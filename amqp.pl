%% AMQP library for SWI-Prolog

%% First: a grammar for the wire protocol. This is from the AMQP specification.
% amqp                = protocol-header *amqp-unit 
% protocol-header     = literal-AMQP protocol-id protocol-version 
% literal-AMQP        = %d65.77.81.80             ; "AMQP" 
% protocol-id         = %d0                       ; Must be 0 
% protocol-version    = %d0.9.1                   ; 0-9-1 
% method              = method-frame [ content ] 
% method-frame        = %d1 frame-properties method-payload frame-end 
% frame-properties    = channel payload-size 
% channel             = short-uint                ; Non-zero 
% payload-size        = long-uint 
% method-payload      = class-id method-id *amqp-field 
% class-id            = %x00.01-%xFF.FF 
% method-id           = %x00.01-%xFF.FF 
% amqp-field          = BIT / OCTET 
%                     / short-uint / long-uint / long-long-uint 
%                     / short-string / long-string 
%                     / timestamp 
%                     / field-table 
% short-uint          = 2*OCTET                   
% long-uint           = 4*OCTET                   
% long-long-uint      = 8*OCTET                   
% short-string        = OCTET *string-char        ; length + content 
% string-char         = %x01 .. %xFF 
% long-string         = long-uint *OCTET          ; length + content 
% timestamp           = long-long-uint            ; 64-bit POSIX 
% field-table         = long-uint *field-value-pair 
% field-value-pair    = field-name field-value 
% field-name          = short-string
% field-value         = 't' boolean
%                     / 'b' short-short-int
%                     / 'B' short-short-uint
%                     / 'U' short-int
%                     / 'u' short-uint
%                     / 'I' long-int
%                     / 'i' long-uint
%                     / 'L' long-long-int
%                     / 'l' long-long-uint
%                     / 'f' float
%                     / 'd' double
%                     / 'D' decimal-value
%                     / 's' short-string
%                     / 'S' long-string
%                     / 'A' field-array
%                     / 'T' timestamp
%                     / 'F' field-table
%                     / 'V'                       ; no field 
% boolean             = OCTET                     ; 0 = FALSE, else TRUE 
% short-short-int     = OCTET 
% short-short-uint    = OCTET 
% short-int           = 2*OCTET                   
% long-int            = 4*OCTET                   
% long-long-int       = 8*OCTET                   
% float               = 4*OCTET                   ; IEEE-754 
% double              = 8*OCTET                   ; rfc1832 XDR double
% decimal-value       = scale long-uint
% scale               = OCTET                     ; number of decimal digits
% field-array         = long-int *field-value     ; array of values
% frame-end           = %xCE 
% content             = %d2 content-header *content-body 
% content-header      = frame-properties header-payload frame-end 
% header-payload      = content-class content-weight content-body-size 
%                       property-flags property-list 
% content-class       = OCTET 
% content-weight      = %x00 
% content-body-size   = long-long-uint 
% property-flags      = 15*BIT %b0 / 15*BIT %b1 property-flags 
% property-list       = *amqp-field 
% content-body        = %d3 frame-properties body-payload frame-end 
% body-payload        = *OCTET 
% heartbeat           = %d8 %d0 %d0 frame-end

