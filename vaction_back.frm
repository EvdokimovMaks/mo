.linkform 'NFormRD40_rector_frm' prototype is 'VozOtpForm'
.nameinlist 'Об отзыве из отпуска ректора'

.var
  ddoc:     date;
  datefrom: date;
  dateto:   date;
  dateto_frm: string;
  decl:     Z_STAFF::declension;
  strf:     Z_STAFF::StringFunctions;
  ipad:     ipadeg;
  iCommission: F_COMMON::Commission;
  CommissIndex: integer;
  CommissCount: integer;
  deparde: string;
  FIO_DP: string;
  lastname_sign, name_sign, patron, signaturer: string;
.endvar

.create view v_post
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    TitleDocNrec      == titledoc.nrec and
    40                == partdoc.typeoper and
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
    40                      == partdoc.typeoper and
    titledoc.nrec           == partdoc.cdoc and
    PersNrec                == contdoc.person and
    partdoc.nrec            == contdoc.cpart and
    AppointNrec             == appointments.nrec and
    appointments.department == catalogs.nrec
));

.create view v_per
as select *
from persons
where ((
    PersNrec == persons.nrec
));

.fields
  day(ddoc) LoCase(datetostr(ddoc, 'Mon')) year(ddoc)
  Номер_Приказа
  GetSurnameWithInitials(FIO_DP)
  LoCase(datetostr(datefrom, 'DD Mon'))
  LoCase(datetostr(dateto, 'DD Mon YYYY'))
  ipad.GetAppointmentPadeg(LoCase(v_post.catalogs.name), 2)
  deparde
  FIO
  Основание
  iCommission.GetComponentPost(CommissIndex)
  signaturer
.endfields

.begin
  ddoc := strtodate(Дата_Приказа, 'DD/MM/YYYY');
  datefrom := strtodate(Дата_Начала_Отзыва, 'DD/MM/YYYY');
  dateto := strtodate(Дата_Окончания_Отзыва, 'DD/MM/YYYY');

  if v_post.getfirst appointments = tsOk
    if v_post.getfirst catalogs = tsOk { }
  if v_dep.getfirst appointments = tsOk
    if v_dep.getfirst catalogs = tsOk { }
  if v_per.getfirst persons = tsOk { }

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
    FIO_DP := decl.FIODeclension(PersNrec, v_per.persons.fio, 2);

    lastname_sign := strf.Get_LastName(iCommission.GetComponentFIO(CommissIndex));
    name_sign := strf.Get_FirstName(iCommission.GetComponentFIO(CommissIndex));
    patron := strf.GetPatronymic(iCommission.GetComponentFIO(CommissIndex));
    signaturer := SubStr(name_sign, 1, 1)+'.'+SubStr(patron, 1, 1)+'. '+lastname_sign;
end.

   ^  ^  ^        # ^
   Об отзыве из отпуска
        ^

   В связи с необходимостью отозвать с ^
   по ^ года ^
   ^
   ^
.{ PushReasonCycle CheckEnter
.}
   основание: ^


.{while CommissIndex <= CommissCount
^   ^
.begin
  CommissIndex++;
  lastname_sign := strf.Get_LastName(iCommission.GetComponentFIO(CommissIndex));
  name_sign := strf.Get_FirstName(iCommission.GetComponentFIO(CommissIndex));
  patron := strf.GetPatronymic(iCommission.GetComponentFIO(CommissIndex));
  signaturer := SubStr(name_sign, 1, 1)+'.'+SubStr(patron, 1, 1)+'. '+lastname_sign;
end.
.}

.endform
