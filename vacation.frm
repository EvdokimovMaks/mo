.linkform 'NForm6' prototype is 'FormT6_04'
.nameinlist 'Об отпуске'

.var
  ddoc:     date;
  datefrom: date;
  dateto:   date;
  decl:     Z_STAFF::declension;
  strf:     Z_STAFF::StringFunctions;
  ipad:     ipadeg;
  iCommission: F_COMMON::Commission;
  CommissIndex: integer;
  CommissCount: integer;
  deparde: string;
  calendar_day: string;
  FIO_RP: string;
  lastname_sign, name_sign, patron, signaturer: string;
  NAME_IO: string;
  lastname_io, firstname_io, middlename_io, sex_io: string;
  sex_int: word;
.endvar

.create view v_post
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    TitleDocNrec      == titledoc.nrec and
    6                 == partdoc.typeoper and
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
    6                       == partdoc.typeoper and
    titledoc.nrec           == partdoc.cdoc and
    PersNrec                == contdoc.person and
    partdoc.nrec            == contdoc.cpart and
    AppointNrec             == appointments.nrec and
    appointments.department == catalogs.nrec
));

.create view v_post_io
as select *
from titledoc, partdoc, contdoc, exclassval, exclassseg
where ((
      TitleDocNrec         == titledoc.nrec and
      6                    == partdoc.typeoper and
      titledoc.nrec        == partdoc.cdoc and
      PersNrec             == contdoc.person and
      partdoc.nrec         == contdoc.cpart and
      EX_CLASSCODE_POST    == exclassval.classcode and
      25045                == exclassval.wtable and
      contdoc.nrec         == exclassval.crec and
      exclassval.cclassseg == exclassseg.nrec
));

.create view v_name
as select *
from titledoc, partdoc, contdoc, exclassval, exclassseg
where ((
      TitleDocNrec         == titledoc.nrec and
      6                    == partdoc.typeoper and
      titledoc.nrec        == partdoc.cdoc and
      PersNrec             == contdoc.person and
      partdoc.nrec         == contdoc.cpart and
      EX_CLASSCODE_NAME    == exclassval.classcode and
      25045                == exclassval.wtable and
      contdoc.nrec         == exclassval.crec and
      exclassval.cclassseg == exclassseg.nrec
));


.fields
  day(ddoc) LoCase(datetostr(ddoc, 'Mon')) year(ddoc)
  номер_документа
  GetSurnameWithInitials(FIO_RP)
  ipad.GetAppointmentPadeg(LoCase(v_post.catalogs.name), 3)
  deparde
  LoCase(v_post.catalogs.SDOPINF)
  FIO_VP
  LoCase(datetostr(datefrom, 'DD Mon'))
  LoCase(datetostr(dateto, 'DD Mon YYYY'))
  number
  calendar_day
  ipad.GetAppointmentPadeg(LoCase(v_post.catalogs.name), 2)
  ipad.GetDepartmentPadeg(LoCase(v_post.catalogs.SDOPINF), 2)
  GetSurnameWithInitials(FIO_RP)
  ipad.GetAppointmentPadeg(LoCase(v_post_io.exclassseg.name), 2)
  NAME_IO
  sFoundation
  iCommission.GetComponentPost(CommissIndex)
  signaturer
.endfields

.begin
  ddoc := strtodate(дата_составления, 'DD/MM/YYYY');
  datefrom := strtodate(dBegin, '"DD" Mon YYYY');
  dateto := strtodate(dEnd, '"DD" Mon YYYY');
  if v_post.getfirst appointments = tsOk
    if v_post.getfirst catalogs = tsOk { }
  if v_dep.getfirst appointments = tsOk
    if v_dep.getfirst catalogs = tsOk { }

  if v_post_io.getfirst titledoc = tsOk
    if v_post_io.getfirst partdoc = tsOk
      if v_post_io.getfirst contdoc = tsOk
        if v_post_io.getfirst exclassval = tsOk
          if v_post_io.getfirst exclassseg = tsOk { }

  if v_name.getfirst titledoc = tsOk
    if v_name.getfirst partdoc = tsOk
      if v_name.getfirst contdoc = tsOk
        if v_name.getfirst exclassval = tsOk
          if v_name.getfirst exclassseg = tsOk { }

  iCommission.InitCommission(COMMISSION_APPOINTMENT);
  iCommission.RunWindowSelection(1);
  CommissCount := iCommission.GetComponentsCount;
  if iCommission.GetCommissionChairMan
    CommissIndex := 0
  else
    CommissIndex := 1;
  if v_dep.catalogs.longname <> ''
       deparde := ipad.GetDepartmentPadeg(LoCase(v_dep.catalogs.longname), 2)
  else deparde := ipad.GetDepartmentPadeg(LoCase(v_dep.catalogs.name), 2);
  if integer(number) = 11 or integer(number) = 12 or integer(number) = 13 or integer(number) = 14 calendar_day := 'календарных дней' else
    if integer(number) mod 10 = 1 calendar_day := 'календарный день' else
      if integer(number) mod 10 = 2 or integer(number) mod 10 = 3 or integer(number) mod 10 = 4 calendar_day := 'календарных дня' else
        calendar_day := 'календарных дней';
  FIO_RP := decl.FIODeclension(PersNrec, FIO, 2);
  lastname_sign := strf.Get_LastName(iCommission.GetComponentFIO(CommissIndex));
  name_sign := strf.Get_FirstName(iCommission.GetComponentFIO(CommissIndex));
  patron := strf.GetPatronymic(iCommission.GetComponentFIO(CommissIndex));
  signaturer := SubStr(name_sign, 1, 1)+'.'+SubStr(patron, 1, 1)+'. '+lastname_sign;

  lastname_io := strf.Get_LastName(v_name.exclassseg.name);
  firstname_io := strf.Get_FirstName(v_name.exclassseg.name);
  middlename_io := strf.GetPatronymic(v_name.exclassseg.name);
  sex_int := decl.VerifyGender(v_name.exclassseg.name);
  if sex_int = 1 sex_io := 'Ж' else sex_io := 'М';
  NAME_IO := ipad.GetFIOPadeg(lastname_io, firstname_io, middlename_io, sex_io, 4);
end.


   ^  ^  ^        # ^
   Об отпуске ^

Предоставить ^ ^ (далее - ^)
^ ежегодный оплачиваемый отпуск с ^ по ^ года
продолжительностью ^ ^.
Исполнение обязанностей ^ ^ на время отпуска ^ возложить на ^ ^.

.{ t6_2004_Cycle1 CheckEnter
.}
   Основание: ^


.{while CommissIndex <= CommissCount
^    ^
.begin
  CommissIndex++;
  lastname_sign := strf.Get_LastName(iCommission.GetComponentFIO(CommissIndex));
  name_sign := strf.Get_FirstName(iCommission.GetComponentFIO(CommissIndex));
  patron := strf.GetPatronymic(iCommission.GetComponentFIO(CommissIndex));
  signaturer := SubStr(name_sign, 1, 1)+'.'+SubStr(patron, 1, 1)+'. '+lastname_sign;
end.
.}

.endform
