.linkform 'TRIP' prototype is 'KomPrik'
.nameinlist 'О возложении (командировка)'

.var
  date_doc: date;
  iCommission: F_COMMON::Commission;
  CommissIndex: integer;
  CommissCount: integer;
  lastname_sign, name_sign, patron, signaturer: string;
  strf: Z_STAFF::StringFunctions;
  deparde: string;
  ipad: ipadeg;
  decl: Z_STAFF::declension;
  FIO_RP_IO, FIO_RP: string;
.endvar

.create view v_title
as select *
from partdoc
where ((
    NRecPartDoc == partdoc.nrec
));

.create view v_cont
as select *
from contdoc
where ((
    NRecPartDoc   == contdoc.cpart and
    TypePrCodOper == contdoc.typeoper and
    NrecPerson    == contdoc.person and
    SEQNMB_CONST  == contdoc.seqnmb and
    NUMPART_CONST == contdoc.numpart
));

.create view v_fio
as select *
from persons
where ((
    NrecPerson == persons.nrec
));

.create view v_post
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    v_title.partdoc.cdoc == titledoc.nrec and
    TypePrCodOper        == partdoc.typeoper and
    titledoc.nrec        == partdoc.cdoc and
    NrecPerson           == contdoc.person and
    partdoc.nrec         == contdoc.cpart and
    NrecAppoint          == appointments.nrec and
    appointments.post    == catalogs.nrec
));

.create view v_dep
as select *
from titledoc, partdoc, contdoc, appointments, catalogs
where ((
    v_title.partdoc.cdoc    == titledoc.nrec and
    TypePrCodOper           == partdoc.typeoper and
    titledoc.nrec           == partdoc.cdoc and
    NrecPerson              == contdoc.person and
    partdoc.nrec            == contdoc.cpart and
    NrecAppoint             == appointments.nrec and
    appointments.department == catalogs.nrec
));

.create view v_date
var
  contdocNrec: comp;
as select *
from attrnam, attrval
where ((
    CONTDOC_CODE        == attrnam.wtable and
    'Дата'              == attrnam.name and
    CONTDOC_CODE        == attrval.wtable and
    contdocNrec         == attrval.crec and
    attrnam.nrec        == attrval.cattrnam
));


.create view v_post_io
as select *
from titledoc, partdoc, contdoc, exclassval, exclassseg
where ((
      v_title.partdoc.cdoc == titledoc.nrec and
      TypePrCodOper        == partdoc.typeoper and
      titledoc.nrec        == partdoc.cdoc and
      NrecPerson           == contdoc.person and
      partdoc.nrec         == contdoc.cpart and
      EX_CLASSCODE_POST    == exclassval.classcode and
      CONTDOC_CODE         == exclassval.wtable and
      v_cont.contdoc.nrec  == exclassval.crec and
      exclassval.cclassseg == exclassseg.nrec
));

.create view v_name
as select *
from titledoc, partdoc, contdoc, exclassval, exclassseg
where ((
      v_title.partdoc.cdoc == titledoc.nrec and
      TypePrCodOper        == partdoc.typeoper and
      titledoc.nrec        == partdoc.cdoc and
      NrecPerson           == contdoc.person and
      partdoc.nrec         == contdoc.cpart and
      EX_CLASSCODE_NAME    == exclassval.classcode and
      CONTDOC_CODE         == exclassval.wtable and
      v_cont.contdoc.nrec  == exclassval.crec and
      exclassval.cclassseg == exclassseg.nrec
));


.fields
  day(date_doc) LoCase(datetostr(date_doc, 'Mon')) year(date_doc)
  NoDoc
  ipad.GetAppointmentPadeg(LoCase(v_post.catalogs.name), 2)
  GetSurnameWithInitials(FIO_RP_IO)
  FIO_RP
  deparde
  locase(datetostr(v_date.attrval.vdate, 'DD Mon YYYY'))
  ipad.GetAppointmentPadeg(LoCase(v_post.catalogs.name), 2)
  deparde
  locase(v_dep.catalogs.sdopinf)
  ipad.GetAppointmentPadeg(LoCase(v_post_io.exclassseg.name), 2)
  FIO_RP
  Reason
  iCommission.GetComponentPost(CommissIndex)
  signaturer
.endfields

.begin
  date_doc := strtodate(dDoc, 'DD/MM/YYYY');
  if v_title.getfirst partdoc = tsOk { }
  if v_cont.getfirst contdoc = tsOk { }
  if v_fio.getfirst persons = tsOk { }
  if v_post.getfirst appointments = tsOk
    if v_post.getfirst catalogs = tsOk { }
  if v_dep.getfirst appointments = tsOk
    if v_dep.getfirst catalogs = tsOk { }
  v_date.contdocNrec := v_cont.contdoc.nrec;
  if v_date.getfirst attrnam = tsOk
    if v_date.getfirst attrval = tsOk { }
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
  if v_memo.getfirst titledoc = tsOk
    if v_memo.getfirst partdoc = tsOk
      if v_memo.getfirst contdoc = tsOk
        if v_memo.getfirst prmemo = tsOk { }

  if v_dep.catalogs.longname <> ''
       deparde := ipad.GetDepartmentPadeg(v_dep.catalogs.longname, 2);
  else
       deparde := ipad.GetDepartmentPadeg(v_dep.catalogs.name, 2);

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
  FIO_RP_IO := decl.FIODeclension(NrecPerson, v_name.exclassseg.name, 2);
  FIO_RP := decl.FIODeclension(NrecPerson, v_fio.persons.fio, 2);
end.


.{ Consolidated_Report1 CheckEnter

      ПРИКАЗ
  "^" ^ ^ г.   № ^


О возложении исполнения обязанностей ^ на ^

На время служебной командировки за пределы РФ ^
с ^ по ^ года возложить исполнение обязанностей ^
^
на ^ ^
^

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

.{ Consolidated_Report2 CheckEnter
.{ Consolidated_Report3 CheckEnter
.}
.}
.}

.endform
































