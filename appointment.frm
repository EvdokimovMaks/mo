.linkform 'Nformt1_Rector' prototype is 'Nformt1_2004'
.nameinlist 'Назначение на должность ректора'

.var
  ddoc:     date;
  datefrom: date;
  dateto:   date;
  strf:     Z_STAFF::StringFunctions;
  ipad:     ipadeg;
  iCommission: F_COMMON::Commission;
  CommissIndex: integer;
  CommissCount: integer;
  dateto_frm: string;
  deparde: string;
.endvar

.create view v_post
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    TitleDocNrec      == titledoc.nrec and
    1                 == partdoc.typeoper and
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
    1                       == partdoc.typeoper and
    titledoc.nrec           == partdoc.cdoc and
    PersNrec                == contdoc.person and
    partdoc.nrec            == contdoc.cpart and
    AppointNrec             == appointments.nrec and
    appointments.department == catalogs.nrec
));

.fields
  day(ddoc) datetostr(ddoc, 'Mon') year(ddoc)
  номер_документа
  ipad.GetFullAppointmentPadeg(LoCase(v_post.catalogs.name), '', 2)
  GetSurnameWithInitials(FIO_VP)
  FIO_VP
  ipad.GetAppointmentPadeg(LoCase(v_post.catalogs.name), 2)
  deparde
  LoCase(datetostr(datefrom, 'DD Mon YYYY'))
  dateto_frm
  основание
  iCommission.GetComponentPost(CommissIndex)
  iCommission.GetComponentFIO(CommissIndex)
.endfields

.begin
  ddoc := strtodate(дата_составления, 'DD/MM/YYYY');
  datefrom := strtodate(дата_с, 'DD/MM/YYYY');
  dateto := strtodate(дата_по, 'DD/MM/YYYY');
  if v_post.getfirst appointments = tsOk
    if v_post.getfirst catalogs = tsOk { }
  if v_dep.getfirst appointments = tsOk
    if v_dep.getfirst catalogs = tsOk { }
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
  if dateto <> 0 dateto_frm := ' по ' + LoCase(datetostr(dateto, 'DD Mon YYYY')) + ' года'
end.

                 ~ ПРИКАЗ ~
  "^" (^) ^ г.     №:  ^

        О назначении на должность
        ^  ^

П р и к а з ы в а ю :
Назначить ^ на должность ^ ^ с ^ года^.

.{t1_2004_Raise  CheckEnter
.}

Основание: ^


.{while CommissIndex <= CommissCount
^  ^
.begin
  CommissIndex++;
end.
.}
.endform
