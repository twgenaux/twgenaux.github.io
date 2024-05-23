---
title: LIS Tutorial: ASTM Message Formats
category: LIS
author: [ Theron W. Genaux, Revision 1]
tags: [LIS,ASTM,E1394LIS02]
typora-root-url: ../../

---

# Introduction

This paper discusses ASTM E1394 based message formats. The ASTM E1394 standard was first adopted in 1991 and is intended to be a flexible standard for LIS vendors and analyzer manufacturers to create compatible message formats; compatible, not interchangeable. Compatible such that it’s relatively easy to adapt to support other systems as needed.  

> This standard specifies the conventions for structuring the content of the message and for representing the data elements contained within those structures. It is applicable to all text-oriented clinical instrumentation. It has been specifically created to provide common conventions for interfacing computers and instruments in a clinical setting. [^ASTM E1394-97]

ASTM has since transferred the responsibility for maintaining this standard to the Clinical and Laboratory Standards Institute (CLSI). Which means that the latest version of the ASTM E1394 standard is actually an CLSI standard:

> Standard for the Trnasferring Information Between Clinical Laboratory Instruments and Information Systems; Approved Standard--Second Edition. CLIS document LIS02-A2.

Since the ASTM E1394 standard has been around since 1991, different systems will reafference the version that they target. Below is a list of revisions from current to first adopted:
- LIS02-A2
- LIS02-A
- ASTM E1394-97
- ASTM E1394-91



Related Standards

- LIS02 Standard Specification for the Low-Level Protocol to Transfer Messages Between Clinical Laboratory Instruments and Computer Systems (2003)


# Comma-Separated Values (CSV) Format

You may already be familiar the simple text format that separates fields with a delimiter, such as the comma-separated values (CSV) format. CSV is structured text which uses a comma to separate values in a record (line). Each record consists of one or more fields, delimited by commas. Fields within a record are identified by their position in the record. The CSV format is famous for storing tabular data using plain text, where each record has the same number and order of fields.

The CSV format has many variations. Let's define our own format for creating a simple order message.

- A CSV order message consists of an array of records (lines).
- Each record is made up of comma separated fields and ends with an End Of Record (EOR) character of <CR>
- A field cannot contain an embedded comma
- Fields are identified by their position in the record
- The first field in a record identifies its type
- A patient record begins with P and is  followed by PatientID, LastName, FirstName, and MiddleInitial fields
- An order record begins with O and is followed by SampleID,Sampletype,and TestID fields

A CSV message can easily be split into an array of records using the record delimiter (CR) . Each record can be split into an array of fields using the field delimiter (comma).

Below is our example CSV order message based on our simple CSV format:

```
P,PID123456,Brown,Bobby,B<CR>
O,SID304,CENTBLOOD,ABORh<CR>
```

An LIS and analyzers typically exchange message by sending messages as a stream of characters. Our example CSV order message as a character stream:

```
P,PID123456,Brown,Bobby,B<CR>O,SID304,CENTBLOOD,ABORh<CR>O,SID304,CENTBLOOD,ABORh<CR>
```

To create or parse CSV messages requires Join and Split operations:
- Join an array of fields, separated by the field delimiter into a record 
- Join an array of records, separated by the record delimiter into a message 
- divide a message into an array of records based on the record delimiter
- divide a record into an array of fields based on the record delimiter

Key points of a CSV message:
- The entire message is created from simple text
- Messages and records are easy to create, either programmatically or manually with a text editor
- Any character can be used as the delimiter as long as it does not appear in a field
- A CSV message is an array of records delimited by an end of record delimiter
- A CSV record is an array of text fields delimited by the comma
- All CSV records start with a record type ID

And now to tie things together, these are the key points of an ASTM mssage:
- The entire message is simple text
- Easy to create, either programatically or manualy with a text exitor
- Any character can be used as a delimiter as long as it **is not used as another delimiter and** does not apear in a feild
- An ASTM message is an array of records delimited by a record delimiter
- An ASTM record is an array of fields delimited by the field delimiter
- All ASTM records start with a record type ID
- An ASTM Field is an array of repeated field values of the same data type (i.e. multiple sample IDs) delimited by the repeat delimiter (\\).
- A field value is an array components delimited by the component delimiter (^).
- A component is an array of characters (text).

An ASTM message is structured text based on delimited lines of text. Simply put, an ASTM message is composed of arrays of delimited text that may also contain arrays of delimited text.
- An ASTM Message is an array of records delimited by the record terminator (CR).
- An ASTM Record is an array of fields delimited by the field delimiter (|).
- An ASTM Field is an array of repeated field values of the same field type (i.e. multiple sample IDs) delimited by the repeat delimiter (\\).
- A field value is an array components delimited by the component delimiter (^).
- A component is an array of characters (text). 

Furthermore, an ASTM message is an ordered array of records. The first record is always a Header record (H) and the last record is always a Message Terminator Record (L). All ASTM records start with a record type ID and end with a record terminator (CR). 

Order records have to be proceeded by a patient record, linking the order records to the patient. 

Simple ASTM Order message

```
H|\^&<CR>
P|1|PID123456|||Brown^Bobby^B|||U|||||PHY1234^Forbin^Charles^A\PHY1234^Morbius^Edward<CR>
O|1|SID304||ABORh|||||||||||CENTBLOOD<CR>
L<CR>
```


Table 1: Recode Type IDs

| Type ID | Record Description                                           | Level |
| ------- | ------------------------------------------------------------ | ----- |
| H       | Message Header - contains information about the sender and defines delimiters | 0     |
| P       | Patient - contains information about an individual patient   | 1     |
| O       | Order - when sent from an LIS, this record contains information about a test order. When sent by the instrument, it shall provide information about the test request. | 2     |
| R       | Result - contains the results ofzl a single analytic determination. | 3     |
| M       | Manufacture Information - the fields in this record are defined by the manufacturer. |       |
| Q       | Request for information - used to request information, e.g. request outstanding orders for a sample. | 1     |
| L       | Message Terminator - the last record in the message. A header record may be transmitted after this record signifying the start of a second message. | 0     |



![Donald Knuth Arrays](/LIS_Tutorial/Message Formats/assets/Donald Knuth Arrays.png)









ASTM messages

 Message 1: An ASTM Order Message [^Ortho Vision LIS Guide]



```
H|\^&|||Mini LIS||||||||LIS2-A|20210309155210<CR>
P|1|PID123456|||Brown^Bobby^B|White|196501020304|M<CR>
O|1|SID304||ABO\ABScr|N|20210309155210|||||N||||CENTBLOOD<CR>
O|2|SID305||Pheno|N|20210309155210|||||N||||CENTBLOOD<CR>
P|2|PID789012||NID789012^MID789012^OID789012|Forbin^Charles|Fisher|19410403|M<CR>
O|1|SID306||ABO\ABScr|N|20210309155210|||||N||||CENTBLOOD<CR>
O|2|SID307||Pheno|N|20210309155210|||||N||||CENTBLOOD<CR>
L|1|N<CR>
```



Message AutoVue Result

```
H|\^&|||OCD^AV2G^1.0^J123456|||||||P|1|20140202232445
P|1|PID123456||NID123456^MID123456^OID123456|Brown^Bobby||19650102030400|U||||||||||||||||||||||||||
O|1|SID05||ABO-D|N|20140202232352|||||||||CENTBLOOD|||||||20140202232435|||F|||||
R|1|ABO|A|||M||F||theron||20140202232435|J123456
M|1|Anti-A|ABO-Rh/Reverse^1^000001^12345^20340202235959^22046516_001.bmp||0^A
M|2|Anti-B|ABO-Rh/Reverse^2^000001^12345^20340202235959^22046516_001.bmp||40^A
M|3|Ctrl|ABO-Rh/Reverse^4^000001^12345^20340202235959^22046516_001.bmp||40^A
R|2|Rh|POS|||M||F||theron||20140202232435|J123456
M|1|Anti-D|ABO-Rh/Reverse^3^000001^12345^20340202235959^22046516_001.bmp||40^A
M|2|Ctrl|ABO-Rh/Reverse^4^000001^12345^20340202235959^22046516_001.bmp||40^A
L
```



Message ProVue Result

```
H|\^&|||REPORT^000^2.03b|||||||P|1|20000128160517
P|1|sample1|||||19000101|U
O|1|sample1||^^^^Groups&Rh.pln|R|20000128160517||||||||||||||||||REPORT^000^2.03b|F|
R|1|^^^^Groups&Rh.pln|AB^AB^AB^Pos|Fwd Gr^Rev Gr^Group^Rh||N||F||ServiceT|200001281
60517|20000128160517| REPORT^000^2.03b|
L|1|N
```



Message 2: AQUIOS ASTM Order (AQUIOS LIS Interface
Specification)

```
H|\^&<CR>
P|1||PID||Smith^John^S||19501120|M|||||Dr. Mark Jones||||||||||||Room 421<CR>
O|1|SAMPLE001||^^^01A\^^^02A|S||20091005120000||||A||||Serum|Dr. John Jones Jr.|||||||||O<CR>
L|1|N<CR>
```

Message 3: Prestige 24i Order

```
H|¥^&|||Host^PC1|||||Prestige24i^System1||P|1|20000530192631<CR>
P|1<CR>
O|1|123456|^1^20|^^^1^GOT^0|R||||||||||Serum||||||||||O<CR>
O|2|123456|^1^20|^^^11^LDH^0|R||||||||||Serum||||||||||O<CR>
O|3|123456|^1^20|^^^42^Ca^0|R||||||||||Serum||||||||||O<CR>
L|1|N<CR>
```



Table 1: Recode Type IDs

| Type ID | Record Description                                           | Level |
| ------- | ------------------------------------------------------------ | ----- |
| H       | Message Header - contains information about the sender and defines delimiters | 0     |
| P       | Patient - contains information about an individual patient   | 1     |
| O       | Order - when sent from an LIS, this record contains information about a test order. When sent by the instrument, it shall provide information about the test request. | 2     |
| R       | Result - contains the results ofzl a single analytic determination. | 3     |
| M       | Manufacture Information - the fields in this record are defined by the manufacturer. |       |
| Q       | Request for information - used to request information, e.g. request outstanding orders for a sample. | 1     |
| L       | Message Terminator - the last record in the message. A header record may be transmitted after this record signifying the start of a second message. | 0     |



![Donald Knuth Arrays](/LIS_Tutorial/Message Formats/assets/Donald Knuth Arrays.png)



Records are constructed as an array of fields. Fields are numbered from 1 because the section numbers of the first field of each record in the ASTM standard starts with one. 

Note that the record terminator <CR> delimits each record in a message and plays no roll in the information structure of the record. 

Below, the ASTM standard list the first field in the patient record is the Record Type and has a section number ending in 0ne.

![Fields are numbered from one](/LIS_Tutorial/Message Formats/assets/Fields are numbered from one.png)

Field delimiters (|) separates each field in the record.

> Field-1|Field-2|Field-3|Field-4|Field-5|Field-6|Field-7|Field-8|Field-9

TIP: When a message is rejected by a system, it as been on more than one occasion, due to too many or too few field delimiters between values. You can copy a record into Notepad++ and replace every field delimiter with a new line. The line numbers are then the same as the field number, making it easy to verify their position. You can also reverse the process to easily edit a record for use in a message.

![Tip-Fields](/LIS_Tutorial/Message Formats/assets/Tip-Fields.png)

Sometimes, there are multiple field values for the same field, such as multiple test IDs in an order. Repeat delimiters (\\) separates each of the multiple field values (see field 5 below).
> O|1|SID304||ABO\ABScr|N|20210309155210|||||N||||CENTBLOOD


Some fields contain multiple parts, such as a person's name. Components cannot contain repeat fields. Component delimiters (^) separates each of the parts (see field 6 below).
> P|1|PID123456|||Brown^Bobby^B|White|196501020304|M

Some characters are not allowed in ASTM text fields. When a character is not allowed, it can be replaced by an escape sequence. Escape sequences are used to replace an illegal character with a sequence of allowed characters. The sender of an ASTM message converts restricted characters to an escape sequence, and the receiver of the message converts escape sequences back to the original text. 

A profile named 'Type\Screen' would be written in an ASTM message as 'Type&R&Screen', because the '\\' character is defined as repeat field delimitator, which is reserved.

> O|1|SID303||Type&R&Screen|N|20210309143022|||||N||||CENTBLOOD
>

Easy to replace a restricted character when writing it into a text field and easy to find and replace a escape sequence when reading it from the record.

# What belongs together should stay together

A middleware once took product

Its important to know that LIS vendors are moving away from sending patient demographics and moving towards AutoVue sends all available results in one message. The LIS would send many orders without patient demographics, only sample IDs. The middleware would take and merge all results without patient demographics  into one patient.

Since patient demographics are optional and QC and donor samples do not have patient demographics, recommend 

levels and m-records

# stuff

For simplicity, the remainder of this book uses the term *ASTM* to refer to all forms of the supported standards. **add list of LIS1 standards**

The phrase "agreed upon between the sender and the receiver" appears several times in the ASTM  E1394-97 standards. Additionally, the majority of fields are optional; the sender is not required to send the information and the receiver may ignore the information if it is not required for the processing of the message. These provide a lot of flexibility with implementations as well as significant variability between instruments. 

The [^ASTM E1394] standard "has sufficient flexibility to permit the addition of fields to existing record types or the creation of new record types to accommodate new test and reporting mythologies."

A system may transmit a null value for a field because [^ASTM E1394]:

1. it does not know the value
2. it knows the value is irrelevant to the receiving system
3. the value has not changed since the last transmission or any combination thereof

Given all the flexibility of the standard, the following minimal order message contains only the minimal required information for an order; a sample ID and type, and a test ID. The records don't even contain record sequence numbers because the "value is irrelevant to the receiving system" or because its "agreed upon between the sender and the receiver".

Message 2: The smallest ASTM Order Message.

> H|\^&
> P
> O||SID101||ABO-D|||||||||||CENTBLOOD
> L

Header (H) records start with a record type ID (H) and must define the delimiters (|\^&). All the rest of the information in the header is optional.

Terminal (L) records start with a record type ID (L). All other information is optional. However, some receivers require additional information. 

Patient Information Record (P) start with a record type ID of (P). 

Message 2: 

> H|\^&
> P|1
> O|1|SID101||ABO|||||||||||CENTBLOOD
> L

> An accession number relates to an alphanumeric code printed on a biomedical label that is affixed to an aliquot in the laboratory to identify and match blood or urine specimens provided by donors. The accession number, and its corresponding clinical reference provided in the database system, restricts access to the lab clinician or physician specified on the label. This method serves to prevent unauthorized observation among third parties in accordance to laboratory rules and governmental regulations of donor confidentiality while still ensuring results will be matched with the actual donors at the end of the process by the employer or other party who ordered the testing.
> 
> n accession number refers to an alphanumeric code printed on an aliquot sample that is being tested at a lab. The accession number relates back to a Custody and Control Form in the laboratory's Laboratory Information System (LIM). The accession number is used to blind the laboratory technicians to the identity of the donor providing the specimen while still allowing them an efficient way of relating the sample back the Custody and Control Form and the donor in the LIM after testing.
> 
> https://www.workplacetesting.com/definition/1163/accession-number-drug-testing

[^ASTM E1394-97]:Standard Specification for Transferring Information Between Clinical Instruments and Computer Systems


- *ASTM E1381-02 Standard Specification for Low-Level Protocol to Transfer Messages Between Clinical Laboratory Instruments and Computer* *Systems (Withdrawn 2002)*

[^LIS02-A2](LIS02-A2 Specification for Transferring Information Between Clinical Instruments and Computer Systems; Approved Standard- Second Edition)


[^Ortho Vision LIS Guide]:J66623ENX Ortho BioVue Cassettes Laboratory Information System (LIS) Guide





[Ortho Public Technical Documents](https://www.orthoclinicaldiagnostics.com/en-gb/home/technical-documents)

[CellSearch Technical Documents](https://www.cellsearchctc.com/support-resources/reference-guides)

[Medical Electronic Systems](https://mes-global.com/support/user-guides/)