Creating a sas table from a json file using r and sas

github
https://tinyurl.com/tqnmafy
https://github.com/rogerjdeangelis/utl-creating-a-sas-table-from-a-json-file-using-r-and-sas

github JSON
https://github.com/rogerjdeangelis?tab=repositories&q=json+in%3Aname&type=&language=

SAS Forum
https://tinyurl.com/tqnmafy
https://communities.sas.com/t5/SAS-Programming/Parsing-double-stringify-JSON-data/m-p/631663

   Two Solutions

        a. R
        b. SAS


I think your json was copied from a unix "prettified output" not raw usable json.

Some of your bracketing does not balance?

I restructured your JSON

By the way Python and R are better for this kind of problem?

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

filename ft15f001 "d:/json/simple.json";
parmcards4;
[
  {"A":"32",
   "B":"name1",
    "FNAME":"p1",
    "MNAME":"p2",
    "D":"new"
  },

  {"A":"38",
   "B":"name2",
    "FNAME":"q1",
    "MNAME":"q2",
    "D":"new"
  }
]
;;;;
run;quit;

*            _               _
  ___  _   _| |_ _ __  _   _| |_ ___
 / _ \| | | | __| '_ \| | | | __/ __|
| (_) | |_| | |_| |_) | |_| | |_\__ \
 \___/ \__,_|\__| .__/ \__,_|\__|___/
                |_|
           ____
  __ _    |  _ \
 / _` |   | |_) |
| (_| |_  |  _ <
 \__,_(_) |_| \_\

;

WORK.WANT total obs=2

  A       B      FNAME    MNAME     D

  32    name1     p1       p2      new
  38    name2     q1       q2      new

*_
| |__     ___  __ _ ___
| '_ \   / __|/ _` / __|
| |_) |  \__ \ (_| \__ \
|_.__(_) |___/\__,_|___/

;

* not a bad data stucture (normalized);

WORK.WANTSAS total obs=10

  P    P1       V    VALUE

  1    A        1    32
  1    B        1    name1
  1    FNAME    1    p1
  1    MNAME    1    p2
  1    D        1    new
  1    A        1    32
  1    B        1    name2
  1    FNAME    1    q1
  1    MNAME    1    q2
  1    D        1    new

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/
           ____
  __ _    |  _ \
 / _` |   | |_) |
| (_| |_  |  _ <
 \__,_(_) |_| \_\

;

%utl_submit_r64('
   library(rio);
   library(haven);
   library(data.table);
   want<-as.data.table(as.list(import("d:/json/simple.json")));
   write_xpt(want,"d:/xpt/want.xpt",version=8);
 ');

 %xpt2loc(libref=work,
   memlist=_all_,
   filespec='d:/xpt/want.xpt' );

proc print data=want;
run;quit;


*_
| |__     ___  __ _ ___
| '_ \   / __|/ _` / __|
| |_) |  \__ \ (_| \__ \
|_.__(_) |___/\__,_|___/

;

libname jsn json "d:/json/simple.json" automap=reuse;
data wantsas;
  set jsn.alldata;
run;quit;


