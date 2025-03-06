---
title: ASTM E1394 Message Parsing
category: ASTM E1394
author: [ Theron W. Genaux]
tags: [LIS, ASTM, LIS1, LIS01, LIS01A2E]
---



<h1 id='calculating-checksum-lis01-frame'><span><center>Calculating the checksum of a UTF8 encoded LIS01 Frame</center></span></h1>
<p style="text-align:center">Theron W. Genaux</p>
<p style="text-align:center">4-March-2025</p>





- [LIS01A2E](https://clsi.org/standards/products/automation-and-informatics/documents/lis01/), Specification for Low-Level Protocol to Transfer Messages Between Clinical Laboratory Instruments and Computer Systems
- [LIS02A2E](https://clsi.org/standards/products/automation-and-informatics/documents/lis02), Specification for Transferring Information Between Clinical Laboratory Instruments and Information Systems
- Hendrickson Group - [Calculating the checksum of an ASTM document](https://www.hendricksongroup.com/code_003.aspx) 



# Introduction

- The target audience is software developers and technicians who develop or support LIS interfaces.
- Character encoding vs fonts. What is it?
- Issues with LIS02 and different character encodings.
- Intro to LIS02
- What is LIS1 and what is a frame?
- 

The LIS02 specification describes the structure and content of messages sent between an instrument and a Laboratory Information System (LIS). These messages are used to send orders, receive results, and query each other for information. They can be exchanged in network shared folders, serial communication, and TCP/IP protocols.

Below is an LIS02 Message containing four records; Header (H), Patient (P), Order (O), and End of Message (L).

```
H|\^&|||Mini LIS||||||||LIS2-A|20210309142633<CR>
P|1|PID123456||NID123456|Brown^Bobby^B|White|196501020304|M<CR>
O|1|SID305||ABO|N|20210309142633|||||N||||CENTBLOOD<CR>
L|1|N<CR>
```

LIS01 is a specification for a low-level protocol that can exchange LIS02 messages through serial communication and TCP/IP. The protocol is implemented to allow bidirectional communication, where each system takes turns sending and receiving messages. LIS02 messages are sent one line (called a record) at a time. The LIS01 protocol is not limited to just LIS02 messages; it can send any text-based message that its protocol can support. For LIS02 content, an LIS01 message is defined as one LIS02 record.

Each LIS02 record is sent in an LIS01 frame that starts with an \<STX> and ends with a \<CR>\<LF> sequence. The message (record) sits between the \<STX> and the \<ETX>. Each frame contains a checksum, which is used to validate that the message has not been corrupted in transit. The checksum lies between the  \<ETX> and \<CR>\<LF> sequence.

```
<STX><LIS02 Record><ETX><Two digit hexidecimal Checksum><CR><LF>
```

The checksum for the Header record is the hexidecimal value 96, and the checksum for the Order record (O) shown below is the hexidecimal value 4B.

```
Instrument: <ENQ>
LIS       : <ACK>
Instrument: <STX>1H|\^&|||Mini LIS||||||||LIS2-A|20210309142633<CR><ETX>96<CR><LF>
LIS       : <ACK>
Instrument: <STX>2P|1|PID123456||NID123456|Brown^Bobby^B|White|196501020304|M<CR><ETX>66<CR><LF>
LIS       : <ACK>
Instrument: <STX>3O|1|SID305||ABO|N|20210309142633|||||N||||CENTBLOOD<CR><ETX>4B<CR><LF>
LIS       : <ACK>
Instrument: <STX>4L|1|N<CR><ETX>07<CR><LF>
LIS       : <ACK>
Instrument: <EOT>
```



## Creating an LIS01 frame



```c#
1  byte[] frameBtyes = LIS01_Helper.CreateFrame(
2  frameNumber:6,
3      text:"P|1|PID123456|||Brown^Bobby^B|White|196501020304|U" + C.CR,
4      frameType:C.ETX,
5      encoding:Encoding.UTF8);

Frame:
<STX>6P|1|PID123456|||Brown^Bobby^B|White|196501020304|U<CR><EXT>62<CR><LF>

Bytes:
02-36-50-7C-31-7C-50-49-44-31-32-33-34-35-36-7C-7C-7C-42-72-6F-77-6E-5E-42-6F-62-62-79-5E-42-7C-57-68-69-74-65-7C-31-39-36-35-30-31-30-32-30-33-30-34-7C-55-0D-3C-45-58-54-3E-36-32-0D-0A
```



```c#
    /// <summary>
    /// Creates an LIS1-A frame
    /// </summary>
    /// <param name="frameNumber">single digit Frame Number 0 to 7</param>
    /// <param name="text">data content of frame</param>
    /// <param name="frameType">ETX or ETB</param>
    /// <param name="encoding">Character encoding</param>
    /// <returns>Returns the encoded frame as byte[]</returns>
01  public static byte[] CreateFrame(int frameNumber, string text, char frameType, Encoding encoding)
02  {
03      string checksum = "00";
04
05      string frame = C.STX + frameNumber.ToString() + text + frameType + checksum + C.CR + C.LF;
06
07      byte[] frameBytes = encoding.GetBytes(frame);
08
09      checksum = LIS01_Helper.CalculateFrameChecksum(frameBytes);
10      frameBytes[frameBytes.Length - 4] = (byte)checksum[0];
11      frameBytes[frameBytes.Length - 3] = (byte)checksum[1];
12
13      return frameBytes;
14  }
```


```C3
byte[] frameBtyes = LIS01_Helper.CreateFrame(
    2,
    "P|1|666|||頭いい^素晴らしい|||U" + C.CR,
    C.ETX, 
    Encoding.UTF8);

Frame:
<STX>2P|1|666|||頭いい^素晴らしい|||U<CR><EXT>3D<CR><LF>

Bytes:
02-32-50-7C-31-7C-36-36-36-7C-7C-7C-E9-A0-AD-E3-81-84-E3-81-84-5E-E7-B4-A0-E6-99-B4-E3-82-89-E3-81-97-E3-81-84-7C-7C-7C-55-0D-03-33-44-0D-0A
```

````c#
byte[] frameBtyes = LIS01_Helper.CreateFrame(
    2,
    "P|1|666|||頭いい^素晴らしい|||U" + C.CR,
    C.ETX, 
    Encoding.GetEncoding("Shift-JIS"));

Frame:
<STX>2P|1|666|||頭いい^素晴らしい|||U<CR><EXT>78<CR><LF>

Bytes:
02-32-50-7C-31-7C-36-36-36-7C-7C-7C-93-AA-82-A2-82-A2-5E-91-66-90-B0-82-E7-82-B5-82-A2-7C-7C-7C-55-0D-03-37-38-0D-0A
````

```c#
/// ASCII Byte constants
public static class B
{
    public const byte ENQ = 5;
    public const byte ACK = 6;
    public const byte NAK = 21;
    public const byte EOT = 4;
    public const byte ETX = 3;
    public const byte ETB = 23;
    public const byte STX = 2;
    public const byte CR = 13;
    public const byte LF = 10;
}
```

```c#
/// ASCII char constants (default host encoding)
public static class C
{
    public const char ENQ = (char)B.ACK;
    public const char ACK = (char)B.ACK;
    public const char NAK = (char)B.NAK;
    public const char EOT = (char)B.EOT;
    public const char ETX = (char)B.ETX;
    public const char ETB = (char)B.ETB;
    public const char STX = (char)B.STX;
    public const char CR = (char)B.CR;
    public const char LF = (char)B.LF;
}
```



> LIS01A2E, section 4.3:
>
> This standard specification does not define the transmission of character encodings that require greater than eight bits; however, character encodings greater than eight bits can be transmitted through the use of appropriate algorithmic transformations. Examples include using Shift JIS for the transmission of Japanese characters defined by the Japanese Industrial Standards JIS X 0207 (single-byte characters) and JIS X 0208 (double-byte characters), as well as the transmission of the Unicode/UCS-2 character set with a UTF-8 encoding. These techniques do not violate the character-oriented protocol and associated character restrictions described by the data link layer of this standard. There are no provisions in the standard to identify if a specific transmission approach is being used; therefore, the character encoding and transmission approach must be agreed upon outside of the context of this standard.
