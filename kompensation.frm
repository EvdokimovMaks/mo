.linkform 'NFormT6_kompensation' prototype is 'FormT6_04'
.nameinlist 'О компенсации'

.var
  ddoc: date;
  decl: Z_STAFF::declension;
  iCommission: F_COMMON::Commission;
  CommissIndex: integer;
  CommissCount: integer;
  deparde: string;
  ipad: ipadeg;
  calendar_day: string;
.endvar

.create view v_post
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    TitleDocNrec      == titledoc.nrec and
    41                == partdoc.typeoper and
    titledoc.nrec     == partdoc.cdoc and
    PersNrec          == contdoc.person and
    partdoc.nrec      == contdoc.cpart and
    AppointNrec       == appointments.nrec and
    appointments.post == catalogs.nrec
));

.create view v_dep
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    TitleDocNrec            == titledoc.nrec and
    41                      == partdoc.typeoper and
    titledoc.nrec           == partdoc.cdoc and
    PersNrec                == contdoc.person and
    partdoc.nrec            == contdoc.cpart and
    AppointNrec             == appointments.nrec and
    appointments.department == catalogs.nrec
));

.create view v_sbottom
as select *
from titledoc, partdoc, contdoc
where ((
    TitleDocNrec            == titledoc.nrec and
    41                      == partdoc.typeoper and
    titledoc.nrec           == partdoc.cdoc and
    PersNrec                == contdoc.person and
    partdoc.nrec            == contdoc.cpart
));

.fields
  day(ddoc) LoCase(datetostr(ddoc, 'Mon')) year(ddoc)
  номер_документа
  ipad.GetAppointmentPadeg(LoCase(v_post.catalogs.name), 3)
  deparde
  FIO_VP
  year(strtodate(dBegin, '"DD" Mon YYYY'))
  number
  calendar_day
  v_sbottom.contdoc.sbottom
  iCommission.GetComponentPost(CommissIndex)
  iCommission.GetComponentFIO(CommissIndex)
.endfields

.begin
  ddoc := strtodate(дата_составления, 'DD/MM/YYYY');
  if v_post.getfirst appointments = tsOk
    if v_post.getfirst catalogs = tsOk { }
  if v_dep.getfirst appointments = tsOk
    if v_dep.getfirst catalogs = tsOk { }
  if v_sbottom.getfirst titledoc = tsOk { }
    if v_sbottom.getfirst partdoc = tsOk { }
      if v_sbottom.getfirst contdoc = tsOk { }
  if v_dep.catalogs.longname <> ''
       deparde := ipad.GetDepartmentPadeg(LoCase(v_dep.catalogs.longname), 2)
  else deparde := ipad.GetDepartmentPadeg(LoCase(v_dep.catalogs.name), 2)
  iCommission.InitCommission(COMMISSION_APPOINTMENT);
  iCommission.RunWindowSelection(1);
  CommissCount := iCommission.GetComponentsCount;
  if iCommission.GetCommissionChairMan
    CommissIndex := 0
  else
    CommissIndex := 1;
  if integer(number) = 11 or integer(number) = 12 or integer(number) = 13 or integer(number) = 14 calendar_day := 'календарных дней' else
    if integer(number) mod 10 = 1 calendar_day := 'календарный день' else
      if integer(number) mod 10 = 2 or integer(number) mod 10 = 3 or integer(number) mod 10 = 4 calendar_day := 'календарных дня' else
        calendar_day := 'календарных дней'
end.

 ^ ^ ^ г.    № ^

    О компенсации

Заменить ^ ^
^ часть неиспользованного отпуска
за период ^ г. продолжительностью ^ ^ денежной компенсацией.

Основание: ^

.{while CommissIndex <= CommissCount
^           ^
.begin
  CommissIndex++;
end.
.}
.{ t6_2004_Cycle1 CheckEnter
.}

.endform
