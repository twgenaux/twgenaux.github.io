---
title: ASTM and Character Encodings
category: how-to
author: typora.io
tags: [YAML, metadata, tags]
typora-root-url: ../../
---



ASTM E1394


> 1 Scope
> 1.1 ...  It enables any two such systems to establish a logical link *for communicating text* to send result, request, or demographic information in a standard and interpretable form. 
>
> 1.2 ...  A separate specification is available from ASTM detailing *a standard for low-level data transfer communications* (see Specification E 1381).
>
> 1.3  ... It is *applicable to all text oriented clinical instrumentation*. 
>
> 5 Message Content—General Considerations 
> 5.1 Character Codes
> All data shall be represented as eight-bit, single-byte, coded graphic character values as defined in ISO 8859-1:198V.1 The eight-bit values, within the range from 0 to 127 of ISO 8859-1:19871 correspond to the ASCII standard character set. Values from 0 to 31 are disallowed with the exception of 7 (BEL), 9 (Horizontal tab), 11 (Vertical tab), and 13 (CR), where 13 is reserved as a record terminator. Values from 32 to 126 and from 128 to 254 are allowed. Values 127 and 255 are also not allowed. It is the responsibility of the instrument vendor and information system vendor to understand the representation of any extended or alternate character set being used. As an example, the numeric value 13.5 would be sent as four-byte value characters 13.5 or Latin-1(49), Latin-l(51), Latin-1(46), and Latin-1(53).
>
> Allowed Characters:	7, 9, 11, 12, 13, 32 to 126,128 to 254
> Disallowed Characters: 0 to 6, 8, 10, 14 to 31, 127,255
>
> Within text data fields, only the Latin-1 characters 32 to 126 and the undefined characters 128 to 254 are permitted as usable characters (excluding those used as delimiter characters in a particular transmission). Furthermore, all characters used as delimiters in a particular transmission are excluded from the permitted range. The sender is responsible for screening all text data fields to ensure that the text does not contain those delimiters. Unless otherwise stated, contents of data fields shall be case sensitive.

1. All data shall be represented as eight-bit, single-byte, coded graphic character values as defined in ISO 8859-1:198V.1 
2. The eight-bit values, within the range from 0 to 127 of ISO 8859-1:19871 correspond to the ASCII standard character set. 
3. Values from 0 to 31 are disallowed with the exception of 7 (BEL), 9 (Horizontal tab), 11 (Vertical tab), and 13 (CR), where 13 is reserved as a record terminator. 
4. Values from 32 to 126 and from 128 to 254 are allowed. 
5. Values 127 and 255 are also not allowed. 
6. It is the responsibility of the instrument vendor and information system vendor to understand the representation of any extended or alternate character set being used. 

Allowed Characters:	7, 9, 11, 12, 13, 32 to 126,128 to 254
Disallowed Characters: 0 to 6, 8, 10, 14 to 31, 127,255

Within text data fields, only the following characters are permitted as usable characters (excluding those used as delimiter):

1. Latin-1 characters 32 to 126 (0x20 - 0x7E)
2. The undefined characters 128 to 254 (0x80 - 0xFE)


[UTF-8 and Unicode FAQ for Unix/Linux](https://www.cl.cam.ac.uk/~mgk25/unicode.html#utf-8)

UTF-8 has the following properties:

- UCS characters U+0000 to U+007F (ASCII) are encoded simply as bytes 0x00 to 0x7F (ASCII compatibility). This means that files and strings which contain only 7-bit ASCII characters have the same encoding under both ASCII and UTF-8.

- All UCS characters >U+007F are encoded as a sequence of several bytes, each of which has the most significant bit set. Therefore, no ASCII byte (0x00-0x7F) can appear as part of any other character.

- The first byte of a multibyte sequence that represents a non-ASCII character is always in the range 0xC0 to 0xFD and it indicates how many bytes follow for this character. All further bytes in a multibyte sequence are in the range 0x80 to 0xBF. This allows easy resynchronization and makes the encoding stateless and robust against missing bytes.

- All possible 231 UCS codes can be encoded.

- UTF-8 encoded characters may theoretically be up to six bytes long, however 16-bit BMP characters are only up to three bytes long.

- The sorting order of Bigendian UCS-4 byte strings is preserved.

- The bytes 0xFE and 0xFF are never used in the UTF-8 encoding.

  

The following byte sequences are used to represent a character. The sequence to be used depends on the Unicode number of the character:

  |      |      |
  | ---- | ---- |
  |U-00000000 – U-0000007F:|0xxxxxxx|
  |U-00000080 – U-000007FF:|110xxxxx 10xxxxxx|
  |U-00000800 – U-0000FFFF:|1110xxxx 10xxxxxx 10xxxxxx|
  |U-00010000 – U-001FFFFF:|11110xxx 10xxxxxx 10xxxxxx 10xxxxxx|
  |U-00200000 – U-03FFFFFF:|111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx|
  |U-04000000 – U-7FFFFFFF:|1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx|

The xxx bit positions are filled with the bits of the character code number in binary representation. The rightmost x bit is the least-significant bit. Only the shortest possible multibyte sequence which can represent the code number of the character can be used. Note that in multibyte sequences, the number of leading 1 bits in the first byte is identical to the number of bytes in the entire sequence.

