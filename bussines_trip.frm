.linkform 'TRIP_T9_dyrc' prototype is 'KomPrik'
.nameinlist 'КОМАНДИРОВКА'
.Group 'Приказ (форма Т-9)'
.var
  date_doc: date;
  iCommission: F_COMMON::Commission;
  CommissIndex: integer;
  CommissCount: integer;
  lastname_sign, name_sign, patron, signaturer: string;
  strf: Z_STAFF::StringFunctions;
  ipad: ipadeg;
  decl: Z_STAFF::declension;
  deparde: string;
.endvar
.create view v_post_io
as select *
from exclassval, exclassseg
where ((
      CLASSCODE_POST       == exclassval.classcode and
      PRIKAZ_WTBL          == exclassval.wtable and
      comp(NRecPrik)       == exclassval.crec and
      exclassval.cclassseg == exclassseg.nrec
));
.create view v_name
as select *
from exclassval, exclassseg
where ((
      CLASSCODE_NAME       == exclassval.classcode and
      PRIKAZ_WTBL          == exclassval.wtable and
      comp(NRecPrik)       == exclassval.crec and
      exclassval.cclassseg == exclassseg.nrec
));
.create view v_resol
as select *
from exclassval, exclassseg
where ((
      CLASSCODE_RESOL      == exclassval.classcode and
      PRIKAZ_WTBL          == exclassval.wtable and
      comp(NRecPrik)       == exclassval.crec and
      exclassval.cclassseg == exclassseg.nrec
));
.create view v_pers
as select *
from persons
where ((
      PERS_ISEMPL == persons.isemployee and
      FIO         == persons.fio
));
.create view v_podr
as select *
from catalogs
where ((
  comp(CPARENT_PODR) == catalogs.cparent and
  Podr               == catalogs.name
));
.fields
  day(date_doc) LoCase(datetostr(date_doc, 'Mon')) year(date_doc)
  NoDoc
  ipad.GetAppointmentPadeg(LoCase(Chin), 2)
  GetSurnameWithInitials(decl.FIODeclension(v_name.exclassseg.nrec, v_name.exclassseg.name, 2))
  GroupWrap(MestoNaznEx, 1, 88)
  decl.FIODeclension(v_pers.persons.nrec, FIO, 2)
  ltrim(DayStart, '0') MonthStart ltrim(DayEnd, '0') MonthEnd '20'+YearEnd
  ipad.GetAppointmentPadeg(LoCase(Chin), 2)
  locase(substr(deparde, 1, 1)) + substr(deparde, 2, 255)
  ipad.GetAppointmentPadeg(LoCase(v_post_io.exclassseg.name), 2)
  decl.FIODeclension(v_name.exclassseg.nrec, v_name.exclassseg.name, 2)
  Osnov
  iCommission.GetComponentPost(CommissIndex)
  signaturer
.endfields
.begin
  date_doc := strtodate(dDoc, 'DD/MM/YYYY');
  if v_post_io.getfirst exclassval = tsOk
    if v_post_io.getfirst exclassseg = tsOk { }
  if v_name.getfirst exclassval = tsOk
    if v_name.getfirst exclassseg = tsOk { }
  if v_resol.getfirst exclassval = tsOk
    if v_resol.getfirst exclassseg = tsOk { }
  if v_pers.getfirst persons = tsOk { }
  if v_podr.getfirst catalogs = tsOk { }
  iCommission.InitCommission(COMMISSION_APPOINTMENT);
  iCommission.RunWindowSelection(1);
  CommissCount := iCommission.GetComponentsCount;
  if iCommission.GetCommissionChairMan
    CommissIndex := 0
  else
    CommissIndex := 1;
  lastname_sign := strf.Get_LastName(iCommission.GetComponentFIO(CommissIndex));
  name_sign := strf.Get_FirstName(iCommission.GetComponentFIO(CommissIndex));
  patron := strf.GetPatronymic(iCommission.GetComponentFIO(CommissIndex));
  signaturer := SubStr(name_sign, 1, 1)+'.'+SubStr(patron, 1, 1)+'. '+lastname_sign;
  if substr(v_resol.exclassseg.name, 1, 11) = 'нет в налич' and GroupWrap(MestoNaznEx,1,88) = 'за пределы Российской Федерации' then
  message('Внимание! У '+GetSurnameWithInitials(decl.FIODeclension(v_name.exclassseg.nrec, v_name.exclassseg.name, 2))+' нет разрешения для выезда за пределы РФ');
  if v_podr.catalogs.longname <> ''
       deparde := ipad.GetDepartmentPadeg(v_podr.catalogs.longname, 2)
  else deparde := ipad.GetDepartmentPadeg(Podr, 2);
end.


.{
.{?Internal;(wGetTune('Country')=ccRus);
.}
      ПРИКАЗ
"^" ^ ^ г     ^

О возложении исполнения обязанностей ^ на ^

На время служебной командировки ^ ^
с ^ ^ по ^ ^ ^ года возложить исполнение обязанностей ^
^
на ^ ^

Основание: ^
=============================
.{while CommissIndex <= CommissCount
^      	^
.begin
  CommissIndex++;
  lastname_sign := strf.Get_LastName(iCommission.GetComponentFIO(CommissIndex));
  name_sign := strf.Get_FirstName(iCommission.GetComponentFIO(CommissIndex));
  patron := strf.GetPatronymic(iCommission.GetComponentFIO(CommissIndex));
  signaturer := SubStr(name_sign, 1, 1)+'.'+SubStr(patron, 1, 1)+'. '+lastname_sign;
end.
.}

.}
.{ CheckEnter PrintRep9a
.{ CheckEnter NextPage9A
.}
.}
.endform
