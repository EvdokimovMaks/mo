.linkform 'Nformt1_TEST' prototype is 'Nformt1_2004'
.nameinlist 'Тестовая форма'
.declare
#include odecl.vih
.enddeclare
.var
  ddoc: date;
  test: string;
  decl: Z_STAFF::declension;
.endvar
.create view v
as select *
from katmc, titledoc, partdoc, contdoc
where ((
  0            /== katmc.nrec and
  TitleDocNrec  == titledoc.nrec and
  1             == partdoc.typeoper and
  titledoc.nrec == partdoc.cdoc and
  PersNrec      == contdoc.person and
  partdoc.nrec  == contdoc.cpart
));
.fields
  номер_документа day(ddoc) datetostr(ddoc, 'Mon YYYY')
  v.contdoc.nrec
  decl.FIODeclension(PersNrec, FIO, 2)
  decl.FIODeclension(PersNrec, FIO, 3)
  decl.FIODeclension(PersNrec, FIO, 4)
  decl.FIODeclension(PersNrec, FIO, 5)
  decl.FIODeclension(PersNrec, FIO, 6)
.endfields
.begin
  ddoc := strtodate(дата_составления, 'DD/MM/YYYY');
  if v.getfirst titledoc = tsOk
    if v.getfirst partdoc = tsOk
      if v.getfirst contdoc = tsOk { }
  //if v.getfirst viewtable = tsOk {}
end.

        Приказ №^ от "^" ^

 Contdoc.nrec = ^
 2            = ^
 3            = ^
 4            = ^
 5            = ^
 6            = ^

.{t1_2004_Raise  CheckEnter
.}
.endform
